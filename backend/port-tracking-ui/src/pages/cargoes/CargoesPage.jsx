import { useEffect, useMemo, useState } from "react";
import { Link } from "react-router-dom";
import { getCargoes, deleteCargo, getShips } from "../../services/cargo.service";
import PageLayout from "../../components/PageLayout";

export default function CargoesPage() {
  const [rows, setRows] = useState([]);
  const [ships, setShips] = useState([]);
  const [loading, setLoading] = useState(true);
  const [err, setErr] = useState("");

  const shipMap = useMemo(() => {
    const m = {};
    ships.forEach((s) => (m[s.Id] = s.Id));
    return m;
  }, [ships]);

  const load = () => {
    setLoading(true);
    Promise.all([getCargoes(), getShips()])
      .then(([cargos, ships]) => {
        setRows(cargos);
        setShips(ships);
      })
      .catch((e) => setErr(e?.response?.data?.message || e.message))
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    load();
  }, []);

  const onDelete = async (id) => {
    if (!confirm("Bu yük kaydını silmek istediğinize emin misiniz?")) return;
    try {
      await deleteCargo(id);
      load();
    } catch (e) {
      alert(e?.response?.data?.message || e.message);
    }
  };

  return (
    <PageLayout icon="📦" title="Yük Yönetimi">
      <div style={{ width: "100%", height: "100%" }}>
        {loading && <p>⏳ Yükleniyor…</p>}
        {err && <p style={{ color: "#ff6b6b" }}>Hata: {err}</p>}

        {!loading && !err && (
          <>
            <div style={{
              display: "flex",
              justifyContent: "space-between",
              alignItems: "center",
              marginBottom: "20px",
              padding: "0 10px"
            }}>
              <h2 style={{ fontSize: "20px", fontWeight: "600", color: "#fff" }}>Yük Listesi</h2>
              <Link
                to="/cargoes/new"
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
                + Yeni Yük
              </Link>
            </div>

            {rows.length === 0 ? (
              <p style={{ color: "#ddd", padding: "0 10px" }}>Hiç yük kaydı yok.</p>
            ) : (
              <div style={{ overflowX: "auto" }}>
                <table style={{
                  width: "100%",
                  borderCollapse: "collapse",
                  background: "#1b3b6f",
                  color: "#fff"
                }}>
                  <thead>
                    <tr style={{ background: "#0f2452" }}>
                      <th style={thStyle}>CargoId</th>
                      <th style={thStyle}>Ship</th>
                      <th style={thStyle}>Description</th>
                      <th style={thStyle}>Weight (ton)</th>
                      <th style={thStyle}>Cargo Type</th>
                      <th style={thStyle}>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    {rows.map((r) => (
                      <tr key={r.cargoId}
                        style={{ background: "#1b3b6f" }}
                        onMouseOver={(e) => e.currentTarget.style.background = "#2e5aac"}
                        onMouseOut={(e) => e.currentTarget.style.background = "#1b3b6f"}
                      >
                        <td style={tdStyle}>{r.cargoId}</td>
                        <td style={tdStyle}>{r.ship?.name || shipMap[r.shipId] || r.shipId}</td>
                        <td style={tdStyle}>{r.description}</td>
                        <td style={tdStyle}>{r.weightTon}</td>
                        <td style={tdStyle}>{r.cargoType}</td>
                        <td style={{ ...tdStyle, textAlign: "center" }}>
                          <Link to={`/cargoes/${r.cargoId}/edit`} style={{ color: "#4dd0e1", marginRight: "8px" }}>
                            Düzenle
                          </Link>
                          <button
                            onClick={() => onDelete(r.cargoId)}
                            style={{
                              color: "#ff6b6b",
                              background: "transparent",
                              border: "none",
                              cursor: "pointer"
                            }}
                          >
                            Sil
                          </button>
                        </td>
                      </tr>
                    ))}
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
