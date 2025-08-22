// src/pages/crews/CrewCreatePage.jsx
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import api from "../../services/apiClient";
import PageLayout from "../../components/PageLayout";

export default function CrewCreatePage() {
  const nav = useNavigate();
  const [form, setForm] = useState({
    firstName: "",
    lastName: "",
    email: "",
    phoneNumber: "",
    role: "",
  });
  const [err, setErr] = useState("");

  const onChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const onSubmit = async (e) => {
    e.preventDefault();
    try {
      await api.post("/api/crewmembers", form);
      nav("/crews");
    } catch (error) {
      setErr(error?.response?.data?.message || error.message);
    }
  };

  return (
    <PageLayout icon="👨‍✈️" title="Yeni Mürettebat Ekle">
      <form
        onSubmit={onSubmit}
        className="bg-[#0b1e3d] text-white p-6 rounded-lg shadow-lg w-full max-w-4xl mx-auto"
      >
        {err && <p className="text-red-400 mb-4">{err}</p>}

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
          <input
            type="text"
            name="firstName"
            placeholder="First Name"
            value={form.firstName}
            onChange={onChange}
            className="p-2 rounded text-black w-full"
          />
          <input
            type="text"
            name="lastName"
            placeholder="Last Name"
            value={form.lastName}
            onChange={onChange}
            className="p-2 rounded text-black w-full"
          />
          <input
            type="email"
            name="email"
            placeholder="Email"
            value={form.email}
            onChange={onChange}
            className="p-2 rounded text-black w-full"
          />
          <input
            type="text"
            name="phoneNumber"
            placeholder="Phone Number"
            value={form.phoneNumber}
            onChange={onChange}
            className="p-2 rounded text-black w-full"
          />
          <input
            type="text"
            name="role"
            placeholder="Role"
            value={form.role}
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
            onClick={() => nav("/crews")}
            className="bg-gray-500 hover:bg-gray-600 px-4 py-2 rounded text-white font-semibold"
          >
            İptal
          </button>
        </div>
      </form>
    </PageLayout>
  );
}
