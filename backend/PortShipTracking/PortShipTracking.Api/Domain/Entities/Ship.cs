using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PortShipTracking.Api.Domain.Entities
{
    public class Ship
    {
        [Key]
        public int ShipId { get; set; }

        [Required, MaxLength(100)]
        public string Name { get; set; } = null!;

        [Required, MaxLength(10)]
        public string IMO { get; set; } = null!; // Unique

        [Required, MaxLength(50)]
        public string Type { get; set; } = null!;

        [Required, MaxLength(50)]
        public string Flag { get; set; } = null!;

        public int YearBuilt { get; set; }

        public ICollection<Cargo> Cargoes { get; set; } = new List<Cargo>();
        public ICollection<ShipVisit> ShipVisits { get; set; } = new List<ShipVisit>();
        public ICollection<ShipCrewAssignment> ShipCrewAssignments { get; set; } = new List<ShipCrewAssignment>();
    }
}
