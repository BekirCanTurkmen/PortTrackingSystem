export default function PageLayout({ icon, title, children, extraStyle }) {
  return (
    <div style={{ ...pageStyle, ...extraStyle }}>
      <header style={headerStyle}>
        <h1 style={titleStyle}>
          {/* Logo */}
          <img 
            src="https://arkas.com.tr/wp-content/uploads/2017/07/logo-1.png" 
            alt="Logo" 
            style={{ height: "40px", marginRight: "10px" }}
          />
          <span>{icon}</span> {title}
        </h1>
      </header>
      <main style={contentStyle}>{children}</main>
    </div>
  );
}


const pageStyle = {
  background: "linear-gradient(to bottom, #0b1e3d, #112a54)",
  width: "100vw",
  minHeight: "100vh", // yükseklik en az ekran boyu kadar
  display: "flex",
  flexDirection: "column",
  fontFamily: "'Segoe UI', sans-serif",
};

const headerStyle = {
  padding: "20px",
  borderBottom: "2px solid rgba(255,255,255,0.1)",
};

const titleStyle = {
  margin: 0,
  color: "#fff",
  display: "flex",
  alignItems: "center",
  gap: "10px",
  fontSize: "28px",
  fontWeight: "bold",
};

const contentStyle = {
  padding: "20px",
  color: "#fff",
  flex: 1, // içerik uzadığında arka plan devam etsin
};
