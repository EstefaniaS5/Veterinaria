namespace API_Veterinaria.Models
{
    public class Adopcion
    {
        public int Id { get; set; }
        public int MacotaId { get; set; }
        public string Adoptante { get; set; }
        public DateTime FechaAdopcion { get; set; }
        public string Estado { get; set; }


    }
}
