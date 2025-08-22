namespace PortTrackingSystem.Api.Dtos
{
    public class ShipCrewAssignmentDto
    {
        public int AssignmentId { get; set; }
        public int ShipId { get; set; }
        public int CrewId { get; set; }
        public DateTime AssignmentDate { get; set; }
    }
}
