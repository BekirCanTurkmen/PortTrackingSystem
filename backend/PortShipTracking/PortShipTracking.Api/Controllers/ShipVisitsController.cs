using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

using PortShipTracking.Api.Domain.Entities;
using PortShipTracking.Api.Dtos;
using PortTrackingSystem.Api.Infrastructure.Data;

namespace PortShipTracking.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ShipVisitsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ShipVisitsController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/ShipVisits
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ShipVisitDto>>> GetShipVisits()
        {
            return await _context.ShipVisits
                .Select(v => new ShipVisitDto
                {
                    VisitId = v.VisitId,
                    ShipId = v.ShipId,
                    PortId = v.PortId,
                    ArrivalDate = v.ArrivalDate,
                    DepartureDate = v.DepartureDate,
                    Purpose = v.Purpose
                })
                .ToListAsync();
        }

        // GET: api/ShipVisits/5
        [HttpGet("{id}")]
        public async Task<ActionResult<ShipVisitDto>> GetShipVisit(int id)
        {
            var visit = await _context.ShipVisits.FindAsync(id);
            if (visit == null) return NotFound();

            return new ShipVisitDto
            {
                VisitId = visit.VisitId,
                ShipId = visit.ShipId,
                PortId = visit.PortId,
                ArrivalDate = visit.ArrivalDate,
                DepartureDate = visit.DepartureDate,
                Purpose = visit.Purpose
            };
        }

        // POST: api/ShipVisits
        [HttpPost]
        public async Task<ActionResult<ShipVisitDto>> CreateShipVisit(ShipVisitDto dto)
        {
            var visit = new ShipVisit
            {
                ShipId = dto.ShipId,
                PortId = dto.PortId,
                ArrivalDate = dto.ArrivalDate,
                DepartureDate = dto.DepartureDate,
                Purpose = dto.Purpose
            };

            _context.ShipVisits.Add(visit);
            await _context.SaveChangesAsync();

            dto.VisitId = visit.VisitId;

            return CreatedAtAction(nameof(GetShipVisit), new { id = visit.VisitId }, dto);
        }

        // PUT: api/ShipVisits/5
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateShipVisit(int id, ShipVisitDto dto)
        {
            if (id != dto.VisitId) return BadRequest();

            var visit = await _context.ShipVisits.FindAsync(id);
            if (visit == null) return NotFound();

            visit.ShipId = dto.ShipId;
            visit.PortId = dto.PortId;
            visit.ArrivalDate = dto.ArrivalDate;
            visit.DepartureDate = dto.DepartureDate;
            visit.Purpose = dto.Purpose;

            await _context.SaveChangesAsync();
            return NoContent();
        }

        // DELETE: api/ShipVisits/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteShipVisit(int id)
        {
            var visit = await _context.ShipVisits.FindAsync(id);
            if (visit == null) return NotFound();

            _context.ShipVisits.Remove(visit);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
