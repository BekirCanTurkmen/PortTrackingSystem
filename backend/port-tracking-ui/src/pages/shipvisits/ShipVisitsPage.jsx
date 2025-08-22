// src/pages/shipvisits/ShipVisitsPage.jsx
import { useEffect, useState, useMemo } from "react";
import { Link } from "react-router-dom";
import { getVisits, deleteVisit, getShips, getPorts } from "../../services/visit.service";
import PageLayout from "../../components/PageLayout";

export default function ShipVisitsPage() {
  const [visits, setVisits] = useState([]);
  const [ships, setShips] = useState([]);
  const [ports, setPorts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [err, setErr] = useState("");
  const [q, setQ] = useState("");
  const [deletingId, setDeletingId] = useState(null);

  const shipMap = useMemo(() => {
    const m = {};
    ships.forEach((s) => (m[s.shipId] = s.name));
    return m;
  }, [ships]);

  const portMap = useMemo(() => {
    const m = {};
    ports.forEach((p) => (m[p.portId] = p.name));
    return m;
  }, [ports]);

  const load = () => {
    setLoading(true);
    Promise.all([getVisits(), getShips(), getPorts()])
      .then(([v, s, p]) => {
        setVisits(v);
        setShips(s);
        setPorts(p);
      })
      .catch((e) => setErr(e?.response?.data?.message || e.message))
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    load();
  }, []);

  const onDelete = async (id) => {
    if (!confirm("Bu ziyareti silmek istediğinize emin misiniz?")) return;
    try {
      setDeletingId(id);
      await deleteVisit(id);
      load();
    } catch (e) {
      alert(e?.response?.data?.message || e.message);
    } finally {
      setDeletingId(null);
    }
  };

  const filtered = visits.filter((v) => {
    const shipName = v.shipName || v.ship?.name || shipMap[v.shipId] || "";
    const portName = v.portName || v.port?.name || portMap[v.portId] || "";
    const text = `${shipName} ${portName} ${v.purpose}`.toLowerCase();
    return text.includes(q.toLowerCase());
  });

  return (
    <PageLayout icon="🛳" title="Liman Ziyaretleri">
      <div style={{ width: "100%", height: "100%" }}>
        {loading && <p>⏳ Yükleniyor…</p>}
        {err && <p style={{ color: "#ff6b6b" }}>Hata: {err}</p>}

        {!loading && !err && (
          <>
            {/* Üst başlık + buton */}
            <div
              style={{
                display: "flex",
                justifyContent: "space-between",
                alignItems: "center",
                marginBottom: "10px",
                padding: "0 10px",
              }}
            >
              <h2 style={{ fontSize: "20px", fontWeight: "600", color: "#fff" }}>
                Ziyaret Listesi
              </h2>
              <Link
                to="/shipvisits/new"
                style={{
                  background: "#4dd0e1",
                  color: "#0b1e3d",
                  padding: "10px 16px",
                  borderRadius: "6px",
                  fontWeight: "bold",
                  textDecoration: "none",
                  transition: "0.2s",
                }}
              >
                + Yeni Ziyaret
              </Link>
            </div>

            {/* Arama kutusu */}
            <div style={{ padding: "0 10px", marginBottom: "15px" }}>
              <input
                value={q}
                onChange={(e) => setQ(e.target.value)}
                placeholder="Ara: gemi, liman ya da amaç…"
                style={{
                  width: "100%",
                  maxWidth: "300px",
                  padding: "8px 12px",
                  borderRadius: "6px",
                  border: "1px solid rgba(255,255,255,0.3)",
                  background: "rgba(255,255,255,0.1)",
                  color: "#fff",
                  outline: "none",
                }}
              />
            </div>

            {filtered.length === 0 ? (
              <p style={{ color: "#ddd", padding: "0 10px" }}>Kayıt bulunamadı.</p>
            ) : (
              <div style={{ overflowX: "auto" }}>
                <table
                  style={{
                    width: "100%",
                    borderCollapse: "collapse",
                    background: "#1b3b6f",
                    color: "#fff",
                  }}
                >
                  <thead>
                    <tr style={{ background: "#0f2452" }}>
                      <th style={thStyle}>ID</th>
                      <th style={thStyle}>Gemi</th>
                      <th style={thStyle}>Liman</th>
                      <th style={thStyle}>Geliş</th>
                      <th style={thStyle}>Ayrılış</th>
                      <th style={thStyle}>Amaç</th>
                      <th style={thStyle}>Aksiyonlar</th>
                    </tr>
                  </thead>
                  <tbody>
                    {filtered.map((v) => {
                      const shipName = v.shipName || v.ship?.name || shipMap[v.shipId] || v.shipId;
                      const portName = v.portName || v.port?.name || portMap[v.portId] || v.portId;
                      return (
                        <tr
                          key={v.visitId}
                          style={{ background: "#1b3b6f" }}
                          onMouseOver={(e) =>
                            (e.currentTarget.style.background = "#2e5aac")
                          }
                          onMouseOut={(e) =>
                            (e.currentTarget.style.background = "#1b3b6f")
                          }
                        >
                          <td style={tdStyle}>{v.visitId}</td>
                          <td style={tdStyle}>{shipName}</td>
                          <td style={tdStyle}>{portName}</td>
                          <td style={tdStyle}>
                            {v.arrivalDate ? new Date(v.arrivalDate).toLocaleString() : "-"}
                          </td>
                          <td style={tdStyle}>
                            {v.departureDate ? new Date(v.departureDate).toLocaleString() : "-"}
                          </td>
                          <td style={tdStyle}>{v.purpose}</td>
                          <td style={{ ...tdStyle, textAlign: "center" }}>
                            <Link
                              to={`/shipvisits/${v.visitId}/edit`}
                              style={{ color: "#4dd0e1", marginRight: "8px" }}
                            >
                              Düzenle
                            </Link>
                            <button
                              onClick={() => onDelete(v.visitId)}
                              disabled={deletingId === v.visitId}
                              style={{
                                color: "#ff6b6b",
                                background: "transparent",
                                border: "none",
                                cursor: "pointer",
                                opacity: deletingId === v.visitId ? 0.5 : 1,
                              }}
                            >
                              {deletingId === v.visitId ? "Siliniyor…" : "Sil"}
                            </button>
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>
            )}
          </>
        )}
      </div>
    </PageLayout>
  );
}

const thStyle = {
  padding: "10px",
  borderBottom: "2px solid rgba(255,255,255,0.2)",
  textAlign: "left",
};

const tdStyle = {
  padding: "10px",
  borderBottom: "1px solid rgba(255,255,255,0.1)",
};
