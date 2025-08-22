namespace PortShipTracking.Api.Dtos
{
    public class CargoDto
    {
        public int CargoId { get; set; }
        public int ShipId { get; set; }   
        public string Description { get; set; } = string.Empty;
        public decimal WeightTon { get; set; }
        public string CargoType { get; set; } = string.Empty;
    }
}
