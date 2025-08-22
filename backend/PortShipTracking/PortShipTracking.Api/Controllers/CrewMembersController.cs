using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PortShipTracking.Api.Domain.Entities;
using PortTrackingSystem.Api.Infrastructure.Data;

namespace PortTrackingSystem.Api.Controllers

{

    [ApiController]

    [Route("api/[controller]")]

    public class CrewMembersController : ControllerBase

    {

        private readonly AppDbContext _context;

        public CrewMembersController(AppDbContext context) => _context = context;

        [HttpGet]

        public async Task<ActionResult<IEnumerable<CrewMember>>> GetCrewMembers()

        {

            var crew = await _context.CrewMembers.ToListAsync();

            return Ok(crew); // JSON array döner

        }


        [HttpGet("{id:int}")]

        public async Task<ActionResult<CrewMember>> GetById(int id)

        {

            var entity = await _context.CrewMembers.FindAsync(id);

            return entity is null ? NotFound() : entity;

        }

        [HttpPost]

        public async Task<ActionResult<CrewMember>> Create(CrewMember input)

        {

            _context.CrewMembers.Add(input);

            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetById), new { id = input.CrewId }, input);

        }

        [HttpPut("{id:int}")]

        public async Task<IActionResult> Update(int id, CrewMember input)

        {

            if (input.CrewId != id) return BadRequest("ID mismatch");

            _context.Entry(input).State = EntityState.Modified;

            await _context.SaveChangesAsync();

            return NoContent();

        }

        [HttpDelete("{id:int}")]

        public async Task<IActionResult> Delete(int id)

        {

            var entity = await _context.CrewMembers.FindAsync(id);

            if (entity is null) return NotFound();

            _context.CrewMembers.Remove(entity);

            await _context.SaveChangesAsync();

            return NoContent();

        }

    }

}

