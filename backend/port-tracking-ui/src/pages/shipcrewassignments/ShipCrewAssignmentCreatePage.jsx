import { useState } from "react";
import { useNavigate } from "react-router-dom";
import api from "../../services/apiClient";
import PageLayout from "../../components/PageLayout";

export default function ShipCrewAssignmentCreatePage() {
  const nav = useNavigate();
  const [form, setForm] = useState({
    shipId: "",
    crewId: "",
    role: "",
    startDate: "",
    endDate: ""
  });
  const [err, setErr] = useState("");

  const onChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const onSubmit = async (e) => {
    e.preventDefault();
    setErr("");
    try {
      await api.post("/api/shipcrewassignments", form);
      nav("/shipcrewassignments");
    } catch (error) {
      setErr(error?.response?.data?.message || error.message);
    }
  };

  return (
    <PageLayout icon="👨‍✈️" title="Yeni Mürettebat Ataması">
      <form
        onSubmit={onSubmit}
        className="bg-[#0b1e3d] text-white p-6 rounded-lg shadow-lg w-full max-w-4xl mx-auto"
      >
        {err && <p className="text-red-400 mb-4">{err}</p>}

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
          <input
            type="number"
            name="shipId"
            placeholder="Ship ID"
            value={form.shipId}
            onChange={onChange}
            className="p-2 rounded text-black w-full"
          />
          <input
            type="number"
            name="crewId"
            placeholder="Crew ID"
            value={form.crewId}
            onChange={onChange}
            className="p-2 rounded text-black w-full"
          />
         
         <input
            type="date"
            name="assignmentDate"
            value={form.assignmentDate}
            onChange={onChange}
            className="p-2 rounded text-black w-full"
            required
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
            onClick={() => nav("/shipcrewassignments")}
            className="bg-gray-500 hover:bg-gray-600 px-4 py-2 rounded text-white font-semibold"
          >
            İptal
          </button>
        </div>
      </form>
    </PageLayout>
  );
}
