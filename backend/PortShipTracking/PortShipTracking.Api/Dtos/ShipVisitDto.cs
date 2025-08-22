namespace PortShipTracking.Api.Dtos
{
    public class ShipVisitDto
    {
        public int VisitId { get; set; }
        public int ShipId { get; set; }
        public int PortId { get; set; }
        public DateTime ArrivalDate { get; set; }
        public DateTime DepartureDate { get; set; }
        public string Purpose { get; set; } = string.Empty;
    }
}
