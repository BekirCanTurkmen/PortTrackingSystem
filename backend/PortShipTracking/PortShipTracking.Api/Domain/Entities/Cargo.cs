using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PortShipTracking.Api.Domain.Entities
{
    public class Cargo
    {
        [Key]
        public int CargoId { get; set; }

        [ForeignKey(nameof(Ship))]
        public int ShipId { get; set; }

        [Required, MaxLength(200)]
        public string Description { get; set; } = null!;

        public decimal WeightTon { get; set; }

        [Required, MaxLength(50)]
        public string CargoType { get; set; } = null!;

        public Ship? Ship { get; set; } = null!;
    }
}
