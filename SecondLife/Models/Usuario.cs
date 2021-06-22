using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SecondLife.Models
{
    public class Usuario
    {
        
        public string id_usua { get; set; }
        public string dni_usua { get; set; }
        public int id_rol { get; set; }
        public string nom_usua { get; set; }
        public string ape_usua { get; set; }
        public string  tel_usua { get; set; }
        public DateTime fec_nac_usua { get; set; }
        public string usuario { get; set; }
        public string pass { get; set; }
        public string email_log { get; set; }
        public int estado { get; set; }

    }
}