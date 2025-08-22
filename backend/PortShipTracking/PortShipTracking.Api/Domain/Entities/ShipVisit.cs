using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PortShipTracking.Api.Domain.Entities
{
    public class ShipVisit
    {
        [Key]
        public int VisitId { get; set; }

        [ForeignKey(nameof(Ship))]
        public int ShipId { get; set; }

        [ForeignKey(nameof(Port))]
        public int PortId { get; set; }

        public DateTime ArrivalDate { get; set; }
        public DateTime DepartureDate { get; set; }

        [Required, MaxLength(100)]
        public string Purpose { get; set; } = null!;

        public Ship? Ship { get; set; }
        public Port? Port { get; set; }

    }
}
