// src/pages/ships/ShipsPage.jsx
import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import api from "../../services/apiClient";
import PageLayout from "../../components/PageLayout";

// .NET koleksiyon normalizasyonu
function toArray(d) {
  if (Array.isArray(d)) return d;
  if (Array.isArray(d?.items)) return d.items;
  if (Array.isArray(d?.value)) return d.value;
  if (Array.isArray(d?.$values)) return d.$values;
  return d ? [d] : [];
}

export default function ShipsPage() {
  const [ships, setShips] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [q, setQ] = useState("");
  const [deletingId, setDeletingId] = useState(null);

  const load = () => {
    setLoading(true);
    api
      .get("/api/ships")
      .then((res) => setShips(toArray(res.data)))
      .catch((e) => setError(e?.response?.data?.message || e.message))
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    load();
  }, []);

  const handleDelete = async (id) => {
    if (!confirm("Bu gemiyi silmek istiyor musunuz?")) return;
    try {
      setDeletingId(id);
      await api.delete(`/api/ships/${id}`);
      setShips((prev) => prev.filter((s) => (s.shipId ?? s.id) !== id));
    } catch (e) {
      alert(e?.response?.data?.message || e.message);
    } finally {
      setDeletingId(null);
    }
  };

  const filtered = ships.filter((s) => {
    const text = `${s.name} ${s.type} ${s.flag} ${s.imo}`.toLowerCase();
    return text.includes(q.toLowerCase());
  });

  return (
    <PageLayout icon="🚢" title="Gemi Yönetimi">
      <div style={{ width: "100%", height: "100%" }}>
        
        {loading && <p>⏳ Yükleniyor…</p>}
        {error && <p style={{ color: "#ff6b6b" }}>Hata: {error}</p>}

        {!loading && !error && (
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
                Gemi Listesi
              </h2>
              <Link
                to="/ships/new"
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
                + Yeni Gemi
              </Link>
            </div>

            {/* Arama kutusu */}
            <div style={{ padding: "0 10px", marginBottom: "15px" }}>
              <input
                value={q}
                onChange={(e) => setQ(e.target.value)}
                placeholder="Ara: gemi adı, tür, bayrak, IMO…"
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
                      <th style={thStyle}>Ship ID</th>
                      <th style={thStyle}>Name</th>
                      <th style={thStyle}>Type</th>
                      <th style={thStyle}>Flag</th>
                      <th style={thStyle}>IMO</th>
                      <th style={thStyle}>Year Built</th>
                      <th style={thStyle}>Aksiyonlar</th>
                    </tr>
                  </thead>
                  <tbody>
                    {filtered.map((s) => {
                      const id = s.shipId ?? s.id;
                      return (
                        <tr
                          key={id}
                          style={{ background: "#1b3b6f" }}
                          onMouseOver={(e) =>
                            (e.currentTarget.style.background = "#2e5aac")
                          }
                          onMouseOut={(e) =>
                            (e.currentTarget.style.background = "#1b3b6f")
                          }
                        >
                          <td style={tdStyle}>{id}</td>
                          <td style={tdStyle}>{s.name ?? "—"}</td>
                          <td style={tdStyle}>{s.type ?? "—"}</td>
                          <td style={tdStyle}>{s.flag ?? "—"}</td>
                          <td style={tdStyle}>{s.imo ?? "—"}</td>
                          <td style={tdStyle}>{s.yearBuilt ?? "—"}</td>
                          <td style={{ ...tdStyle, textAlign: "center" }}>
                            <Link
                              to={`/ships/${id}/edit`}
                              style={{ color: "#4dd0e1", marginRight: "8px" }}
                            >
                              Düzenle
                            </Link>
                            <button
                              onClick={() => handleDelete(id)}
                              disabled={deletingId === id}
                              style={{
                                color: "#ff6b6b",
                                background: "transparent",
                                border: "none",
                                cursor: "pointer",
                                opacity: deletingId === id ? 0.5 : 1,
                              }}
                            >
                              {deletingId === id ? "Siliniyor…" : "Sil"}
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
