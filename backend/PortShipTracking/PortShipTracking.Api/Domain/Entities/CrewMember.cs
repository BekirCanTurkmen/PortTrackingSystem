using System.ComponentModel.DataAnnotations;

namespace PortShipTracking.Api.Domain.Entities
{
    public class CrewMember
    {
        [Key]
        public int CrewId { get; set; }

        [Required, MaxLength(50)]
        public string FirstName { get; set; } = null!;

        [Required, MaxLength(50)]
        public string LastName { get; set; } = null!;

        [Required, MaxLength(100)]
        [EmailAddress]
        public string Email { get; set; } = null!;

        [Required, MaxLength(20)]
        public string PhoneNumber { get; set; } = null!;

        [Required, MaxLength(50)]
        public string Role { get; set; } = null!;

        public ICollection<ShipCrewAssignment> ShipCrewAssignments { get; set; } = new List<ShipCrewAssignment>();
    }
}
