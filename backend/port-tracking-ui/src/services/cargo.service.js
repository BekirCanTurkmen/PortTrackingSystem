// src/services/cargo.service.js
import api from "./apiClient";

// .NET bazen {"$values":[...]} döndürür; normalize edelim
const toList = (data) => (Array.isArray(data) ? data : (data?.$values ?? []));

// küçük yardımcı: önce cargoes, 404 olursa cargoes dene
const tryGet = async (path) => {
  try {
    return await api.get(path);
  } catch (e) {
    if (e?.response?.status === 404) {
      // Cargoes (controller ismi) fallback
      const alt = path.replace("/cargoes", "/cargoes");
      return await api.get(alt);
    }
    throw e;
  }
};
const tryPost = async (path, payload) => {
  try {
    return await api.post(path, payload);
  } catch (e) {
    if (e?.response?.status === 404) {
      const alt = path.replace("/cargoes", "/cargoes");
      return await api.post(alt, payload);
    }
    throw e;
  }
};
const tryPut = async (path, payload) => {
  try {
    return await api.put(path, payload);
  } catch (e) {
    if (e?.response?.status === 404) {
      const alt = path.replace("/cargoes", "/cargoes");
      return await api.put(alt, payload);
    }
    throw e;
  }
};
const tryDelete = async (path) => {
  try {
    return await api.delete(path);
  } catch (e) {
    if (e?.response?.status === 404) {
      const alt = path.replace("/cargoes", "/cargoes");
      return await api.delete(alt);
    }
    throw e;
  }
};

// CRUD
export const getCargoes = async () => {
  const res = await tryGet("/api/cargoes");
  return toList(res.data);
};

export const getCargo = async (id) => {
  const res = await tryGet(`/api/cargoes/${id}`);
  return res.data;
};

export const createCargo = async (payload) => {
  const res = await tryPost("/api/cargoes", payload);
  return res.data;
};

export const updateCargo = async (id, payload) => {
  const res = await tryPut(`/api/cargoes/${id}`, payload);
  return res.data;
};

export const deleteCargo = async (id) => {
  const res = await tryDelete(`/api/cargoes/${id}`);
  return res.data;
};

// dropdown için gemiler
export const getShips = async () => {
  const res = await api.get("/api/ships");
  return toList(res.data);
};
