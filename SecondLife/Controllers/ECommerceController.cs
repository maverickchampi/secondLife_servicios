using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;
using SecondLife.Models;

namespace SecondLife.Controllers
{
    public class ECommerceController : Controller
    {
        // GET: ECommerce
        string cadena = ConfigurationManager.ConnectionStrings["cn"].ConnectionString;
        
        IEnumerable<Producto> producto()
        {
            List<Producto> temporal = new List<Producto>();
            SqlConnection cn = new SqlConnection(cadena);
            SqlCommand cmd = new SqlCommand("sp_listado_producto", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                Producto reg = new Producto();
                reg.id_prod = dr.GetString(0);
                reg.codigo = dr.GetString(1);
                reg.id_categ = dr.GetInt32(2);
                reg.marca = dr.GetString(3);
                reg.modelo = dr.GetString(4);
                reg.descripcion = dr.GetString(5);
                reg.observacion = dr.GetString(6);
                reg.fec_compra = dr.GetDateTime(7);
                reg.stock = dr.GetInt32(8);
                reg.precio = dr.GetDecimal(9);
                reg.imagen = dr.GetString(10);
                reg.calidad= dr.GetDecimal (11);
                reg.estado = dr.GetInt32(12);
                temporal.Add(reg);
            }
            dr.Close(); cn.Close();
            return temporal;
        }
        Producto buscar_producto(string id)
        {
            Producto reg = new Producto();
            SqlConnection cn = new SqlConnection(cadena);
            SqlCommand cmd = new SqlCommand("sp_listado_producto_id", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@id", id);
            cn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.Read()!=null)
            {            
                reg.id_prod = dr.GetString(0);
                reg.codigo = dr.GetString(1);
                reg.id_categ = dr.GetInt32(2);
                reg.marca = dr.GetString(3);
                reg.modelo = dr.GetString(4);
                reg.descripcion = dr.GetString(5);
                reg.observacion = dr.GetString(6);
                reg.fec_compra = dr.GetDateTime(7);
                reg.stock = dr.GetInt32(8);
                reg.precio = dr.GetDecimal(9);
                reg.imagen = dr.GetString(10);
                reg.calidad = dr.GetDecimal(11);
                reg.estado = dr.GetInt32(12);
            }
            dr.Close(); cn.Close();
            return reg;
        }
        public ActionResult Product()
        {
            return View(producto());
        }
        [HttpPost]
        public ActionResult Product(string id, Int16 stock, int cant)
        {
            /*if (cant >= stock)
            {
                ViewBag.mensaje = "Ingrese una cantidad menor al stock";
                return View(producto());
            }
            Producto reg = buscar_producto(id);

            List<Producto> temporal = (List<Producto>)Session["carrito"];
            temporal.Add(reg);
            return View();*/
        }
    }
}