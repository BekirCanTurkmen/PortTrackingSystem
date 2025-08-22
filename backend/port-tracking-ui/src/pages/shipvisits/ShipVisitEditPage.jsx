import { useState, useEffect } from "react";
import { useNavigate, useParams } from "react-router-dom";
import api from "../../services/apiClient";
import PageLayout from "../../components/PageLayout";

export default function ShipVisitEditPage() {
  const nav = useNavigate();
  const { id } = useParams();
  const [ships, setShips] = useState([]);
  const [ports, setPorts] = useState([]);
  const [form, setForm] = useState({
    shipId: "",
    portId: "",
    arrivalDate: "",
    departureDate: "",
    purpose: ""
  });
  const [err, setErr] = useState("");

  // Sayfa açıldığında gemiler, limanlar ve düzenlenecek ziyaret bilgisini getir
  useEffect(() => {
    Promise.all([
      api.get("/api/ships"),
      api.get("/api/ports"),
      api.get(`/api/shipvisits/${id}`)
    ])
      .then(([shipRes, portRes, visitRes]) => {
        setShips(shipRes.data.$values || shipRes.data || []);
        setPorts(portRes.data.$values || portRes.data || []);

        const visit = visitRes.data;
        setForm({
          shipId: visit.shipId.toString(),
          portId: visit.portId.toString(),
          arrivalDate: visit.arrivalDate.slice(0, 16), // "YYYY-MM-DDTHH:mm"
          departureDate: visit.departureDate.slice(0, 16),
          purpose: visit.purpose
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
      await api.put(`/api/shipvisits/${id}`, {
        visitId: Number(id),
        shipId: Number(form.shipId),
        portId: Number(form.portId),
        arrivalDate: form.arrivalDate,
        departureDate: form.departureDate,
        purpose: form.purpose
      });
      nav("/shipvisits");
    } catch (error) {
      setErr(error?.response?.data?.message || error.message);
    }
  };

  return (
    <PageLayout icon="🛠️" title="Gemi Ziyareti Düzenle">
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

          {/* Port dropdown */}
          <select
            name="portId"
            value={form.portId}
            onChange={onChange}
            className="p-2 rounded text-black w-full"
          >
            <option value="">-- Liman Seç --</option>
            {ports.map((p) => (
              <option key={p.portId} value={p.portId}>
                {p.name} - {p.city}
              </option>
            ))}
          </select>

          {/* Tarihler */}
          <input
            type="datetime-local"
            name="arrivalDate"
            value={form.arrivalDate}
            onChange={onChange}
            className="p-2 rounded text-black w-full"
          />
          <input
            type="datetime-local"
            name="departureDate"
            value={form.departureDate}
            onChange={onChange}
            className="p-2 rounded text-black w-full"
          />

          {/* Purpose */}
          <input
            type="text"
            name="purpose"
            placeholder="Amaç (Yükleme, Bakım...)"
            value={form.purpose}
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
            onClick={() => nav("/shipvisits")}
            className="bg-gray-500 hover:bg-gray-600 px-4 py-2 rounded text-white font-semibold"
          >
            İptal
          </button>
        </div>
      </form>
    </PageLayout>
  );
}
