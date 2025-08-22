// src/pages/crews/CrewsPage.jsx
import { Link } from "react-router-dom";
import { useEffect, useState } from "react";
import api from "../../services/apiClient";
import PageLayout from "../../components/PageLayout";

export default function CrewsPage() {
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [q, setQ] = useState("");

  useEffect(() => {
    load();
  }, []);

  const load = () => {
    setLoading(true);
    api
      .get("/api/crewmembers")
      .then((res) =>
        setItems(Array.isArray(res.data) ? res.data : res.data?.$values ?? [])
      )
      .catch((err) => setError(err?.message ?? "Bilinmeyen hata"))
      .finally(() => setLoading(false));
  };

  const handleDelete = async (id) => {
    if (!confirm("Bu mürettebatı silmek istiyor musun?")) return;
    try {
      await api.delete(`/api/crewmembers/${id}`);
      setItems((prev) => prev.filter((c) => (c.crewId ?? c.id) !== id));
    } catch (e) {
      alert(e?.response?.data?.message || e.message || "Silme işlemi başarısız.");
    }
  };

  const filtered = items.filter((c) => {
    const text = `${c.firstName} ${c.lastName} ${c.role}`.toLowerCase();
    return text.includes(q.toLowerCase());
  });

  return (
    <PageLayout icon="👥" title="Mürettebat Yönetimi">
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
              <h2
                style={{
                  fontSize: "20px",
                  fontWeight: "600",
                  color: "#fff",
                }}
              >
                Mürettebat Listesi
              </h2>
              <Link
                to="/crews/new"
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
                + Yeni Mürettebat
              </Link>
            </div>

            {/* Arama kutusu */}
            <div style={{ padding: "0 10px", marginBottom: "15px" }}>
              <input
                value={q}
                onChange={(e) => setQ(e.target.value)}
                placeholder="Ara: isim, soyisim ya da rol…"
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
                      <th style={thStyle}>Ad</th>
                      <th style={thStyle}>Soyad</th>
                      <th style={thStyle}>E-posta</th>
                      <th style={thStyle}>Telefon</th>
                      <th style={thStyle}>Rol</th>
                      <th style={thStyle}>Aksiyonlar</th>
                    </tr>
                  </thead>
                  <tbody>
                    {filtered.map((c) => {
                      const id = c.crewId ?? c.id;
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
                          <td style={tdStyle}>{c.crewId}</td>
                          <td style={tdStyle}>{c.firstName}</td>
                          <td style={tdStyle}>{c.lastName}</td>
                          <td style={tdStyle}>{c.email}</td>
                          <td style={tdStyle}>{c.phoneNumber}</td>
                          <td style={tdStyle}>{c.role}</td>
                          <td style={{ ...tdStyle, textAlign: "center" }}>
                            <Link
                              to={`/crews/${id}/edit`}
                              style={{ color: "#4dd0e1", marginRight: "8px" }}
                            >
                              Düzenle
                            </Link>
                            <button
                              onClick={() => handleDelete(id)}
                              style={{
                                color: "#ff6b6b",
                                background: "transparent",
                                border: "none",
                                cursor: "pointer",
                              }}
                            >
                              Sil
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
