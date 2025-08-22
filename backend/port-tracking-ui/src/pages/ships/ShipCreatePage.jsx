import { useState } from "react";
import { useNavigate } from "react-router-dom";
import api from "../../services/apiClient";
import PageLayout from "../../components/PageLayout";

export default function ShipCreatePage() {
  const nav = useNavigate();
  const [form, setForm] = useState({
    name: "",
    type: "",
    flag: "",
    imo: "",
    yearBuilt: "",
  });

  const shipImages = {
    Container: "https://www.ercangumrukleme.com/yuklemeler/gemi-turleri-ve-kullanim-amaclari.jpg",
    Tanker: "https://armatorlerbirligi.org.tr/wp-content/uploads/2019/10/image024.jpg",
    Cargo: "https://dargeb.com/wp-content/uploads/2021/02/Subat-20.jpg",
    Passenger: "https://i.gazeteoksijen.com/storage/files/images/2022/10/23/dunyanin-en-buyuk-yolcu-gemisi-2024te-denize-acilacak-HIUO.jpg",
  };

  const [loading, setLoading] = useState(false);
  const [err, setErr] = useState("");

  const onChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const onSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setErr("");
    try {
      await api.post("/api/ships", form);
      nav("/ships");
    } catch (error) {
      setErr(error?.response?.data?.message || error.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <PageLayout icon="🚢" title="Yeni Gemi Ekle">
      {err && <p className="text-red-400 mb-4">{err}</p>}
      <form onSubmit={onSubmit} className="space-y-4 max-w-lg">
        <input
          type="text"
          name="name"
          placeholder="Ship Name"
          value={form.name}
          onChange={onChange}
          className="w-full p-2 rounded bg-gray-800 text-white"
          required
        />
        <input
          type="text"
          name="type"
          placeholder="Ship Type"
          value={form.type}
          onChange={onChange}
          className="w-full p-2 rounded bg-gray-800 text-white"
        />
        <input
          type="text"
          name="flag"
          placeholder="Flag"
          value={form.flag}
          onChange={onChange}
          className="w-full p-2 rounded bg-gray-800 text-white"
        />

        {/* IMO Alanı */}
        <div className="flex items-center w-full p-2 rounded bg-gray-800 text-white">
          <span className="mr-2">IMO</span>
          <input
            type="text"
            name="imo"
            placeholder="1234567"
            value={form.imo.replace(/^IMO/, "") || ""}
            onChange={(e) => {
              const digits = e.target.value.replace(/\D/g, "").slice(0, 7);
              setForm((prev) => ({ ...prev, imo: "IMO" + digits }));
            }}
            className="flex-1 bg-transparent outline-none"
            required
          />
        </div>

        <input
          type="number"
          name="yearBuilt"
          placeholder="Year Built"
          value={form.yearBuilt}
          onChange={onChange}
          className="w-full p-2 rounded bg-gray-800 text-white"
        />

        <div className="flex gap-4">
          <button
            type="submit"
            disabled={loading}
            className="bg-green-500 px-4 py-2 rounded text-white font-bold hover:bg-green-600"
          >
            {loading ? "Kaydediliyor..." : "Kaydet"}
          </button>
          <button
            type="button"
            onClick={() => nav("/ships")}
            className="bg-gray-500 px-4 py-2 rounded text-white font-bold hover:bg-gray-600"
          >
            İptal
          </button>
        </div>

        {form.type && shipImages[form.type] && (
          <div style={{ marginTop: "20px", textAlign: "center" }}>
            <img
              src={shipImages[form.type]}
              alt={form.type}
              style={{
                width: "250px",
                height: "150px",
                objectFit: "cover",
                borderRadius: "8px",
                border: "2px solid rgba(255,255,255,0.2)",
              }}
            />
          </div>
        )}
      </form>
    </PageLayout>
  );
}
