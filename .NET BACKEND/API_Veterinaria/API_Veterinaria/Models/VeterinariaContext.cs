using Microsoft.EntityFrameworkCore;


namespace API_Veterinaria.Models
{
    public class VeterinariaContext : DbContext
    {
        public VeterinariaContext(DbContextOptions<VeterinariaContext> options) : base(options)
        {
        }
        public DbSet<Animal> RegistroAnimal { get; set; }
        public DbSet<Adopcion> AgendaCitas { get; set; }
        public DbSet<Cita> RegistroAdopcion { get; set; }
    }
}
