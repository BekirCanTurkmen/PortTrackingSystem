using Microsoft.EntityFrameworkCore;
using PortShipTracking.Api.Domain.Entities;

namespace PortTrackingSystem.Api.Infrastructure.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Ship> Ships => Set<Ship>();
        public DbSet<Port> Ports => Set<Port>();
        public DbSet<CrewMember> CrewMembers => Set<CrewMember>();
        public DbSet<ShipVisit> ShipVisits => Set<ShipVisit>();
        public DbSet<Cargo> Cargoes => Set<Cargo>();
        public DbSet<ShipCrewAssignment> ShipCrewAssignments => Set<ShipCrewAssignment>();

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Ship>()
                .HasIndex(s => s.IMO)
                .IsUnique();

            modelBuilder.Entity<ShipVisit>()
                .HasOne(sv => sv.Ship)
                .WithMany(s => s.ShipVisits)
                .HasForeignKey(sv => sv.ShipId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<ShipVisit>()
                .HasOne(sv => sv.Port)
                .WithMany(p => p.ShipVisits)
                .HasForeignKey(sv => sv.PortId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<ShipVisit>()
                .HasCheckConstraint("CHK_ArrivalBeforeDeparture", "ArrivalDate < DepartureDate");

            modelBuilder.Entity<Cargo>()
                .HasOne(c => c.Ship)
                .WithMany(s => s.Cargoes)
                .HasForeignKey(c => c.ShipId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Cargo>()
                .HasCheckConstraint("CHK_WeightPositive", "WeightTon > 0");

            modelBuilder.Entity<ShipCrewAssignment>()
                .HasOne(a => a.Ship)
                .WithMany(s => s.ShipCrewAssignments)
                .HasForeignKey(a => a.ShipId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<ShipCrewAssignment>()
                .HasOne(a => a.CrewMember)
                .WithMany(c => c.ShipCrewAssignments)
                .HasForeignKey(a => a.CrewId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<ShipCrewAssignment>()
                .HasIndex(a => new { a.ShipId, a.CrewId, a.AssignmentDate })
                .IsUnique()
                .HasDatabaseName("UC_ShipCrew");
        }
    }
}