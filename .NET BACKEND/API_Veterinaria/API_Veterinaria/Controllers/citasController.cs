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
    public class citasController : ControllerBase
    {
        private readonly VeterinariaContext _context;

        public citasController(VeterinariaContext context)
        {
            _context = context;
        }

        // GET: api/citas
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Cita>>> GetRegistroAdopcion()
        {
            return await _context.RegistroAdopcion.ToListAsync();
        }

        // GET: api/citas/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Cita>> GetCita(int id)
        {
            var cita = await _context.RegistroAdopcion.FindAsync(id);

            if (cita == null)
            {
                return NotFound();
            }

            return cita;
        }

        // PUT: api/citas/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCita(int id, Cita cita)
        {
            if (id != cita.Id)
            {
                return BadRequest();
            }

            _context.Entry(cita).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CitaExists(id))
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

        // POST: api/citas
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Cita>> PostCita(Cita cita)
        {
            _context.RegistroAdopcion.Add(cita);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetCita", new { id = cita.Id }, cita);
        }

        // DELETE: api/citas/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCita(int id)
        {
            var cita = await _context.RegistroAdopcion.FindAsync(id);
            if (cita == null)
            {
                return NotFound();
            }

            _context.RegistroAdopcion.Remove(cita);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool CitaExists(int id)
        {
            return _context.RegistroAdopcion.Any(e => e.Id == id);
        }
    }
}
