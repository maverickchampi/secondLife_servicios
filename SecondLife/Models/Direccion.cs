using System;
using System.ComponentModel.DataAnnotations;

namespace SecondLife.Models
{
    public class Direccion
    {
        public string id_direc { get; set; }

        [Display(Name = "descripción")]
        [Required, StringLength(50)]
        public string desc_direc { get; set; }

        [Display(Name = "referencia")]
        [Required, StringLength(50)]
        public string referencia { get; set; }

        [Display(Name = "etiqueta")]
        [Required, StringLength(50)]
        public string etiqueta { get; set; }
        public int id_dist { get; set; }
        public string id_usua { get; set; }
        public int estado { get; set; }
    }
}