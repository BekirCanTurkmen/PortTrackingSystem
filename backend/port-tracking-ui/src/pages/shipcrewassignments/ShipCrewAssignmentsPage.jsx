// src/pages/shipcrew/ShipCrewAssignmentsPage.jsx
import { useEffect, useMemo, useState } from "react";
import { Link } from "react-router-dom";
import { getAssignments, deleteAssignment, getShips, getCrews } from "../../services/assignment.service";
import PageLayout from "../../components/PageLayout";

export default function ShipCrewAssignmentsPage() {
  const [rows, setRows] = useState([]);
  const [ships, setShips] = useState([]);
  const [crews, setCrews] = useState([]);
  const [loading, setLoading] = useState(true);
  const [err, setErr] = useState("");
  const [q, setQ] = useState("");
  const [deletingId, setDeletingId] = useState(null);

  const shipMap = useMemo(() => {
    const m = {};
    ships.forEach((s) => (m[s.shipId] = s.name));
    return m;
  }, [ships]);

  const crewMap = useMemo(() => {
    const m = {};
    crews.forEach((c) => (m[c.crewId] = `${c.firstName} ${c.lastName}`));
    return m;
  }, [crews]);

  const load = () => {
    setLoading(true);
    Promise.all([getAssignments(), getShips(), getCrews()])
      .then(([a, s, c]) => {
        setRows(a);
        setShips(s);
        setCrews(c);
      })
      .catch((e) => setErr(e?.response?.data?.message || e.message))
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    load();
  }, []);

  const onDelete = async (id) => {
    if (!confirm("Bu atamayı silmek istediğinize emin misiniz?")) return;
    try {
      setDeletingId(id);
      await deleteAssignment(id);
      load();
    } catch (e) {
      alert(e?.response?.data?.message || e.message);
    } finally {
      setDeletingId(null);
    }
  };

  const filtered = rows.filter((r) => {
    const shipName = r.ship?.name || shipMap[r.shipId] || "";
    const crewName = r.crew
      ? `${r.crew.firstName} ${r.crew.lastName}`
      : crewMap[r.crewId] || "";
    const text = `${shipName} ${crewName}`.toLowerCase();
    return text.includes(q.toLowerCase());
  });

  return (
    <PageLayout icon="👥" title="Mürettebat Atamaları">
      <div style={{ width: "100%", height: "100%" }}>
        {loading && <p>⏳ Yükleniyor…</p>}
        {err && <p style={{ color: "#ff6b6b" }}>Hata: {err}</p>}

        {!loading && !err && (
          <>
            {/* Üst başlık ve buton */}
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
                Atama Listesi
              </h2>
              <Link
                to="/shipcrewassignments/new"
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
                + Yeni Atama
              </Link>
            </div>

            {/* Arama kutusu */}
            <div style={{ padding: "0 10px", marginBottom: "15px" }}>
              <input
                value={q}
                onChange={(e) => setQ(e.target.value)}
                placeholder="Ara: gemi veya mürettebat adı…"
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

            {/* Tablo */}
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
                      <th style={thStyle}>Assignment ID</th>
                      <th style={thStyle}>Ship</th>
                      <th style={thStyle}>Crew</th>
                      <th style={thStyle}>Assignment Date</th>
                      <th style={thStyle}>Aksiyonlar</th>
                    </tr>
                  </thead>
                  <tbody>
                    {filtered.map((r) => (
                      <tr
                        key={r.assignmentId}
                        style={{ background: "#1b3b6f" }}
                        onMouseOver={(e) =>
                          (e.currentTarget.style.background = "#2e5aac")
                        }
                        onMouseOut={(e) =>
                          (e.currentTarget.style.background = "#1b3b6f")
                        }
                      >
                        <td style={tdStyle}>{r.assignmentId}</td>
                        <td style={tdStyle}>
                          {r.ship?.name || shipMap[r.shipId] || r.shipId}
                        </td>
                        <td style={tdStyle}>
                          {r.crew
                            ? `${r.crew.firstName} ${r.crew.lastName}`
                            : crewMap[r.crewId] || r.crewId}
                        </td>
                        <td style={tdStyle}>
                          {r.assignmentDate
                            ? new Date(r.assignmentDate).toLocaleString()
                            : "-"}
                        </td>
                        <td style={{ ...tdStyle, textAlign: "center" }}>
                          <Link
                            to={`/shipcrewassignments/${r.assignmentId}/edit`}
                            style={{ color: "#4dd0e1", marginRight: "8px" }}
                          >
                            Düzenle
                          </Link>
                          <button
                            onClick={() => onDelete(r.assignmentId)}
                            disabled={deletingId === r.assignmentId}
                            style={{
                              color: "#ff6b6b",
                              background: "transparent",
                              border: "none",
                              cursor: "pointer",
                              opacity: deletingId === r.assignmentId ? 0.5 : 1,
                            }}
                          >
                            {deletingId === r.assignmentId
                              ? "Siliniyor…"
                              : "Sil"}
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
