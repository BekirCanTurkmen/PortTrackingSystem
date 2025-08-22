using System.ComponentModel.DataAnnotations;

namespace PortShipTracking.Api.Domain.Entities
{
    public class Port
    {
        [Key]
        public int PortId { get; set; }

        [Required, MaxLength(100)]
        public string Name { get; set; } = null!;

        [Required, MaxLength(50)]
        public string Country { get; set; } = null!;

        [Required, MaxLength(50)]
        public string City { get; set; } = null!;

        public ICollection<ShipVisit> ShipVisits { get; set; } = new List<ShipVisit>();
    }
}
