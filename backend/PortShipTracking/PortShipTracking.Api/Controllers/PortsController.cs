using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PortShipTracking.Api.Domain.Entities;
using PortTrackingSystem.Api.Infrastructure.Data;

namespace PortTrackingSystem.Api.Controllers

{

    [ApiController]

    [Route("api/[controller]")]

    public class PortsController : ControllerBase

    {

        private readonly AppDbContext _context;

        public PortsController(AppDbContext context) => _context = context;

        [HttpGet]

        public async Task<ActionResult<IEnumerable<Port>>> GetAll()

            => await _context.Ports.AsNoTracking().ToListAsync();

        [HttpGet("{id:int}")]

        public async Task<ActionResult<Port>> GetById(int id)

        {

            var entity = await _context.Ports.FindAsync(id);

            return entity is null ? NotFound() : entity;

        }

        [HttpPost]

        public async Task<ActionResult<Port>> Create(Port input)

        {

            _context.Ports.Add(input);

            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetById), new { id = input.PortId }, input);

        }

        [HttpPut("{id:int}")]

        public async Task<IActionResult> Update(int id, Port input)

        {

            if (input.PortId != id) return BadRequest("ID mismatch");

            _context.Entry(input).State = EntityState.Modified;

            await _context.SaveChangesAsync();

            return NoContent();

        }

        [HttpDelete("{id:int}")]

        public async Task<IActionResult> Delete(int id)

        {

            var entity = await _context.Ports.FindAsync(id);

            if (entity is null) return NotFound();

            _context.Ports.Remove(entity);

            await _context.SaveChangesAsync();

            return NoContent();

        }

    }

}

