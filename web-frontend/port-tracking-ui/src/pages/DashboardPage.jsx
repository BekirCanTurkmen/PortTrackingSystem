// src/pages/DashboardPage.jsx
import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import axios from "axios";

export default function DashboardPage() {
  const [stats, setStats] = useState({
    ships: 0,
    ports: 0,
    crews: 0,
    cargoes: 0,
    assignments: 0,
  });

  const API_BASE = "https://localhost:56975/api";

  const getArrayLength = (data) => {
    if (Array.isArray(data)) return data.length;
    if (data?.$values && Array.isArray(data.$values)) return data.$values.length;
    return 0;
  };

  useEffect(() => {
    axios.get(`${API_BASE}/Ships`)
      .then(res => setStats(prev => ({ ...prev, ships: getArrayLength(res.data) })))
      .catch(() => setStats(prev => ({ ...prev, ships: 0 })));

    axios.get(`${API_BASE}/Ports`)
      .then(res => setStats(prev => ({ ...prev, ports: getArrayLength(res.data) })))
      .catch(() => setStats(prev => ({ ...prev, ports: 0 })));

    axios.get(`${API_BASE}/CrewMembers`)
      .then(res => setStats(prev => ({ ...prev, crews: getArrayLength(res.data) })))
      .catch(() => setStats(prev => ({ ...prev, crews: 0 })));

    axios.get(`${API_BASE}/Cargoes`)
      .then(res => setStats(prev => ({ ...prev, cargoes: getArrayLength(res.data) })))
      .catch(() => setStats(prev => ({ ...prev, cargoes: 0 })));

    axios.get(`${API_BASE}/ShipCrewAssignments`)
      .then(res => setStats(prev => ({ ...prev, assignments: getArrayLength(res.data) })))
      .catch(() => setStats(prev => ({ ...prev, assignments: 0 })));
  }, []);

  return (
    <div style={pageStyle}>
      {/* Üst Başlık */}
      <header style={headerStyle}>
        <h1 style={{ margin: 0, color: "#fff", display: "flex", alignItems: "center", gap: "10px" }}>
  <img 
    src="https://arkas.com.tr/wp-content/uploads/2017/07/logo-1.png" 
    alt="Logo" 
    style={{ height: "40px" }}
  />
   Ana Sayfa
</h1>

        <p style={{ margin: 0, color: "#d0d4da" }}>Liman Gemi Takip Sistemi</p>
      </header>

      {/* İçerik Alanı */}
      <main style={mainContent}>
        {/* İstatistik Kartları */}
        <div style={statsGrid}>
          <div style={cardStyle}>
            <h3 style={cardTitle}>🚢 Toplam Gemi</h3>
            <p style={statNumber}>{stats.ships}</p>
          </div>
          <div style={cardStyle}>
            <h3 style={cardTitle}>⚓ Liman Sayısı</h3>
            <p style={statNumber}>{stats.ports}</p>
          </div>
          <div style={cardStyle}>
            <h3 style={cardTitle}>👩‍✈️ Mürettebat</h3>
            <p style={statNumber}>{stats.crews}</p>
          </div>
          <div style={cardStyle}>
            <h3 style={cardTitle}>📦 Yükler</h3>
            <p style={statNumber}>{stats.cargoes}</p>
          </div>
          <div style={cardStyle}>
            <h3 style={cardTitle}>👥 Atamalar</h3>
            <p style={statNumber}>{stats.assignments}</p>
          </div>
        </div>

        {/* Hızlı Erişim */}
        <div style={{ marginTop: "40px" }}>
          <h2 style={{ color: "#fff", marginBottom: "10px" }}>🔗 Hızlı Erişim</h2>
          <div style={quickLinks}>
            <Link to="/ships" style={btnStyle}>🚢 Gemi Yönetimi</Link>
            <Link to="/ports" style={btnStyle}>⚓ Liman Yönetimi</Link>
            <Link to="/shipvisits" style={btnStyle}>🗓️ Ziyaret Kayıtları</Link>
            <Link to="/cargoes" style={btnStyle}>📦 Yük Yönetimi</Link>
            <Link to="/crews" style={btnStyle}>👨‍✈️ Mürettebat Yönetimi</Link>
            <Link to="/shipcrewassignments" style={btnStyle}>👥 Gemi-Mürettebat Atamaları</Link>
          </div>
        </div>
      </main>
    </div>
  );
}

// 🎨 Stil
const pageStyle = {
  background: "linear-gradient(to bottom, #0b1e3d, #112a54)",
  width: "100vw",
  height: "100vh",
  display: "flex",
  flexDirection: "column",
  fontFamily: "'Segoe UI', sans-serif",
};

const headerStyle = {
  padding: "20px",
  borderBottom: "2px solid rgba(255,255,255,0.1)",
  flexShrink: 0,
};

const mainContent = {
  flex: 1,
  padding: "20px",
  overflowY: "auto",
};

const statsGrid = {
  display: "grid",
  gridTemplateColumns: "repeat(auto-fit, minmax(220px, 1fr))",
  gap: "20px",
};

const cardStyle = {
  background: "#1b3b6f",
  padding: "20px",
  borderRadius: "8px",
  boxShadow: "0 4px 15px rgba(0,0,0,0.2)",
  textAlign: "center",
  color: "#fff",
  border: "1px solid rgba(255,255,255,0.1)",
};

const cardTitle = {
  margin: "0",
  fontSize: "16px",
  color: "#d0e2ff",
};

const statNumber = {
  fontSize: "32px",
  fontWeight: "bold",
  marginTop: "10px",
  color: "#4dd0e1",
};

const quickLinks = {
  display: "flex",
  flexWrap: "wrap",
  gap: "10px",
};

const btnStyle = {
  background: "#4dd0e1",
  color: "#0b1e3d",
  padding: "10px 16px",
  borderRadius: "6px",
  textDecoration: "none",
  fontWeight: "bold",
  transition: "0.2s",
  display: "flex",
  alignItems: "center",
  gap: "6px",
};
