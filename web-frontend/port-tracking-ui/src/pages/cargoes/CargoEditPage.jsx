import { useState, useEffect } from "react";
import { useNavigate, useParams } from "react-router-dom";
import api from "../../services/apiClient";
import PageLayout from "../../components/PageLayout";

export default function CargoEditPage() {
  const nav = useNavigate();
  const { id } = useParams();
  const [ships, setShips] = useState([]);
  const [form, setForm] = useState({
    shipId: "",
    description: "",
    weightTon: "",
    cargoType: ""
  });
  const [err, setErr] = useState("");

  // Sayfa açıldığında gemiler + düzenlenecek cargo bilgisini çek
  useEffect(() => {
    Promise.all([api.get("/api/ships"), api.get(`/api/cargoes/${id}`)])
      .then(([shipRes, cargoRes]) => {
        setShips(shipRes.data.$values || shipRes.data || []);

        const cargo = cargoRes.data;
        setForm({
          shipId: cargo.shipId.toString(),
          description: cargo.description,
          weightTon: cargo.weightTon.toString(),
          cargoType: cargo.cargoType
        });
      })
      .catch((e) => setErr(e?.response?.data?.message || e.message));
  }, [id]);

  const onChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const onSubmit = async (e) => {
    e.preventDefault();
    setErr("");
    try {
      await api.put(`/api/cargoes/${id}`, {
        cargoId: Number(id),
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
    <PageLayout icon="✏️" title="Yük Düzenle">
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
            className="bg-blue-500 hover:bg-blue-600 px-4 py-2 rounded text-white font-semibold"
          >
            Güncelle
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
