﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SecondLife.Models
{
    public class Tarjeta
    {
        public string id_tarj { get; set; }
        public string tip_tarj { get; set; }
        public string num_tarj { get; set; }
        public string fec_venc { get; set; }
        public int cvv { get; set; }
        public string id_usua { get; set; }
    }
}