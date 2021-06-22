using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SecondLife.Models
{
    public class Boleta
    {
        public string num_bol { get; set; }
        public string id_usua { get; set; }
        public string id_direc { get; set; }
        public string id_tarj { get; set; }
        public DateTime fec_bol { get; set; }
        public decimal desc_bol { get; set; }
        public decimal impo_bol { get; set; }
        public decimal envio { get; set; }
        public decimal total_bol { get; set; }
    }
}