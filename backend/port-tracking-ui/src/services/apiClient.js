import axios from "axios";

export default axios.create({
  baseURL: "https://localhost:56975", // backend adresin (HTTPS!)
});
