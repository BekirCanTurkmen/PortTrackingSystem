{
  import("tailwindcss").Config;
}
export const content = ["./index.html", "./src/**/*.{js,jsx,ts,tsx}"];
export const theme = {
  extend: {
    colors: {
      brand: {
        navy: "#0F2452", // başlık/nav
        blue: "#1F3C88", // ana vurgu
        blue2: "#2E5AAC", // hover
        light: "#EEF2F7", // sayfa arka planı
        gray: "#5B667A", // ikincil metin
      },
    },
    boxShadow: { soft: "0 8px 24px rgba(15,36,82,0.08)" },
    fontFamily: {
      sans: [
        "Inter",
        "ui-sans-serif",
        "system-ui",
        "Segoe UI",
        "Roboto",
        "Arial",
      ],
    },
  },
};
export const plugins = [];
