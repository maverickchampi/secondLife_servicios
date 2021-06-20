using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SecondLife.Models
{
    public class Item
    {
        public string id_prod { get; set; }
        public decimal precio { get; set; }
        public int cant { get; set; }
        public decimal sub_total { get { return cant * precio; } }
    }
}