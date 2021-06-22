using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;
using SecondLife.Models;
using System.Globalization;

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
                reg.calidad = dr.GetDecimal(11);
                reg.estado = dr.GetInt32(12);
                temporal.Add(reg);
            }
            dr.Close(); cn.Close();
            return temporal;
        }
        IEnumerable<Producto> producto_calidad()
        {
            List<Producto> temporal = new List<Producto>();
            SqlConnection cn = new SqlConnection(cadena);
            SqlCommand cmd = new SqlCommand("sp_listado_producto_calidad", cn);
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
            while (dr.Read())
            {
                Usuario reg = new Usuario();
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
                temporal.Add(reg);
            }
            dr.Close(); cn.Close();
            return temporal;
        }
        IEnumerable<Tarjeta> lista_tarjeta(string id)
        {
            List<Tarjeta> temporal = new List<Tarjeta>();
            SqlConnection cn = new SqlConnection(cadena);
            SqlCommand cmd = new SqlCommand("sp_lista_tarjeta", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@id", id);
            cn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                Tarjeta reg = new Tarjeta();
                reg.id_tarj = dr.GetString(0);
                reg.tip_tarj = dr.GetString(1);
                reg.num_tarj = dr.GetString(2);
                reg.fec_venc = dr.GetString(3);
                reg.cvv = dr.GetInt32(4);
                reg.id_usua = dr.GetString(5);
                temporal.Add(reg);
            }
            dr.Close(); cn.Close();
            return temporal;
        }
        IEnumerable<Direccion> lista_direccion(string id)
        {
            List<Direccion> temporal = new List<Direccion>();
            SqlConnection cn = new SqlConnection(cadena);
            SqlCommand cmd = new SqlCommand("sp_lista_direccion", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@id", id);
            cn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                Direccion reg = new Direccion();
                reg.id_direc = dr.GetString(0);
                reg.desc_direc = dr.GetString(1);
                reg.referencia = dr.GetString(2);
                reg.etiqueta = dr.GetString(3);
                reg.id_dist = dr.GetInt32(4);
                reg.id_usua = dr.GetString(5);
                temporal.Add(reg);
            }
            dr.Close(); cn.Close();
            return temporal;
        }

        IEnumerable<Distrito> lista_distrito()
        {
            List<Distrito> temporal = new List<Distrito>();
            SqlConnection cn = new SqlConnection(cadena);
            SqlCommand cmd = new SqlCommand("select*from tb_distrito", cn);
            cn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                Distrito reg = new Distrito();
                reg.id_dist = dr.GetInt32(0);
                reg.id_prov = dr.GetInt32(1);
                reg.nom_dist = dr.GetString(2);
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
        private void addProduct(string id = null, int cant = 0)
        {
            Producto reg = buscar_producto(id);

            Item item = new Item();
            item.imagen = reg.imagen;
            item.nom_prod = reg.marca + " " + reg.modelo;
            item.id_prod = reg.id_prod;
            item.precio = reg.precio;
            item.cant = cant;

            List<Item> temporal = (List<Item>)Session["carrito"];

            if (temporal.Count() > 0)
            {
                Boolean tag = true;
                foreach (Item c in temporal)
                {
                    if (c.id_prod == item.id_prod)
                    {
                        c.cant += item.cant;
                        tag = false;
                        break;
                    }
                }
                if (tag)
                {
                    temporal.Add(item);
                }
            }
            else
            {
                temporal.Add(item);
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
        Usuario buscar_usuario(string usuario = null, string pass = null)
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
        public List<Producto> producto_carrito( List<Producto> producto)
        {
            List<Item> temporal = (List<Item>)Session["carrito"];
            List<Producto> lista = new List<Producto>();
            foreach (Producto p in producto.ToList())
            {
                foreach (Item i in temporal)
                {
                    if (p.id_prod == i.id_prod)
                    {
                        p.stock = p.stock - i.cant;
                    }
                }
                lista.Add(p);
            }
            return lista;
        }
        /*--------------metodos de actionresult--------------------*/
        /*--------------------------------------------------------*/
        /*----------------------ADMIN------------------------------*/
        public ActionResult Index(string mensaje=null)
        {
            //validamos la existencia de la sesion
            if (Session["carrito"] == null)
            {
                Session["carrito"] = new List<Item>();
                ViewBag.producto = producto_calidad().ToList();
            }
            else
            {
                ViewBag.producto = producto_carrito(producto_calidad().ToList());
            }              
           
            if (mensaje != null)
            {
                ViewBag.mensaje = mensaje;
            }

            TempData["usuario"] = InicioSesion() as Usuario; //datos del usuario
            ViewBag.categoria = lista_categoria().ToList();
            return View();
        }
        [HttpPost]
        public ActionResult Index(string id = null, int stock = 0, int cant = 0)
        {
            string mensaje = null;
            if (cant > stock || cant < 1)
            {
                mensaje = "Ingrese cantidad válida";
            }
            else
            {
                addProduct(id, cant); //agregar al carrito de compra
                mensaje = "Producto agregado";
            }

            TempData["usuario"] = InicioSesion() as Usuario; //datos del usuario
            ViewBag.categoria = lista_categoria().ToList();

            return RedirectToAction("Index", new { mensaje = mensaje });
            //return null;
        }

        /*--------------------------------------------------------*/
        /*-----------------PROCESO DE CLIENTE------------*/
        public ActionResult Login()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Login(string user, string pass,Boolean pay= false, double subtotal=0,
            double descuento=0, double total=0)
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
                if (pay)
                {
                    return RedirectToAction("Pay_Data", new { subtotal=subtotal, descuento=descuento, total=total});
                }
                else
                {
                    return RedirectToAction("Index", new { mensaje = "Ha iniciado sesion" });
                }
            }
        }
        public ActionResult RegisterUser(string mensaje=null)
        {
            if (mensaje != null)
            {
                ViewBag.mensaje = mensaje;
            }
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
                cmd.Parameters.AddWithValue("@tel", reg.tel_usua);
                cmd.Parameters.AddWithValue("@fec_nac_usua", reg.fec_nac_usua);
                cmd.Parameters.AddWithValue("@usuario", reg.usuario);
                cmd.Parameters.AddWithValue("@pass", reg.pass);
                cmd.Parameters.AddWithValue("@email_log", reg.email_log);

                int i = 0;
                i=cmd.ExecuteNonQuery();
                if (i > 0)
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
            return RedirectToAction("RegisterUser", new { mensaje=ViewBag.mensaje});
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

            IEnumerable<Producto> temporal = producto();
            //validamos la existencia de la sesion
            if (Session["carrito"] == null)
            {
                Session["carrito"] = new List<Item>();
            }
            else
            {
                temporal = producto_carrito(producto().ToList()).ToList();
            }

            ViewBag.categoria = lista_categoria().ToList();

            if (id_categ > 0)
            {
                temporal = temporal.Where(m => m.id_categ == id_categ);
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
            string mensaje = null;
            if (cant>stock || cant <1)
            {
                mensaje = "Ingrese cantidad válida";
            }
            else
            {
                addProduct(id, cant); //agregar al carrito de compra
                mensaje = "Producto agregado";
            }

            TempData["usuario"] = InicioSesion() as Usuario; //datos del usuario
            ViewBag.categoria = lista_categoria().ToList();

            return RedirectToAction("Product", new { mensaje = mensaje});
            //return null;
        }
       
        public ActionResult Detail_Product(string mensaje, string id)
        {
            TempData["usuario"] = InicioSesion() as Usuario;
            if (mensaje != null)
            {
                ViewBag.mensaje = mensaje;
            }

            Producto reg = buscar_producto(id);
            if (Session["carrito"] != null)
            {
                List<Item> temporal = (List<Item>)Session["carrito"];
                foreach(Item i in temporal)
                {
                    if (reg.id_prod == i.id_prod)
                    {
                        reg.stock = reg.stock - i.cant;
                    }
                }
            }
            return View(reg); 
        }
 
        [HttpPost]
        public ActionResult Detail_Product(string id = null, int stock = 0, int cant = 0)
        {

            string mensaje = null;
            if (cant > stock || cant < 1)
            {
                mensaje = "Ingrese cantidad válida";
            }
            else
            {
                addProduct(id, cant); //agregar al carrito de compra
                mensaje = "Producto agregado";
            }

            return RedirectToAction("Detail_Product", new { mensaje = mensaje });
        }

        public ActionResult Shopping_cart(string mensaje=null)
        {
            if (mensaje != null)
            {
                ViewBag.mensaje = mensaje;
            }
            TempData["usuario"] = InicioSesion() as Usuario;
            List<Item> temporal = null;
            if (Session["carrito"] != null)
            {
                temporal= (List<Item>)Session["carrito"]; 
            }
            double total_prod = 0.0;
            double descuento = 0.0;
            double total = 0.0;
            if (temporal!=null)
            {
                foreach (Item t in temporal)
                {
                    total_prod +=(double)t.sub_total;
                }
                if (total_prod > 10)
                {
                    descuento = 10 % total_prod;
                    total = total_prod - descuento;
                }
            }
            ViewBag.subtotal = total_prod;
            ViewBag.descuento = descuento;
            ViewBag.total = total;
            return View(temporal);
        }

        public ActionResult Delete(string id=null, string nombre=null)
        {

            if (Session["carrito"] != null)
            {
                List<Item> temporal = (List<Item>)Session["carrito"];
                Item reg = temporal.Find(i => i.id_prod == id);
                temporal.Remove(reg);

                return RedirectToAction("Shopping_cart", new { mensaje = "Producto (" + nombre + ") fue eliminado" });
            }
            else
            {
                return RedirectToAction("Shopping_cart");
            }
        }
        /*----------direccion y tarjeta-------------*/
        public ActionResult Address()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Address(Direccion reg)
        {
            SqlConnection cn = new SqlConnection(cadena);
            cn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand("sp_insertar_direccion", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@desc", reg.desc_direc);
                cmd.Parameters.AddWithValue("@referencia", reg.referencia);
                cmd.Parameters.AddWithValue("@etiqueta", reg.etiqueta);
                cmd.Parameters.AddWithValue("@id_dist", reg.id_dist);
                cmd.Parameters.AddWithValue("@id_usua", reg.id_usua);

                int i = 0;
                i = cmd.ExecuteNonQuery();
                if (i > 0)
                {
                    ViewBag.mensaje = "Direccion agregada";
                }
            }
            catch (SqlException e)
            {
                ViewBag.mensaje = "Error al agregar direccion, vuelve a intentarlo";
            }
            finally
            {
                cn.Close();
            }
            ViewBag.mensaje = reg.desc_direc+ "hola";
            return RedirectToAction("Pay_Data", new { mensaje=ViewBag.mensaje});
        }
        /*--------------------Proceso de pago---------------------*/
        public ActionResult Pay_Data(string id=null, string nombre=null, double subtotal = 0, double total=0, 
            string mensaje = null, double descuento = 0)
        {
            if (mensaje != null)
            {
                ViewBag.mensaje = mensaje;
            }
            if (((List<Item>)Session["carrito"]).Count() <1)
            {
                return RedirectToAction("Shopping_cart", new { mensaje = "Escoja al menos un producto" });
            }
            else
            {
                if (InicioSesion() == null)
                {
                    return RedirectToAction("Login", new { pay = true, subtotal=subtotal, descuento=descuento, total=total });
                }
                else
                {
                    ViewBag.subtotal = subtotal;
                    ViewBag.descuento = descuento;
                    ViewBag.total = total;
                    Usuario reg = InicioSesion() as Usuario;
                    ViewBag.usuario = reg.nom_usua + " " + reg.ape_usua;
                    ViewBag.actual = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(DateTime.Now.ToString("dddd, dd MMMM yyyy"));
                    TempData["usuario"] = InicioSesion() as Usuario;

                    ViewBag.usua = reg.id_usua;
                    ViewBag.direccion = new SelectList(lista_direccion(reg.id_usua), "id_direc", "etiqueta");
                    ViewBag.distrito = new SelectList(lista_distrito(), "id_dist", "nom_dist");
                    return View();
                }
            }           
        }
        [HttpPost]
        public ActionResult Pay_Data(Direccion reg, double subtotal = 0, double total = 0, double descuento = 0)
        {
            Usuario u= InicioSesion() as Usuario;
            SqlConnection cn = new SqlConnection(cadena);
            cn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand("sp_insertar_direccion", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@desc", reg.desc_direc);
                cmd.Parameters.AddWithValue("@referencia", reg.referencia);
                cmd.Parameters.AddWithValue("@etiqueta", reg.etiqueta);
                cmd.Parameters.AddWithValue("@id_dist", reg.id_dist);
                cmd.Parameters.AddWithValue("@id_usua", u.id_usua);

                int i = 0;
                i = cmd.ExecuteNonQuery();
                if (i > 0)
                {
                    ViewBag.mensaje = "Direccion agregada";
                }
            }
            catch (SqlException e)
            {
                ViewBag.mensaje = "Error al agregar direccion, vuelve a intentarlo";
            }
            finally
            {
                cn.Close();
            }

            return RedirectToAction("Pay_Data", new { mensaje = ViewBag.mensaje, subtotal= subtotal ,
                descuento= descuento,  total= total });
        }
        public ActionResult Payment_Methods(double subtotal = 0, double total = 0, 
            double descuento = 0, string id_direc=null, string mensaje=null)
        {
            if (mensaje != null)
            {
                ViewBag.mensaje = mensaje;
            }

            TempData["usuario"] = InicioSesion() as Usuario;
            Usuario reg = InicioSesion() as Usuario;
            ViewBag.usuario = reg.nom_usua + " " + reg.ape_usua;
            ViewBag.subtotal = subtotal;
            ViewBag.descuento = descuento;
            ViewBag.total = total;        
            ViewBag.usua = reg.id_usua;
            if (id_direc != null)
            {
                ViewBag.direccion = lista_direccion(reg.id_usua).Where(d => d.id_direc == id_direc).FirstOrDefault().desc_direc;
                ViewBag.id_direc = id_direc;
            }
            ViewBag.tarjeta = new SelectList(lista_tarjeta(reg.id_usua), "id_tarj", "num_tarj");
            return View();
        }
        [HttpPost]
        public ActionResult Payment_Methods(Tarjeta reg, double subtotal = 0, double total = 0,
            double descuento = 0, string id_direc = null)
        {
            int num_tip = int.Parse(reg.num_tarj.Substring(0));
            if (num_tip == 4)
            {
                reg.tip_tarj = "Visa";
            }else if (num_tip == 5)
            {
                reg.tip_tarj = "Mastercad";
            }
            else
            {
                reg.tip_tarj = "Desconocido";
            }
            /*---agregar tarjeta--------*/
            Usuario u = InicioSesion() as Usuario;
            SqlConnection cn = new SqlConnection(cadena);
            cn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand("sp_insertar_tarjeta", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@tip_tarj", reg.tip_tarj);
                cmd.Parameters.AddWithValue("@num_tarj", reg.num_tarj);
                cmd.Parameters.AddWithValue("@fec_venc", reg.fec_venc);
                cmd.Parameters.AddWithValue("@cvv", reg.cvv);
                cmd.Parameters.AddWithValue("@id_usua", u.id_usua);
                int i = 0;
                i = cmd.ExecuteNonQuery();
                if (i > 0)
                {
                    ViewBag.mensaje = "Tarjeta agregada";
                }
            }
            catch (SqlException e)
            {
                ViewBag.mensaje = "Error al agregar tarjeta, vuelve a intentarlo";
            }
            finally
            {
                cn.Close();
            }

            return RedirectToAction("Payment_Methods", new { mensaje = ViewBag.mensaje,
                subtotal = subtotal,
                descuento = descuento,
                total = total,
                id_direc=id_direc
            });
        }

        public ActionResult Confirm_Payment(double subtotal = 0, double descuento = 0, double total = 0,
            string id_direc = null, string id_tarj = null)
        {
            TempData["usuario"] = InicioSesion() as Usuario;
            Usuario u = InicioSesion() as Usuario;
            ViewBag.subtotal = subtotal;
            ViewBag.descuento = descuento;
            ViewBag.total = total;
            ViewBag.id_direc = id_direc;
            ViewBag.id_tarj = id_tarj;
        
            Direccion dc = lista_direccion(u.id_usua).Where(d => d.id_direc == id_direc).FirstOrDefault();
            Tarjeta tj = lista_tarjeta(u.id_usua).Where(t => t.id_tarj == id_tarj).FirstOrDefault();
            ViewBag.direccion = dc.desc_direc + " "+lista_distrito().Where(di=>di.id_dist==dc.id_dist).FirstOrDefault().nom_dist+
                " ("+ dc.etiqueta+") ";
            ViewBag.tarjeta = tj.num_tarj + " (" + tj.tip_tarj + ")";

            ViewBag.carrito= (List<Item>)Session["carrito"];
            return View();
        }

        public ActionResult Make_Pagament(double subtotal = 0, double descuento = 0, double total = 0,
            string id_direc = null, string id_tarj = null)
        {
            Usuario reg = Session["login"] as Usuario;
            List<Item> temporal = (List<Item>)Session["carrito"];
            string mensaje = null;
            SqlConnection cn = new SqlConnection(cadena);
            cn.Open();
            SqlTransaction tr = cn.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                SqlCommand cmd = new SqlCommand("sp_insertar_boleta", cn, tr);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@id_usua", reg.id_usua);
                cmd.Parameters.AddWithValue("@id_direc", id_direc);
                cmd.Parameters.AddWithValue("@id_tarj", id_tarj);
                cmd.Parameters.AddWithValue("@impo_bol", subtotal);
                cmd.Parameters.AddWithValue("@desc_bol", descuento);
                cmd.Parameters.AddWithValue("@envio", 0);
                cmd.Parameters.AddWithValue("@total_bol", total);
                cmd.ExecuteNonQuery();


                foreach (Item item in temporal)
                {
                    cmd = new SqlCommand("sp_insertar_detalle_boleta", cn, tr);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@id_prod", item.id_prod);
                    cmd.Parameters.AddWithValue("@cant_prod", item.cant);
                    cmd.Parameters.AddWithValue("@precio_prod", item.precio);
                    cmd.Parameters.AddWithValue("@sub_tot", item.sub_total);
                    cmd.ExecuteNonQuery();
                }

                tr.Commit(); //actualiza
                mensaje = "Se ha realizado correctamente la transacción, gracias por tu compra";
            }
            catch (SqlException ex)
            {
                mensaje = "No se puede realizar proceso, vuelva a intentarlo";
                tr.Rollback();
            }
            finally
            {
                Session["carrito"] = new List<Item>();
            }
            return RedirectToAction("Shopping_Cart", new { mensaje = mensaje });
        }

    }
}