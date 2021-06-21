using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace SecondLife.Models
{
    public class Usuario
    {
        public string id_usua { get; set; }

        [Display(Name = "dni")]
        [Required, RegularExpression("^[0-9]{8}$")]
        public string dni_usua { get; set; }
        public int id_rol { get; set; }

        [Display(Name = "nombre")]
        [Required, StringLength(50)]
        public string nom_usua { get; set; }

        [Display(Name = "apellido")]
        [Required, StringLength(50)]
        public string ape_usua { get; set; }

        [Display(Name = "teléfono")]
        [Required, RegularExpression("^[0-9]{9}$")]
        public string  tel_usua { get; set; }

        [Display(Name = "fecha de nacimiento")]
        [Required]
        public DateTime fec_nac_usua { get; set; }

        [Display(Name = "usuario")]
        [Required, StringLength(30)]
        public string usuario { get; set; }

        [Display(Name = "contraseña")]
        [Required, StringLength(30)]
        public string pass { get; set; }

        [Display(Name = "correo")]
        [Required]
        public string email_log { get; set; }
        public int estado { get; set; }

    }
}