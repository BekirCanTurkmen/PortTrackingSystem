# 🚢 Port Tracking System

A **fullstack port tracking system** developed during my internship.  
The project manages ships, ports, cargos, crew members, and visit records with a **.NET backend**, a **React web frontend**, and a **Flutter mobile client**.

---

## 🧱 Technologies

- **Backend:** ASP.NET Core Web API (.NET 8), Entity Framework Core, Repository-Service pattern, SQL Server, Swagger
- **Frontend (Web):** React 18 + Vite, Axios, form validation
- **Frontend (Mobile):** Flutter, Firebase Authentication (login), API integration
- **Database:** SQL Server Express, schema & seed data (`PortTrackingSystem.sql`)
- **Testing:** xUnit + Moq for unit testing
- **DevOps:** Git, Azure DevOps repository structure

---

## 📂 Project Structure

PortTrackingSystem/
├── backend/ # ASP.NET Core Web API (RESTful services, unit tests)
│ └── PortShipTracking/
├── web-frontend/ # React (Vite) web client
│ └── port-tracking-ui/
├── mobile-frontend/ # Flutter mobile app (with Firebase login)
├── database/ # SQL schema + sample data
 └── PortTrackingSystem.sql
