// src/services/port.service.js
import api from "./apiClient";

export async function getPorts() {
  const res = await api.get("/api/ports");
  return res.data;
}

export async function createPort(portData) {
  const res = await api.post("/api/ports", portData);
  return res.data;
}

export async function getPortById(id) {
  const res = await api.get(`/api/ports/${id}`);
  return res.data;
}

export async function updatePort(id, portData) {
  const res = await api.put(`/api/ports/${id}`, portData);
  return res.data;
}

export async function deletePort(id) {
  const res = await api.delete(`/api/ports/${id}`);
  return res.data;
}
