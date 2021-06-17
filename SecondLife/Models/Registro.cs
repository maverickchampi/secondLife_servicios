using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SecondLife.Models
{
    public class Registro
    {
        public string id_regis { get; set; }
        public int id_categ { get; set; }
        public string id_usua { get; set; }
        public string descrip_prod { get; set; }
        public string observacion { get; set; }
        public DateTime fecha_regis { get; set; }
        public int stock { get; set; }
        public decimal precio { get; set; }
        public string image { get; set; }
        public decimal calidad { get; set; }
        public int estado { get; set; }

    }
}