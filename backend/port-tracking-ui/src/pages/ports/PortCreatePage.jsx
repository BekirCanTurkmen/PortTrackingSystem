// src/pages/ports/PortCreatePage.jsx
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import PageLayout from "../../components/PageLayout";

export default function PortCreatePage() {
  const nav = useNavigate();
  const [form, setForm] = useState({
    name: "",
    city: "",
    country: "",
  });
  const [err, setErr] = useState("");

  const onChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const onSubmit = async (e) => {
    e.preventDefault();
    try {
      await axios.post("http://localhost:5000/api/ports", form);
      nav("/ports");
    } catch (error) {
      setErr(error?.response?.data?.message || error.message);
    }
  };

  return (
    <PageLayout title="Yeni Liman Ekle">
      <form
        onSubmit={onSubmit}
        className="bg-[#0b1e3d] text-white p-6 rounded-lg shadow-lg w-full max-w-4xl mx-auto"
      >
        {err && <p className="text-red-400 mb-4">{err}</p>}

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
          <input
            type="text"
            name="name"
            placeholder="Port Name"
            value={form.name}
            onChange={onChange}
            className="p-2 rounded text-black w-full"
          />
          <input
            type="text"
            name="city"
            placeholder="City"
            value={form.city}
            onChange={onChange}
            className="p-2 rounded text-black w-full"
          />
          <input
            type="text"
            name="country"
            placeholder="Country"
            value={form.country}
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
            onClick={() => nav("/ports")}
            className="bg-gray-500 hover:bg-gray-600 px-4 py-2 rounded text-white font-semibold"
          >
            İptal
          </button>
        </div>
      </form>
    </PageLayout>
  );
}
