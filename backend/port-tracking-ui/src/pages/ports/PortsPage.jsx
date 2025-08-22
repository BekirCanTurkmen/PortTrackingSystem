// src/app/pages/ports/PortsPage.jsx
import { Link } from "react-router-dom";
import { useEffect, useState } from "react";
import api from "../../services/apiClient";
import PageLayout from "../../components/PageLayout";

export default function PortsPage() {
  const [ports, setPorts] = useState([]);
  const [err, setErr] = useState("");
  const [loading, setLoading] = useState(true);
  const [deletingId, setDeletingId] = useState(null);
  const [q, setQ] = useState("");

  useEffect(() => {
    load();
  }, []);

  const load = () => {
    setLoading(true);
    api
      .get("/api/ports")
      .then((res) =>
        setPorts(Array.isArray(res.data) ? res.data : res.data?.$values ?? [])
      )
      .catch((e) => setErr(e?.response?.data?.message || e.message))
      .finally(() => setLoading(false));
  };

  const handleDelete = async (id) => {
    if (!confirm("Bu limanı silmek istiyor musun?")) return;
    try {
      setDeletingId(id);
      await api.delete(`/api/ports/${id}`);
      setPorts((prev) => prev.filter((p) => (p.portId ?? p.id) !== id));
    } catch (e) {
      alert(e?.response?.data?.message || e.message || "Silme işlemi başarısız.");
    } finally {
      setDeletingId(null);
    }
  };

  const filtered = ports.filter((p) => {
    const text = `${p.name} ${p.city} ${p.country}`.toLowerCase();
    return text.includes(q.toLowerCase());
  });

  return (
    <PageLayout icon="⚓" title="Liman Yönetimi">
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
                Liman Listesi
              </h2>
              <Link
                to="/ports/new"
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
                + Yeni Liman
              </Link>
            </div>

            {/* Arama kutusu */}
            <div style={{ padding: "0 10px", marginBottom: "15px" }}>
              <input
                value={q}
                onChange={(e) => setQ(e.target.value)}
                placeholder="Ara: liman adı, şehir ya da ülke…"
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
                      <th style={thStyle}>ID</th>
                      <th style={thStyle}>İsim</th>
                      <th style={thStyle}>Şehir</th>
                      <th style={thStyle}>Ülke</th>
                      <th style={thStyle}>Aksiyonlar</th>
                    </tr>
                  </thead>
                  <tbody>
                    {filtered.map((p) => {
                      const id = p.portId ?? p.id;
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
                          <td style={tdStyle}>{p.name}</td>
                          <td style={tdStyle}>{p.city}</td>
                          <td style={tdStyle}>{p.country}</td>
                          <td style={{ ...tdStyle, textAlign: "center" }}>
                            <Link
                              to={`/ports/${id}/edit`}
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
