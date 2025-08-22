// src/services/assignment.service.js
import api from "./apiClient";

// .NET bazen {"$values":[...]} döndürebilir, normalize edelim
const toList = (data) => (Array.isArray(data) ? data : (data?.$values ?? []));

export const getAssignments = async () => {
  const res = await api.get("/api/shipcrewassignments");
  return toList(res.data);
};

export const getAssignment = async (id) => {
  const res = await api.get(`/api/shipcrewassignments/${id}`);
  return res.data;
};

export const createAssignment = async (payload) => {
  const res = await api.post("/api/shipcrewassignments", payload);
  return res.data;
};

export const updateAssignment = async (id, payload) => {
  const res = await api.put(`/api/shipcrewassignments/${id}`, payload);
  return res.data;
};

export const deleteAssignment = async (id) => {
  const res = await api.delete(`/api/shipcrewassignments/${id}`);
  return res.data;
};

// Dropdown’lar için: mevcut ship/crew servislerin de var ama
// burada da güvenli helper kullanmak istersek:
export const getShips = async () => {
  const res = await api.get("/api/ships");
  return toList(res.data);
};

export const getCrews = async () => {
  const res = await api.get("/api/crewmembers");
  return toList(res.data);
};
