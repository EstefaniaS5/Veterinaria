namespace API_Veterinaria.Models
{
    public class Cita
    {
       public int Id { get; set; }
        public int MascotaId { get; set; }
        public DateTime Fecha { get; set; }
        public string Motivo { get; set; }
        public string Responsable { get; set; }

        public TimeSpan Hora { get; set; }
    }
}
