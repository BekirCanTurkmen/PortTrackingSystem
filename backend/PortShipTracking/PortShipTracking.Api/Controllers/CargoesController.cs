using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PortTrackingSystem.Api.Infrastructure.Data;   // ✅ doğru namespace
using PortShipTracking.Api.Domain.Entities;
using PortShipTracking.Api.Dtos;

namespace PortShipTracking.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CargoesController : ControllerBase
    {
        private readonly AppDbContext _context;

        public CargoesController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/cargoes
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CargoDto>>> GetCargoes()
        {
            return await _context.Cargoes
                .Select(c => new CargoDto
                {
                    CargoId = c.CargoId,
                    ShipId = c.ShipId,
                    Description = c.Description,
                    WeightTon = c.WeightTon,
                    CargoType = c.CargoType
                })
                .ToListAsync();
        }

        // GET: api/cargoes/5
        [HttpGet("{id}")]
        public async Task<ActionResult<CargoDto>> GetCargo(int id)
        {
            var cargo = await _context.Cargoes.FindAsync(id);
            if (cargo == null) return NotFound();

            return new CargoDto
            {
                CargoId = cargo.CargoId,
                ShipId = cargo.ShipId,
                Description = cargo.Description,
                WeightTon = cargo.WeightTon,
                CargoType = cargo.CargoType
            };
        }

        // POST: api/cargoes
        [HttpPost]
        public async Task<ActionResult<CargoDto>> CreateCargo(CargoDto dto)
        {
            var cargo = new Cargo
            {
                ShipId = dto.ShipId,
                Description = dto.Description,
                WeightTon = dto.WeightTon,
                CargoType = dto.CargoType
            };

            _context.Cargoes.Add(cargo);
            await _context.SaveChangesAsync();

            dto.CargoId = cargo.CargoId;

            return CreatedAtAction(nameof(GetCargo), new { id = cargo.CargoId }, dto);
        }

        // PUT: api/cargoes/5
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateCargo(int id, CargoDto dto)
        {
            if (id != dto.CargoId) return BadRequest();

            var cargo = await _context.Cargoes.FindAsync(id);
            if (cargo == null) return NotFound();

            cargo.ShipId = dto.ShipId;
            cargo.Description = dto.Description;
            cargo.WeightTon = dto.WeightTon;
            cargo.CargoType = dto.CargoType;

            await _context.SaveChangesAsync();
            return NoContent();
        }

        // DELETE: api/cargoes/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCargo(int id)
        {
            var cargo = await _context.Cargoes.FindAsync(id);
            if (cargo == null) return NotFound();

            _context.Cargoes.Remove(cargo);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
