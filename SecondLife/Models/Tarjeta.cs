using System;
using System.ComponentModel.DataAnnotations;

namespace SecondLife.Models
{
    public class Tarjeta
    {
        public string id_tarj { get; set; }
        public string tip_tarj { get; set; }

        [Display(Name = "número")]
        [Required, RegularExpression("^[0-9]{16}$")]
        public string num_tarj { get; set; }

        [Display(Name = "fecha de vencimiento")]
        [Required, StringLength(5)]
        public string fec_venc { get; set; }

        [Display(Name = "cvv")]
        [Required, RegularExpression("^[0-9]{3}$")]
        public int cvv { get; set; }
        public string id_usua { get; set; }
        public int estado { get; set; }
    }
}