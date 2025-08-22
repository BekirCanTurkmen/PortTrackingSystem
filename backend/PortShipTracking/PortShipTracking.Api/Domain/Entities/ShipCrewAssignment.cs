using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace PortShipTracking.Api.Domain.Entities
{
    public class ShipCrewAssignment
    {
        [Key]
        public int AssignmentId { get; set; }

        [ForeignKey(nameof(Ship))]
        public int ShipId { get; set; }

        [ForeignKey(nameof(CrewMember))]
        public int CrewId { get; set; }

        public DateTime AssignmentDate { get; set; }

        // Navigation properties (API'de gönderilmeyecek)
        [JsonIgnore]
        public Ship Ship { get; set; } = null!;

        [JsonIgnore]
        public CrewMember CrewMember { get; set; } = null!;
    }
}
