using System;

namespace SecondLife.Models
{
    public class Producto
    {

        public string id_prod { get; set; }
        public string codigo { get; set; }
        public int id_categ { get; set; }
        public string marca { get; set; }
        public string modelo { get; set; }
        public string descripcion { get; set; }
        public string observacion { get; set; }
        public DateTime fec_compra { get; set; }
        public int stock { get; set; }
        public Decimal precio { get; set; }
        public string imagen { get; set; }
        public Decimal calidad { get; set; }
        public int estado { get; set; }


    }
}