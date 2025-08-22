using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

using PortTrackingSystem.Api.Infrastructure.Data;
using PortShipTracking.Api.Domain.Entities;

namespace PortTrackingSystem.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ShipsController : ControllerBase
    {
        private readonly AppDbContext _context;
        public ShipsController(AppDbContext context) => _context = context;

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Ship>>> GetAll()
            => await _context.Ships.AsNoTracking().ToListAsync();

        [HttpGet("{id:int}")]
        public async Task<ActionResult<Ship>> GetById(int id)
        {
            var entity = await _context.Ships.FindAsync(id);
            return entity is null ? NotFound() : entity;
        }

        [HttpPost]
        public async Task<ActionResult<Ship>> Create(Ship input)
        {
            _context.Ships.Add(input);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetById), new { id = input.ShipId }, input);
        }

        [HttpPut("{id:int}")]
        public async Task<IActionResult> Update(int id, Ship input)
        {
            if (input.ShipId != id) return BadRequest("ID mismatch");
            _context.Entry(input).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpDelete("{id:int}")]
        public async Task<IActionResult> Delete(int id)
        {
            var entity = await _context.Ships.FindAsync(id);
            if (entity is null) return NotFound();
            _context.Ships.Remove(entity);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}