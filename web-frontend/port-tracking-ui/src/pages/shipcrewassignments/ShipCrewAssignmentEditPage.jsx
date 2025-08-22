import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import api from "../../services/apiClient";
import PageLayout from "../../components/PageLayout";

export default function ShipCrewAssignmentEditPage() {
  const { id } = useParams();
  const nav = useNavigate();

  const [form, setForm] = useState({
    shipId: "",
    crewId: "",
    assignmentDate: ""
  });
  const [err, setErr] = useState("");
  const [loading, setLoading] = useState(true);

  // Veriyi yükle
  useEffect(() => {
    api
      .get(`/api/shipcrewassignments/${id}`)
      .then((res) => {
        setForm({
          shipId: res.data.shipId || "",
          crewId: res.data.crewId || "",
          assignmentDate: res.data.assignmentDate
            ? res.data.assignmentDate.split("T")[0]
            : ""
        });
      })
      .catch((e) => setErr(e?.response?.data?.message || e.message))
      .finally(() => setLoading(false));
  }, [id]);

  const onChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

const onSubmit = async (e) => {
  e.preventDefault();
  setErr("");

  try {
    const payload = {
      AssignmentId: Number(id),
      ShipId: Number(form.shipId),
      CrewId: Number(form.crewId),
      AssignmentDate: `${form.assignmentDate}T00:00:00`
    };

    console.log("PUT url:", `/api/shipcrewassignments/${id}`);
    console.log("PUT payload:", payload);

    await api.put(`/api/shipcrewassignments/${id}`, payload);

    nav("/shipcrewassignments");
  } catch (error) {
    console.error("PUT error:", error.response?.data || error.message);
    setErr(error?.response?.data?.message || error.message);
  }
};


  if (loading) return <p>Yükleniyor...</p>;

  return (
    <PageLayout icon="✏️" title="Mürettebat Ataması Düzenle">
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
            required
          />
          <input
            type="number"
            name="crewId"
            placeholder="Crew ID"
            value={form.crewId}
            onChange={onChange}
            className="p-2 rounded text-black w-full"
            required
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
