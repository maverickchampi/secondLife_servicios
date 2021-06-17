using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SecondLife.Models
{
    public class Direccion
    {
        public string id_direc { get; set; }
        public decimal latitud { get; set; }
        public decimal longitud { get; set; }
        public string desc_direc { get; set; }
        public string etiqueta { get; set; }
        public int id_dist { get; set; }
        public string id_usua { get;set; }
    }
}