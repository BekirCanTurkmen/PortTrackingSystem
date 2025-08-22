import { BrowserRouter, Routes, Route, Link, Outlet } from "react-router-dom";
import Dashboard from "../pages/DashboardPage.jsx";
import CrewsPage from "../pages/crews/CrewsPage.jsx";
import PortsPage from "../pages/ports/PortsPage.jsx";
import ShipsPage from "../pages/ships/ShipsPage.jsx";
import ShipCreatePage from "../pages/ships/ShipCreatePage.jsx";
import ShipEditPage from "../pages/ships/ShipEditPage.jsx";
import PortCreatePage from "../pages/ports/PortCreatePage.jsx";
import CrewCreatePage from "../pages/crews/CrewCreatePage.jsx";
import PortEditPage from "../pages/ports/PortEditPage.jsx";
import CrewEditPage from "../pages/crews/CrewEditPage.jsx";

// ✅ ShipVisit sayfaları
import ShipVisitsPage from "../pages/shipvisits/ShipVisitsPage.jsx";
import ShipVisitCreatePage from "../pages/shipvisits/ShipVisitCreatePage.jsx";
import ShipVisitEditPage from "../pages/shipvisits/ShipVisitEditPage.jsx";

// ✅ ShipCrewAssignments sayfaları
import ShipCrewAssignmentsPage from "../pages/shipcrewassignments/ShipCrewAssignmentsPage.jsx";
import ShipCrewAssignmentCreatePage from "../pages/shipcrewassignments/ShipCrewAssignmentCreatePage.jsx";
import ShipCrewAssignmentEditPage from "../pages/shipcrewassignments/ShipCrewAssignmentEditPage.jsx";

import CargoesPage from "../pages/cargoes/CargoesPage.jsx";
import CargoCreatePage from "../pages/cargoes/CargoCreatePage.jsx";
import CargoEditPage from "../pages/cargoes/CargoEditPage.jsx";

function Layout() {
  return (
    <div style={{ padding: "24px" }}>
      <nav style={{ marginBottom: "16px" }}>
        <Link to="/" style={{ marginRight: 12 }}>Ana Sayfa</Link>
        <Link to="/crews" style={{ marginRight: 12 }}>Mürettebat</Link>
        <Link to="/ports" style={{ marginRight: 12 }}>Limanlar</Link>
        <Link to="/ships" style={{ marginRight: 12 }}>Gemiler</Link>
        {/* ✅ ShipVisits menü linki */}
        <Link to="/shipvisits" style={{ marginRight: 12 }}>Gemi Ziyaretleri</Link>
        {/* ✅ ShipCrewAssignments menü linki */}
        <Link to="/shipcrewassignments" style={{ marginRight: 12 }}>ShipCrewAssignments</Link>

        <Link to="/cargoes" style={{ marginRight: 12 }}>Yükler</Link>
      </nav>
      <Outlet />
    </div>
  );
}

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route element={<Layout />}>
          <Route index element={<Dashboard />} />

          {/* mevcutlar */}
          <Route path="crews" element={<CrewsPage />} />
          <Route path="crews/new" element={<CrewCreatePage />} />
          <Route path="crews/:id/edit" element={<CrewEditPage />} />

          <Route path="ports" element={<PortsPage />} />
          <Route path="ports/new" element={<PortCreatePage />} />
          <Route path="ports/:id/edit" element={<PortEditPage />} />

          <Route path="ships" element={<ShipsPage />} />
          <Route path="ships/new" element={<ShipCreatePage />} />
          <Route path="ships/:id/edit" element={<ShipEditPage />} />

          {/* ✅ ShipVisits rotaları */}
          <Route path="shipvisits" element={<ShipVisitsPage />} />
          <Route path="shipvisits/new" element={<ShipVisitCreatePage />} />
          <Route path="shipvisits/:id/edit" element={<ShipVisitEditPage />} />

          {/* ✅ ShipCrewAssignments rotaları */}
          <Route path="shipcrewassignments" element={<ShipCrewAssignmentsPage />} />
          <Route path="shipcrewassignments/new" element={<ShipCrewAssignmentCreatePage />} />
          <Route path="shipcrewassignments/:id/edit" element={<ShipCrewAssignmentEditPage />} />

          <Route path="cargoes" element={<CargoesPage />} />
          <Route path="cargoes/new" element={<CargoCreatePage />} /> 
          <Route path="cargoes/:id/edit" element={<CargoEditPage />} /> 
        </Route>
      </Routes>
    </BrowserRouter>
  );
}