import { Link, Outlet } from "react-router-dom";

export default function AppLayout() {
  return (
    <div className="min-h-screen flex flex-col bg-gradient-to-b from-[#0b1e3d] to-[#112a54] text-white">
      {/* NAVBAR */}
      <header className="bg-gradient-to-r from-[#0F2452] to-[#1F3C88] shadow-lg">
        <div className="w-full px-6 py-4 flex justify-between items-center">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-full bg-white"></div>
            <span className="text-white text-2xl font-bold">Port Tracking</span>
          </div>
          <nav className="flex gap-6">
            <Link className="text-white hover:text-[#FFD700] transition" to="/">Ana Sayfa</Link>
            <Link className="text-white hover:text-[#FFD700] transition" to="/ships">Gemiler</Link>
            <Link className="text-white hover:text-[#FFD700] transition" to="/ports">Limanlar</Link>
            <Link className="text-white hover:text-[#FFD700] transition" to="/crews">Mürettebat</Link>
            <Link className="text-white hover:text-[#FFD700] transition" to="/shipvisits">Gemi Ziyaretleri</Link>
            <Link className="text-white hover:text-[#FFD700] transition" to="/cargoes">Yükler</Link>
            <Link className="text-white hover:text-[#FFD700] transition" to="/shipcrewassignments">Crew Assignments</Link>
          </nav>
        </div>
      </header>

      {/* CONTENT */}
      <main className="flex-grow w-full p-6 bg-[#0b1e3d]">
         <Outlet />
      </main>


      {/* FOOTER */}
      <footer className="bg-[#0F2452] text-white">
        <div className="w-full px-6 py-8 grid grid-cols-1 md:grid-cols-3 gap-6">
          <div>
            <h3 className="font-bold text-lg mb-2">Port Tracking</h3>
            <p className="text-sm">Your reliable partner in maritime logistics.</p>
          </div>
          <div>
            <h3 className="font-bold text-lg mb-2">Quick Links</h3>
            <ul className="space-y-1 text-sm">
              <li><Link to="/ships" className="hover:text-[#FFD700]">Ships</Link></li>
              <li><Link to="/ports" className="hover:text-[#FFD700]">Ports</Link></li>
              <li><Link to="/crews" className="hover:text-[#FFD700]">Crews</Link></li>
            </ul>
          </div>
          <div>
            <h3 className="font-bold text-lg mb-2">Contact</h3>
            <p className="text-sm">Email: info@porttracking.com</p>
            <p className="text-sm">Phone: +90 212 123 4567</p>
          </div>
        </div>
        <div className="bg-[#0B1B3A] text-center py-3 text-xs">
          © {new Date().getFullYear()} Port Tracking. All rights reserved.
        </div>
      </footer>
    </div>
  );
}
