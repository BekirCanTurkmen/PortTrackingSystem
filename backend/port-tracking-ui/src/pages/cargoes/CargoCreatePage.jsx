import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import api from "../../services/apiClient";
import PageLayout from "../../components/PageLayout";

export default function CargoCreatePage() {
  const nav = useNavigate();
  const [ships, setShips] = useState([]);
  const [form, setForm] = useState({
    shipId: "",
    description: "",
    weightTon: "",
    cargoType: ""
  });
  const [err, setErr] = useState("");

  // gemileri yükle
  useEffect(() => {
    api
      .get("/api/ships")
      .then((res) => {
        setShips(res.data.$values || res.data || []);
      })
      .catch((e) => setErr(e?.response?.data?.message || e.message));
  }, []);

  const onChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const onSubmit = async (e) => {
    e.preventDefault();
    setErr("");
    try {
      await api.post("/api/cargoes", {
        shipId: Number(form.shipId),
        description: form.description,
        weightTon: Number(form.weightTon),
        cargoType: form.cargoType
      });
      nav("/cargoes");
    } catch (error) {
      setErr(error?.response?.data?.message || error.message);
    }
  };

  return (
    <PageLayout icon="📦" title="Yeni Yük Ekle">
      <form
        onSubmit={onSubmit}
        className="bg-[#0b1e3d] text-white p-6 rounded-lg shadow-lg w-full max-w-4xl mx-auto"
      >
        {err && <p className="text-red-400 mb-4">{err}</p>}

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
          {/* Ship dropdown */}
          <select
            name="shipId"
            value={form.shipId}
            onChange={onChange}
            className="p-2 rounded text-black w-full"
          >
            <option value="">-- Gemi Seç --</option>
            {ships.map((s) => (
              <option key={s.shipId} value={s.shipId}>
                {s.name} ({s.imo})
              </option>
            ))}
          </select>

          {/* Description */}
          <input
            type="text"
            name="description"
            placeholder="Yük Açıklaması"
            value={form.description}
            onChange={onChange}
            className="p-2 rounded text-black w-full"
          />

          {/* WeightTon */}
          <input
            type="number"
            name="weightTon"
            placeholder="Ağırlık (ton)"
            value={form.weightTon}
            onChange={onChange}
            className="p-2 rounded text-black w-full"
          />

          {/* CargoType */}
          <input
            type="text"
            name="cargoType"
            placeholder="Yük Tipi (örn: General, Dangerous)"
            value={form.cargoType}
            onChange={onChange}
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
            onClick={() => nav("/cargoes")}
            className="bg-gray-500 hover:bg-gray-600 px-4 py-2 rounded text-white font-semibold"
          >
            İptal
          </button>
        </div>
      </form>
    </PageLayout>
  );
}
