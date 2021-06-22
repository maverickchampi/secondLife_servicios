namespace SecondLife.Models
{
    public class Item
    {
        public string id_prod { get; set; }
        public string nom_prod { get; set; }
        public string imagen { get; set; }
        public decimal precio { get; set; }
        public int cant { get; set; }
        public decimal sub_total { get { return cant * precio; } }
    }
}