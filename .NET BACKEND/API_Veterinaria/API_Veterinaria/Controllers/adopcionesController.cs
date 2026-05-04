using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using API_Veterinaria.Models;

namespace API_Veterinaria.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class adopcionesController : ControllerBase
    {
        private readonly VeterinariaContext _context;

        public adopcionesController(VeterinariaContext context)
        {
            _context = context;
        }

        // GET: api/adopciones
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Adopcion>>> GetAgendaCitas()
        {
            return await _context.AgendaCitas.ToListAsync();
        }

        // GET: api/adopciones/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Adopcion>> GetAdopcion(int id)
        {
            var adopcion = await _context.AgendaCitas.FindAsync(id);

            if (adopcion == null)
            {
                return NotFound();
            }

            return adopcion;
        }

        // PUT: api/adopciones/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutAdopcion(int id, Adopcion adopcion)
        {
            if (id != adopcion.Id)
            {
                return BadRequest();
            }

            _context.Entry(adopcion).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!AdopcionExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/adopciones
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Adopcion>> PostAdopcion(Adopcion adopcion)
        {
            _context.AgendaCitas.Add(adopcion);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetAdopcion", new { id = adopcion.Id }, adopcion);
        }

        // DELETE: api/adopciones/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAdopcion(int id)
        {
            var adopcion = await _context.AgendaCitas.FindAsync(id);
            if (adopcion == null)
            {
                return NotFound();
            }

            _context.AgendaCitas.Remove(adopcion);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool AdopcionExists(int id)
        {
            return _context.AgendaCitas.Any(e => e.Id == id);
        }
    }
}
