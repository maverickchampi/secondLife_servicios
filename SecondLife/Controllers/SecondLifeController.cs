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
    public class SecondLifeController : Controller
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
        IEnumerable<Producto> producto_categ(int? cat=null)
        {
            List<Producto> temporal = new List<Producto>();
            SqlConnection cn = new SqlConnection(cadena);
            SqlCommand cmd = new SqlCommand("sp_listado_producto_cat", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@cat", cat);
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
                reg.calidad = dr.GetDecimal(11);
                reg.estado = dr.GetInt32(12);
                temporal.Add(reg);
            }
            dr.Close(); cn.Close();
            return temporal;
        }
        IEnumerable<Categoria> lista_categoria()
        {
            List<Categoria> temporal = new List<Categoria>();
            SqlConnection cn = new SqlConnection(cadena);
            SqlCommand cmd = new SqlCommand("select*from tb_categoria", cn);
            cn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                Categoria reg = new Categoria();
                reg.id_categ = dr.GetInt32(0);
                reg.nombre = dr.GetString(1);
                reg.descripcion = dr.GetString(2);
                reg.estado = dr.GetInt32(3);
                if (reg.estado == 1)
                {
                    temporal.Add(reg);
                }
            }
            dr.Close(); cn.Close();
            return temporal;
        }
        IEnumerable<Usuario> lista_usuario()
        {
            List<Usuario> temporal = new List<Usuario>();
            SqlConnection cn = new SqlConnection(cadena);
            SqlCommand cmd = new SqlCommand("sp_lista_usuario", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            while(dr.Read())
            {
                Usuario reg = new Usuario();
                reg.id_usua = dr.GetString(0);
                reg.dni_usua = dr.GetString(1);
                reg.id_rol = dr.GetInt32(2);
                reg.nom_usua = dr.GetString(3);
                reg.ape_usua = dr.GetString(4);
                reg.tel_usua = dr.GetString(5)??"hhhh";
                reg.fec_nac_usua = dr.GetDateTime(6);
                reg.usuario = dr.GetString(7);
                reg.pass = dr.GetString(8);
                reg.email_log = dr.GetString(9);
                reg.estado = dr.GetInt32(10);
                temporal.Add(reg);
            }
            dr.Close(); cn.Close();
            return temporal;
        }
        Usuario InicioSesion()
        {
            if (Session["login"] == null)
            {
                return null;
            }
            else
            {
                return (Session["login"] as Usuario);
            }
        }

        /*--------------busquedas--------------------*/
        Producto buscar_producto(string id)
        {
            Producto reg;
            if (id == null)
            {
                reg = new Producto();
            }
            else
            {
                reg = producto().Where(x => x.id_prod == id).FirstOrDefault();
            }
            return reg;
        }
        Usuario buscar_usuario_id(string id)
        {
            Usuario reg;
            if (id == null)
            {
                reg = new Usuario();
            }
            else
            {
                reg = lista_usuario().Where(x => x.id_usua == id).FirstOrDefault();
            }
            return reg;
        }
        Usuario buscar_usuario(string usuario=null, string pass=null)
        {
            Usuario reg = null;
            SqlConnection cn = new SqlConnection(cadena);
            cn.Open();
            SqlCommand cmd = new SqlCommand("sp_buscar_user", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@user", usuario);
            cmd.Parameters.AddWithValue("@pass", pass);
            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.Read())
            {
                reg = new Usuario();
                reg.id_usua = dr.GetString(0);
                reg.dni_usua = dr.GetString(1);
                reg.id_rol = dr.GetInt32(2);
                reg.nom_usua = dr.GetString(3);
                reg.ape_usua = dr.GetString(4);
                reg.tel_usua = dr.GetString(5);
                reg.fec_nac_usua = dr.GetDateTime(6);
                reg.usuario = dr.GetString(7);
                reg.pass = dr.GetString(8);
                reg.email_log = dr.GetString(9);
                reg.estado = dr.GetInt32(10);
            }
            dr.Close(); cn.Close();
            return reg;
        }
        /*--------------metodos de actionresult--------------------*/
        /*-----------------PROCESO DE CLIENTE------------*/
        public ActionResult Login()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Login(string user, string pass)
        {
            Usuario reg = buscar_usuario(user, pass);
            if (reg == null)
            {
                ViewBag.mensaje = "Usuario o Clave Incorrecto";
                return View();
            }
            else
            {
                Session["login"] = reg;
                return RedirectToAction("Product", new { mensaje= "Ha iniciado sesion" });
            }
        }
        public ActionResult RegisterUser()
        {

            return View();
        }
        [HttpPost]
        public ActionResult RegisterUser(Usuario reg)
        {

            SqlConnection cn = new SqlConnection(cadena);
            cn.Open();
            try
            {           
                SqlCommand cmd = new SqlCommand("sp_insertar_usuario", cn);            
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@dni", reg.dni_usua);
                cmd.Parameters.AddWithValue("@nom", reg.nom_usua);
                cmd.Parameters.AddWithValue("@apel", reg.ape_usua);
                cmd.Parameters.AddWithValue("@fec_nac_usua", reg.fec_nac_usua);
                cmd.Parameters.AddWithValue("@usuario", reg.usuario);
                cmd.Parameters.AddWithValue("@pass", reg.pass);
                cmd.Parameters.AddWithValue("@email_log", reg.email_log);

                int i=cmd.ExecuteNonQuery();
                if (i < 0)
                {
                    ViewBag.mensaje = "Te has registrado";
                }
            }catch(SqlException e)
            {
                ViewBag.mensaje = "Error al registrarse, vuelve a intentarlo";
            }
            finally
            {
                cn.Close();
            }
            return View();
        }
        public ActionResult CloseSession()
        {
            Session["login"] = null;
            return RedirectToAction("Product", new { mensaje = "La sesión fue cerrada" });
        }
        //perfil
        public ActionResult Profile(string id = null)
        {
            TempData["usuario"] = InicioSesion() as Usuario; //datos del usuario

            Usuario reg = buscar_usuario_id(id);
            return View(reg);
        }
        /*---------------PROCESO DE PRODUCTO------------------------------------*/
        public ActionResult Product(string mensaje=null, int p =0, int id_categ=0,string marca="", string flecha = "")
        {
            TempData["usuario"] = InicioSesion() as Usuario; //datos del usuario

            if (mensaje != null)
            {
                ViewBag.mensaje = mensaje;
            }
            //validamos la existencia de la sesion
            if (Session["carrito"] == null)
            {
                Session["carrito"] = new List<Item>();
            }

            IEnumerable<Producto> temporal = producto();
            ViewBag.categoria = lista_categoria().ToList();

            if (id_categ > 0)
            {       
                temporal = producto_categ(id_categ);
            }
            else
            {
                temporal = producto();
            }

            if (marca != "")
            {
                temporal=temporal.Where(m => m.marca.StartsWith(marca,
                    StringComparison.CurrentCultureIgnoreCase)).ToList();
            }

            int f = 12;
            int c = temporal.Count();
            int npags = c % f == 0 ? c / f : c / f + 1;
            if (temporal.Count() > 0)
            {            
                if (flecha == "ini")
                {
                    p = 0;
                }
                else if (flecha == "i")
                {
                    p--;
                    if (p < 0) p = 0;
                }
                else if (flecha == "d")
                {
                    p++;
                    if (p > npags - 1) p = npags - 1;
                }
                else if (flecha == "fin")
                {
                    p = npags - 1;
                }

                ViewBag.p = p;
                ViewBag.npags = npags;
                ViewBag.id_categ = id_categ;
                ViewBag.marca = marca;
            }
            return View(temporal.Skip(f * p).Take(f));
        }

       [HttpPost]
        public ActionResult Product(string id = null, int stock = 0, int cant = 0)
        {
            /*if (cant >= stock)
            {
                ViewBag.mensaje = "Ingrese una cantidad menor al stock";
                return View(producto());
            }*/

            Producto reg = buscar_producto(id);

            Item item = new Item();
            item.id_prod = reg.id_prod;
            item.precio = reg.precio;
            item.cant = cant;

            List<Item> temporal = (List<Item>)Session["carrito"];

            if (temporal.Count()>0)
            {
                foreach (Item c in temporal)
                {
                    if (c.id_prod.Equals(item.id_prod))
                    {
                        c.cant += item.cant;
                    }
                    else
                    {
                        temporal.Add(item);
                        break;
                    }
                }
            }
            else
            {
                temporal.Add(item);
            }
            
            ViewBag.mensaje = "Producto agregado";
            TempData["usuario"] = InicioSesion() as Usuario; //datos del usuario
            ViewBag.categoria = lista_categoria().ToList();

            return RedirectToAction("Product", new { mensaje = "Producto agregado"+temporal.Count() });
            //return null;
        }
       
        public ActionResult Detail_Product(string id)
        {
            TempData["usuario"] = InicioSesion() as Usuario;

            return View(buscar_producto(id));
        }
    }
}