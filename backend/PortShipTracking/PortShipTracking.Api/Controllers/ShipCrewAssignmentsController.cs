using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PortShipTracking.Api.Domain.Entities;
using PortTrackingSystem.Api.Infrastructure.Data;
using PortTrackingSystem.Api.Dtos;

namespace PortTrackingSystem.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ShipCrewAssignmentsController : ControllerBase
    {
        private readonly AppDbContext _context;
        public ShipCrewAssignmentsController(AppDbContext context) => _context = context;

        // GET: api/shipcrewassignments
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ShipCrewAssignment>>> GetAll()
            => await _context.ShipCrewAssignments
                             .AsNoTracking()
                             .ToListAsync();

        // GET: api/shipcrewassignments/5
        [HttpGet("{id:int}")]
        public async Task<ActionResult<ShipCrewAssignment>> GetById(int id)
        {
            var entity = await _context.ShipCrewAssignments.FindAsync(id);
            return entity is null ? NotFound($"Assignment {id} not found") : entity;
        }

        // POST: api/shipcrewassignments
        [HttpPost]
        public async Task<ActionResult<ShipCrewAssignment>> Create([FromBody] ShipCrewAssignmentDto input)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var entity = new ShipCrewAssignment
            {
                ShipId = input.ShipId,
                CrewId = input.CrewId,
                AssignmentDate = input.AssignmentDate
            };

            _context.ShipCrewAssignments.Add(entity);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetById), new { id = entity.AssignmentId }, entity);
        }

        // PUT: api/shipcrewassignments/5
        [HttpPut("{id:int}")]
        public async Task<IActionResult> Update(int id, [FromBody] ShipCrewAssignmentDto input)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            if (input.AssignmentId != id)
                return BadRequest("ID mismatch");

            var existing = await _context.ShipCrewAssignments.FindAsync(id);
            if (existing is null)
                return NotFound($"Assignment {id} not found");

            existing.ShipId = input.ShipId;
            existing.CrewId = input.CrewId;
            existing.AssignmentDate = input.AssignmentDate;

            await _context.SaveChangesAsync();
            return NoContent();
        }

        // DELETE: api/shipcrewassignments/5
        [HttpDelete("{id:int}")]
        public async Task<IActionResult> Delete(int id)
        {
            var entity = await _context.ShipCrewAssignments.FindAsync(id);
            if (entity is null)
                return NotFound($"Assignment {id} not found");

            _context.ShipCrewAssignments.Remove(entity);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
