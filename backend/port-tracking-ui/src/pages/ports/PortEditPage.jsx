import { useEffect, useState } from "react";
import { Link, useNavigate, useParams } from "react-router-dom";
import api from "../../services/apiClient";
import PageLayout from "../../components/PageLayout";

export default function PortEditPage() {
  const { id } = useParams();
  const portId = Number(id);
  const navigate = useNavigate();

  const [form, setForm] = useState({
    name: "",
    country: "",
    city: ""
  });

  const [err, setErr] = useState("");
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api.get(`/api/ports/${portId}`)
      .then(res => {
        setForm({
          name: res.data.name || "",
          country: res.data.country || "",
          city: res.data.city || ""
        });
      })
      .catch(e => setErr(e?.response?.data?.message || e.message))
      .finally(() => setLoading(false));
  }, [portId]);

  const onChange = (e) => {
    const { name, value } = e.target;
    setForm(prev => ({ ...prev, [name]: value }));
  };

  const onSubmit = async (e) => {
    e.preventDefault();
    setErr("");

    const payload = {
      portId,
      name: form.name.trim(),
      country: form.country.trim(),
      city: form.city.trim()
    };

    try {
      await api.put(`/api/ports/${portId}`, payload);
      navigate("/ports");
    } catch (e) {
      setErr(e?.response?.data?.message || e.message);
    }
  };

  if (loading) return <p>Yükleniyor…</p>;

  return (
    <PageLayout icon="⚓" title="Liman Düzenle">
      <div className="mb-4">
        <Link to="/ports" className="text-[#2ec4b6] hover:underline">
          ← Ports listesine dön
        </Link>
      </div>

      {err && <p className="text-red-400 mb-4">{err}</p>}

      <form
        onSubmit={onSubmit}
        className="bg-[#0b1e3d] text-white p-6 rounded-lg shadow-lg w-full max-w-4xl mx-auto"
      >
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
          <input
            type="text"
            name="name"
            placeholder="Port Name"
            value={form.name}
            onChange={onChange}
            required
            className="p-2 rounded text-black w-full"
          />
          <input
            type="text"
            name="country"
            placeholder="Country"
            value={form.country}
            onChange={onChange}
            required
            className="p-2 rounded text-black w-full"
          />
          <input
            type="text"
            name="city"
            placeholder="City"
            value={form.city}
            onChange={onChange}
            required
            className="p-2 rounded text-black w-full"
          />
        </div>

        <div className="flex gap-4">
          <button
            type="submit"
            className="bg-green-500 hover:bg-green-600 px-4 py-2 rounded text-white font-semibold"
          >
            Kaydet
          </button>
          <button
            type="button"
            onClick={() => navigate("/ports")}
            className="bg-gray-500 hover:bg-gray-600 px-4 py-2 rounded text-white font-semibold"
          >
            İptal
          </button>
        </div>
      </form>
    </PageLayout>
  );
}
