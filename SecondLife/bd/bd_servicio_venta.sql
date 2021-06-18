use master
go
if db_id('bd_servicio_venta') is not null
drop database bd_servicio_venta
go
create database bd_servicio_venta
go
use bd_servicio_venta
go

/*----------------categoria----------------*/
create table tb_categoria ( 
	id_categ int identity(1,1) not null,
	nom_categ varchar(45) not null,
	descrip_categ varchar(256) not null,
	estado int not null	default 1
)
go
/* estado
		1.- activo
		2.- desactivo
*/  
alter table tb_categoria 
add constraint PKcateg primary key(id_categ)
go
alter table tb_categoria
add constraint  UQcateg_nom unique (nom_categ )
go
alter table tb_categoria 
add constraint CKcateg_est check (estado in (1, 2))
go

/*----------------tabla rol----------------*/
create table tb_rol (
	id_rol int identity(1,1) not null,
	nom_rol varchar(250) not null
)
go
alter table tb_rol
add constraint PKrol primary key (id_rol)
go
alter table tb_rol
add constraint CKrol_nom check (len(nom_rol)>=3)
go

/*----------------tabla empleado----------------*/
create table tb_usuario (
	id_usua char(5) not null,   
	dni_usua char(8) not null,
	id_rol int not null,
	nom_usua  varchar(100) not null,
	ape_usua varchar(100) not null,
	tel_usua char(9) not null,
	fec_nac_usua date not null,
	usuario varchar(15) not null, 
	pass varchar(100) not null,  
	email_log varchar(100) not null,
    estado int not null default 1
)
go
alter table tb_usuario
add constraint PKusua primary key (id_usua)
go
alter table tb_usuario
add constraint FKusua_rol foreign key(id_rol) references tb_rol(id_rol)
go
alter table tb_usuario
add constraint CKusua_dni check (len(dni_usua)=8)
go
alter table tb_usuario
add constraint CKusua_dato check (len(nom_usua)>=2 and (len(ape_usua)>=2))
go
alter table tb_usuario
add constraint CKusua_tel check (len(tel_usua)=9)
go

alter table tb_usuario
add constraint CKusua_user check (len(usuario)>=7)
go
alter table tb_usuario
add constraint CKpass check (len(pass)>=7)
go
alter table tb_usuario
add constraint CKlogin_email check (len(email_log)>=10)
go

alter table tb_usuario    
add constraint CKusua_est check (estado in (1, 2))
go

create function sigIdUsua() 
returns char(5) 
as 
begin 
	declare @ultId char(5) 
	set @ultId = (select max(id_usua) from tb_usuario) 
	if @ultId is null set @ultId = 'us000' 
	declare @i int 
	set @i = right(@ultId,3) + 1 
	return 'us' + right('00' + convert(varchar(10),@i),3) 
end
go


/*---------------tabla tarjeta----------------*/
create table tb_tarjeta (
	id_tarj char(5) not null,
    tip_tarj varchar(25) not null,
    num_tarj char(16) not null,
    fec_venc date not null,
    cvv int not null,
    id_usua char(5) not null
)
go
alter table tb_tarjeta
add constraint PKtarjeta primary key (id_tarj)
go
alter table tb_tarjeta
add constraint FKtarj_usua foreign key(id_usua) references tb_usuario(id_usua)
go
alter table tb_tarjeta
add constraint CKtarj_tip check (len(tip_tarj)>=4)
go
alter table tb_tarjeta
add constraint CKtarj_num check (len(num_tarj)=16)
go
alter table tb_tarjeta
add constraint CKtarj_cvv check (cvv>=100 and cvv<=999)
go

create function sigIdTarj() 
returns char(5) 
as 
begin 
	declare @ultId char(5) 
	set @ultId = (select max(id_tarj) from tb_tarjeta) 
	if @ultId is null set @ultId = 'tj000' 
	declare @i int 
	set @i = right(@ultId,3) + 1 
	return 'tj' + right('00' + convert(varchar(10),@i),3) 
end
go

/*----------------tabla departamento----------------*/
create table tb_departamento (
	id_dep int identity(1,1) not null,
	nom_dep varchar(100) not null
)
go
alter table tb_departamento
add constraint PKdepar primary key (id_dep)
go
alter table tb_departamento
add constraint CKdepar_nom check (len(nom_dep)>=3)
go


/*----------------tabla provincia ----------------*/
create table tb_provincia (
	id_prov int identity(1,1) not null,
	id_dep int not null,
	nom_prov varchar(100) not null
);
go
alter table tb_provincia
add constraint PKprov primary key(id_prov)
go
alter table tb_provincia
add constraint FKprov_dep foreign key(id_dep) references tb_departamento(id_dep)
go
alter table tb_provincia
add constraint CKprov_nom check (len(nom_prov)>=3)
go

/*----------------tabla distrito----------------*/
create table tb_distrito ( -- (ESTABLECIMIENTO - Cercado de Lima)
    id_dist int identity(1,1) not null,    
	id_prov int not null,    
	nom_dist varchar(100)
)
go
alter table tb_distrito 
add constraint PKdist primary key(id_dist)
go
alter table tb_distrito 
add constraint FKdist_prov foreign key(id_prov) references tb_provincia(id_prov)
go
alter table tb_distrito 
add constraint CKdist_nom check (len(nom_dist)>=3)
go
    
/*----------------tabla direccion----------------*/
create table tb_direccion(
	id_direc char(5) not null,
    latitud decimal not null,
    longitud decimal not null,
    desc_direc varchar(256) not null,
    etiqueta varchar(15) not null,
    id_dist  int not null,
	id_usua char(5) not null
)
go
alter table tb_direccion
add constraint PKdireccion primary key(id_direc)
go
alter table tb_direccion
add constraint FKdirec_usua foreign key(id_usua) references tb_usuario(id_usua)
go
alter table tb_direccion
add constraint FKdirec_dist foreign key(id_dist) references tb_distrito(id_dist)
go
alter table tb_direccion
add constraint CKdirec_desc check (len(desc_direc)>=4)
go

create function sigIdDirec() 
returns char(5) 
as 
begin 
	declare @ultId char(5) 
	set @ultId = (select max(id_direc) from tb_direccion) 
	if @ultId is null set @ultId = 'dc000' 
	declare @i int 
	set @i = right(@ultId,3) + 1 
	return 'dc' + right('00' + convert(varchar(10),@i),3) 
end
go
 

/*---------------- tabla registro ----------------*/
create table tb_registro (
	id_regis char(5) not null,
	id_categ int not null,
	id_usua char(5) not null,
	descrip_prod varchar(100) not null,
	observacion varchar(256),
	fecha_regis datetime not null default current_timestamp,
	stock int not null,
	precio decimal(8,2) not null,
    imagen varchar(256) not null,
	calidad decimal (4,2) not null,
	estado int not null default 1
)
go
/* calidad
		0-3  >> mal estado: inservible, falta de algun componente fisico, daño grave en la pintura y/o cuerpo,
				software brickeado o bloqueado. (tiempo de uso < 2 años)
		3-5  >> estado regular: daño en la pintura, cuerpo dañado o software bloqueado. (tiempo de uso < 1 año)
		5-7  >> estado bueno: ligeros rayones en el cuerpo. (tiempo de uso < 6 meses)
        7-10 >> estado excelente: practicamente como nuevo sin señales de uso. (tiempo de uso < 3 meses)
	estado
		1.- activo (aceptado)
		2.- desactivo (no aceptado)
*/
alter table  tb_registro 
add constraint PKregistro primary key(id_regis)
go
alter table  tb_registro 
add constraint FKregis_categ foreign key (id_categ) references tb_categoria(id_categ)
go
alter table  tb_registro 
add constraint FKregis_usua foreign key (id_usua) references tb_usuario(id_usua)
go
alter table  tb_registro 
add constraint CKregis_prod check (len(descrip_prod)>=10 and len(observacion)>=10)
go
alter table  tb_registro 
add constraint CKregis_prec check (precio>=5.0)
go
alter table  tb_registro
add constraint CKregis_stock check (stock>=0 and stock <=100)
go
alter table  tb_registro 
add constraint CKregis_cal check (calidad>=1 and calidad<=10)
go
alter table  tb_registro 
add constraint CKregis_esta check (estado in (1, 2))
go

create function sigIdRegis() 
returns char(5) 
as 
begin 
	declare @ultId char(5) 
	set @ultId = (select max(id_regis) from tb_registro) 
	if @ultId is null set @ultId = 'rg000' 
	declare @i int 
	set @i = right(@ultId,3) + 1 
	return 'rg' + right('00' + convert(varchar(10),@i),3) 
end
go

/*----------------tabla producto----------------*/    
create table tb_producto (
	id_prod char(5) not null,
    cod_prod char(10) not null,
	id_categ int not null,
    mar_prod varchar(100) not null,
    mod_prod varchar(100) not null,
	descrip_prod varchar(256) not null,
    observacion varchar(256) not null,
	fec_comp_prod datetime not null default current_timestamp,
    stock int not null,
    precio decimal(8,2) not null,
	imagen varchar(256) not null,
    calidad decimal (4,2) not null,
	estado int default 2
)
go
/*select id_prod, cod_prod, c.id_categ, c.nom_categ, mar_prod, mod_prod, descrip_prod, observacion, fec_comp_prod, stock, precio, imagen, calidad, p.estado from tb_producto p join tb_categoria c on p.id_categ=c.id_categ*/
/* calidad
		0-3  >> mal estado: inservible, falta de algun componente fisico, daño grave en la pintura y/o cuerpo,
				software brickeado o bloqueado. (tiempo de uso < 2 años)
		3-5  >> estado regular: daño en la pintura, cuerpo dañado o software bloqueado. (tiempo de uso < 1 año)
		5-7  >> estado bueno: ligeros rayones en el cuerpo. (tiempo de uso < 6 meses)
        7-10 >> estado excelente: practicamente como nuevo sin señales de uso. (tiempo de uso < 3 meses)
	estado
		1.- activo (listo para la venta)
		2.- desactivo (en reparacion)
*/
alter table  tb_producto
add constraint PKprod primary key (id_prod)
go
alter table  tb_producto
add constraint FKprod_categ foreign key (id_categ) references tb_categoria(id_categ)
go
alter table  tb_producto
add constraint CKprod_desc check (len(descrip_prod)>=10 and len(observacion)>=10)
go
alter table  tb_producto
add constraint CKprod_cal_comp check (calidad>=0 and calidad<=10)
go
alter table  tb_producto
add constraint CKprod_prec check (precio>=5.0)
go
alter table  tb_producto
add constraint CKprod_esta check (estado in (1, 2))
go

create function sigIdProd() 
returns char(5) 
as 
begin 
	declare @ultId char(5) 
	set @ultId = (select max(id_prod) from tb_producto) 
	if @ultId is null set @ultId = 'pd000' 
	declare @i int 
	set @i = right(@ultId,3) + 1 
	return 'pd' + right('00' + convert(varchar(10),@i),3) 
end
go

/*----------------tabla boleta----------------*/
create table tb_boleta (
	num_bol char(8) not null,
	id_usua char(5) not null,
	tipo_pago int not null,
    descrip_pago varchar(30) not null,
    id_direc char(5) not null,
	fec_bol  datetime not null default current_timestamp,
	impo_bol decimal(8,2) not null,
	envio decimal(8,2) not null,
	total_bol  decimal(8,2) not null
)
go
alter table tb_boleta
add constraint PKbol primary key (num_bol)
go
alter table tb_boleta
add constraint FKbol_usua foreign key (id_usua) references tb_usuario(id_usua)
go
alter table tb_boleta
add constraint FKbol_direc foreign key (id_direc) references tb_direccion(id_direc)
go
alter table tb_boleta
add constraint CKbol_impo check (impo_bol>=1.0)
go
alter table tb_boleta
add constraint CKbol_envio check (envio>=1.0)
go
alter table tb_boleta
add constraint CKbol_total check (total_bol>=5.0)
go
alter table tb_boleta
add constraint CKtip_pago check (tipo_pago in (1, 2))
go
    
/*
	1 - tarjeta
    2 - paypal
*/

create function sigNumBol() 
returns char(8) 
as 
begin 
	declare @ultId char(8) 
	set @ultId = (select max(num_bol) from tb_boleta) 
	if @ultId is null set @ultId = '00000000' 
	declare @i int 
	set @i = right(@ultId,8) + 1 
	return right('0000000' + convert(varchar(10),@i),8) 
end
go

/*----------------tabla detalle de boleta----------------*/
create table tb_detalle_boleta(
	num_det_bol CHAR(6) not null,
	num_bol  CHAR(8) not null,
	id_prod char(5) not null,
	cant_prod  int not null,
	precio_prod decimal(10,2) not null,
	sub_tot  decimal(8,2) not null
)
go
alter table tb_detalle_boleta
add constraint PKdetalbol primary key (num_det_bol)
go
alter table tb_detalle_boleta
add constraint FKdetalbol_bol foreign key (num_bol) references tb_boleta(num_bol)
go
alter table tb_detalle_boleta
add constraint FKdetalbol_prod foreign key (id_prod) references tb_producto(id_prod)
go
alter table tb_detalle_boleta
add constraint CKdetalbol_cant check (cant_prod>=1 and cant_prod<=5)
go
alter table tb_detalle_boleta
add constraint CKdetalbol_sub check (sub_tot>=5.0 and sub_tot<=5000)
go

create function sigNumDetBol() 
returns char(6) 
as 
begin 
	declare @ultId char(6) 
	set @ultId = (select max(num_det_bol) from tb_detalle_boleta) 
	if @ultId is null set @ultId = '000000' 
	declare @i int 
	set @i = right(@ultId,6) + 1 
	return right('00000' + convert(varchar(10),@i),6) 
end
go

/*---------------------ingreso de datos-----------------------*/
insert into tb_categoria(nom_categ, descrip_categ) values ('Laptops', 'Computadoras portátiles de peso y tamaño ligero, su tamaño es aproximado al de un portafolio.')
insert into tb_categoria(nom_categ, descrip_categ) values ('Impresoras', 'Periféricos encargados de transferir las imágenes y textos de tu PC a papel.')
insert into tb_categoria(nom_categ, descrip_categ) values ('Smartphones', 'Teléfonos celulares inteligentes.')
insert into tb_categoria(nom_categ, descrip_categ) values ('Cámaras', 'Aparatos para registrar imágenes estáticas o en movimiento.')
insert into tb_categoria(nom_categ, descrip_categ) values ('Wearables', 'Dispositivos que se usan en el cuerpo humano y que interactúan con otros aparatos para transmitir o recoger algún tipo de datos.');
insert into tb_categoria(nom_categ, descrip_categ) values ('Smart TV´s', 'Televisores inteligentes.')
insert into tb_categoria(nom_categ, descrip_categ) values ('Audio', 'Dispositivos que reproducen, graban o procesan sonido.')
go

insert into tb_departamento(nom_dep) values ('Lima')
go

insert into tb_provincia(id_dep,nom_prov) values (1, 'Lima')
go

insert into tb_distrito(id_prov,nom_dist) values (1, 'Ancón')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Ate')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Barranco')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Breña')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Carabayllo')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Chaclacayo')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Chorrillos')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Cieneguilla')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Comas')
insert into tb_distrito(id_prov,nom_dist) values (1, 'El Agustino')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Independencia')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Jesús María')
insert into tb_distrito(id_prov,nom_dist) values (1, 'La Molina')
insert into tb_distrito(id_prov,nom_dist) values (1, 'La Victoria')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Lima Centro')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Lince')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Los Olivos')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Lurín')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Magdalena')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Miraflores')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Pachacamac')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Pucusana')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Pblo. Libre')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Puente Piedra')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Punta Hermosa')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Punta Negra')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Rímac')
insert into tb_distrito(id_prov,nom_dist) values (1, 'San Bartolo')
insert into tb_distrito(id_prov,nom_dist) values (1, 'San Borja')
insert into tb_distrito(id_prov,nom_dist) values (1, 'San Isidro')
insert into tb_distrito(id_prov,nom_dist) values (1, 'San Juan de Lurigancho')
insert into tb_distrito(id_prov,nom_dist) values (1, 'San Juan de Miraflores')
insert into tb_distrito(id_prov,nom_dist) values (1, 'San Luis')
insert into tb_distrito(id_prov,nom_dist) values (1, 'San Martín de Porres')
insert into tb_distrito(id_prov,nom_dist) values (1, 'San Miguel')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Santa Anita')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Santa María del Mar')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Santa Rosa')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Santiago de Surco')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Surquillo')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Villa El Salvador')
insert into tb_distrito(id_prov,nom_dist) values (1, 'Villa María del Triunfo')
go


insert into tb_rol(nom_rol) values ('técnico infomático')
insert into tb_rol(nom_rol) values ('personal seguridad')
insert into tb_rol(nom_rol) values ('personal delivery')
insert into tb_rol(nom_rol) values ('cliente')
insert into tb_rol(nom_rol) values ('proveedor')
go

insert into tb_usuario values(dbo.sigIdUsua(),'12345678', 4, 'Alex', 'Quispe Cavero', '987654321','2002-04-23', 'clientealex', '12345678', 'alexelleon@gmail.com',1)
go

/*----------------------LAPTOPS-------------------------*/
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una laptop HP...', 'El equipo muestra ligero rapones en la pintura de la parte frontal, software y componentes en buen estado.', '2021-05-01', 20, 800.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '632541-001', 1, 'HP', '15-dw1085la', 'Procesador: i3-10110U; RAM: 4GB DDR4; ROM: 256GB SSD; Pantalla: 15,6" FHD',
								'Equipo en buen estado, pintura refaccionada', '2021-05-07', 20, 1500.0, 'https://i.ibb.co/V34qsXc/laptop1.png', 8.5, 1)
 go                              
							   
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una laptop ...', 'El equipo se muestra sin sistema operativo, y daño en uno de los puertos USB', '2021-05-10', 20, 500.0,'no imagen', 4.5, 1)                    
go
insert into tb_producto values (dbo.sigIdProd(), '632541-002', 1, 'HP', '15-dw10adde', 'Procesador: i3-10110U; RAM: 8GB DDR4; ROM: 128GB SSD; Pantalla: 15,6" FHD',
								'Equipo en buen estado, sistema instalado y puerto usb reparado', '2021-05-15', 20, 1000.0, 'https://i.ibb.co/sCXrvQh/laptop2.png', 7.5, 1)
  go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una laptop ...', 'El equipo muestra placa base destruida, pantalla inservible y teclado con falta de teclas', '2021-05-10', 1, 200.0, 'no imagen', 2.7, 1)     
go
insert into tb_producto values (dbo.sigIdProd(), '632541-003', 1, 'HP', '67-dw1085la', 'Procesador: i5-10110U; RAM: 4GB DDR4; ROM: 256GB SSD; Pantalla: 15,6" FHD',
								 'Equipo en buen estado, completamente restaurado','2021-05-25', 1, 800.0, 'https://i.ibb.co/Bfc83F3/laptop3.png', 7.0, 1)
  go                        
						  
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una laptop ...', 'El equipo muestra ligero rapones en la pintura de la parte frontal, software y componentes en buen estado.', '2021-05-10', 1, 2800.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '732685-001', 1, 'Apple', 'Macbook Air 11', 'Procesador: M1; RAM: 8GB; ROM: 256GB; Pantalla: 13" FHD',
								'Equipo en buen estado, pintura refaccionada','2020-07-07', 1, 4000.0, 'https://i.ibb.co/dbJnhfR/laptop4.png', 8.5, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una laptop ...', 'El equipo se muestra sin sistema operativo, y daño en uno de los puertos USB', '2021-05-10', 1, 2000.0, 'no imagen', 4.5, 1)                                      
go
insert into tb_producto values (dbo.sigIdProd(), '732685-002', 1, 'Apple', 'Macbook Air 12', 'Procesador: M1; RAM: 8GB; ROM: 256GB; Pantalla: 13" FHD',
								 'Equipo en buen estado, sistema instalado y puerto usb reparado', '2020-07-15', 1,  2700.0, 'https://i.ibb.co/kqzq1yW/laptop5.png', 7.5, 1)
								 go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una laptop ...', 'El equipo muestra placa base destruida, pantalla inservible y teclado con falta de teclas', '2021-05-10', 1,  1200.0, 'no imagen', 2.7, 1)                                     
go
insert into tb_producto values (dbo.sigIdProd(), '732685-003', 1, 'Apple', 'Macbook Air 13', 'Procesador: M1; RAM: 8GB; ROM: 256GB; Pantalla: 13" FHD',
								'Equipo en buen estado, completamente restaurado','2020-07-25', 1, 2000.0, 'https://i.ibb.co/WDCYBxj/laptop6.png', 7.0, 1)
 go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una laptop ...', 'El equipo muestra placa base destruida, pantalla inservible y teclado con falta de teclas', '2021-05-10', 1,  4000.0, 'no imagen', 2.7, 1)    
go
insert into tb_producto values (dbo.sigIdProd(), '852147-001', 1, 'ASUS', 'ROG Zephyrus G15', 'Procesador: Ryzen 9 4900HS; RAM: 16GB; ROM: 1TB SSD; Pantalla: 14" QHD',
								'Equipo en buen estado, completamente restaurado', '2020-11-07', 1, 7000.0, 'https://i.ibb.co/kKcfKmm/laptop7.png', 7.0, 1)
  go                              

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una laptop ...', 'El equipo muestra ligero rapones en la pintura de la parte frontal, software y componentes en buen estado.', '2021-05-10', 1, 3500.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '852147-002', 1, 'ASUS', 'ROG Zephyrus G18', 'Procesador: Ryzen 9 4900HS; RAM: 16GB; ROM: 1TB SSD; Pantalla: 14" QHD',
								'Equipo en buen estado, pintura refaccionada', '2021-11-13', 1, 6000.0, 'https://i.ibb.co/q051xyd/laptop8.png', 8.5, 1)
  go                              

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una laptop ...', 'El equipo se muestra sin sistema operativo, y daño en uno de los puertos USB', '2021-05-10', 1, 3000.0, 'no imagen', 4.5, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '852147-003', 1, 'ASUS', 'ROG Zephyrus G20', 'Procesador:Ryzen 9 4900HS; RAM: 16GB; ROM: 1TB SSD; Pantalla: 14" QHD',
								'Equipo en buen estado, sistema instalado y puerto usb reparado', '2021-11-25', 1, 5500.0, 'https://i.ibb.co/W3RxTMC/laptop9.png', 7.5, 1)
  go                              

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una laptop ...', 'El equipo se muestra sin placa base, pantalla inservible y teclado con falta de teclas', '2021-05-10', 1, 2500.0, 'no imagen', 2.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '852147-004', 1, 'ASUS', 'ROG Zephyrus G21', 'Procesador: Ryzen 9 4900HS; RAM: 16GB; ROM: 1TB SSD; Pantalla: 14" QHD',
								'Equipo en buen estado, completamente restaurado', '2021-11-30', 1, 5000.0, 'https://i.ibb.co/KK66N8J/laptop10.png', 2.0, 1)
								go


/*----------------------IMPRESORAS-------------------------*/
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una impresora ...', 'El equipo muestra ligeros raspones en el cuerpo y nivel de tinta al 50%', '2021-05-10', 1, 450.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '524786-001', 2, 'HP', 'Multifuncional Ink Tank 218', 'Capacidad: 60 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, pintura refaccionada y tinta al 100%', '2020-07-07', 1, 700.0, 'https://i.ibb.co/vJBbzRj/impresora1.png', 8.5, 1)
go
                        
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una impresora ...', 'El equipo se muestra con daños en la bandeja y sin deposito de tinta', '2021-05-10', 1, 400.0, 'no imagen', 4.5, 1)    	                                
go
insert into tb_producto values (dbo.sigIdProd(), '524786-002', 2, 'HP', 'Multifuncional Ink Tank 415', 'Capacidad: 60 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, partes refaccionadas y tinta al 100%', '2020-07-15', 1, 650.0, 'https://i.ibb.co/5jfw7M5/impresora2.png', 7.5, 1)
go
                               
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una impresora ...', 'El equipo muestra sistema de impresion dañado, partes del cuerpo rotas y sin deposito de tinta', '2021-05-10', 1, 250.0, 'no imagen', 2.7, 1)                                 
go
insert into tb_producto values (dbo.sigIdProd(), '524786-003', 2, 'HP', 'Multifuncional Ink Tank 625', 'Capacidad: 60 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, completamente restaurado y tinta al 100%','2020-07-25', 1, 550.0, 'https://i.ibb.co/k4XF5B7/impresora3.png', 7.0, 1)
 go
 
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una impresora ...', 'El equipo muestra ligeros raspones en el cuerpo y nivel de tinta al 50%', '2021-05-10', 1, 300.0, 'no imagen', 6.0, 1)                                    
go
insert into tb_producto values (dbo.sigIdProd(), '374905-001', 2, 'CANON', 'Multifuncional Color G2112', 'Capacidad: 100 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, pintura refaccionada y tinta al 100%', '2020-07-07', 1, 500.0, 'https://i.ibb.co/ZdZPpSQ/impresora4.png', 8.5, 1)
 go
 
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una impresora ...', 'El equipo se muestra con daños en la bandeja y sin deposito de tinta', '2021-05-10', 1, 250.0, 'no imagen', 4.5, 1)                                    
go
insert into tb_producto values (dbo.sigIdProd(), '374905-002', 2, 'CANON', 'Multifuncional Color G2114', 'Capacidad: 100 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, partes refaccionadas y tinta al 100%', '2020-07-15', 1,  450.0, 'https://i.ibb.co/NLBT7hK/impresora5.png', 7.5, 1)
 go
 
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una impresora ...', 'El equipo muestra sistema de impresion dañado, partes del cuerpo rotas y sin deposito de tinta', '2021-05-10', 1, 150.0, 'no imagen', 2.7, 1)                                    
go
insert into tb_producto values (dbo.sigIdProd(), '374905-003', 2, 'CANON', 'Multifuncional Color G2118', 'Capacidad: 100 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, completamente restaurado y tinta al 100%', '2020-07-25', 1, 400.0, 'https://i.ibb.co/hBg8Y9L/impresora6.png', 7.0, 1)
  go
  
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una impresora ...', 'El equipo muestra ligeros raspones en el cuerpo y nivel de tinta al 50%', '2021-05-10', 1, 700.0, 'no imagen', 6.0, 1)                                   
go
insert into tb_producto values (dbo.sigIdProd(), '842364-001', 2, 'Epson', 'Multifuncional Wifi EcoTank L4161', 'Capacidad: 100 hojas; Wi-Fi: Si; Bluetooth: No; NFC: No',
								'Equipo en buen estado, pintura refaccionada y tinta al 100%', '2020-07-07', 1, 1000.0, 'https://i.ibb.co/0cqnMQv/impresora7.png', 8.5, 1)
  go
  
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una impresora ...', 'El equipo se muestra con daños en la bandeja y sin deposito de tinta', '2021-05-10', 1, 650.0, 'no imagen', 4.5, 1)                                    
go
insert into tb_producto values (dbo.sigIdProd(), '842364-002', 2, 'Epson', 'Multifuncional Wifi EcoTank L4162', 'Capacidad: 100 hojas; Wi-Fi: Si; Bluetooth: No; NFC: No',
								'Equipo en buen estado, partes refaccionadas y tinta al 100%', '2020-07-15', 1, 850.0, 'https://i.ibb.co/kqxZ4VN/impresora8.png', 7.5, 1)
  go  
	
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una impresora ...', 'El equipo muestra sistema de impresion dañado, partes del cuerpo rotas y sin deposito de tinta', '2021-05-10', 1, 500.0, 'no imagen', 2.7, 1)                                    
go
insert into tb_producto values (dbo.sigIdProd(), '842364-003', 2, 'Epson', 'Multifuncional Wifi EcoTank L4163', 'Capacidad: 100 hojas; Wi-Fi: Si; Bluetooth: No; NFC: No',
								'Equipo en buen estado, completamente restaurado y tinta al 100%', '2020-07-25', 1, 700.0, 'https://i.ibb.co/P5CQdQY/impresora9.png', 7.0, 1)
  go
  
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una impresora ...', 'El equipo se muestra sin sistema de impresion, partes del cuerpo rotas y sin deposito de tinta', '2021-05-10', 1, 450.0, 'no imagen', 2.0, 1)    
go
insert into tb_producto values (dbo.sigIdProd(), '842364-004', 2, 'Epson', 'Multifuncional Wifi EcoTank L4164', 'Capacidad: 100 hojas; Wi-Fi: Si; Bluetooth: No; NFC: No',
								'Equipo en buen estado, completamente restaurado y tinta al 100%', '2020-07-25', 1, 650.0, 'https://i.ibb.co/G7SGpPd/impresora10.png', 7.0, 1)
  go   
	 
              
/*----------------------SMARTPHONES-------------------------*/
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una celular ...', 'El equipo muestra ligeros raspones en el cuerpo', '2021-05-10', 1, 3500.0, 'no imagen', 6.0, 1)    
go
insert into tb_producto values (dbo.sigIdProd(), '125487-001', 3, 'Apple', 'iPhone XR Yellow', 'Pantalla: 6.1" FHD+; RAM: 4GB; ROM: 128GB; Procesador: A14 Bionic; Cámara posterior: 12MP; Cámara frontal: 12MP',
								'Equipo en buen estado, pintura refaccionada', '2020-07-07', 1, 4000.0, 'https://i.ibb.co/YRzrH3S/iphonexr.png', 8.5, 1)
 go
 
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una celular ...', 'El equipo se muestra con parte posterior quebrada', '2021-05-10', 1, 3200.0, 'no imagen', 4.5, 1)                                   
go
insert into tb_producto values (dbo.sigIdProd(), '125487-002', 3, 'Apple', 'iPhone 11 Pink', 'Pantalla: 6.1" FHD+; RAM: 4GB; ROM: 128GB; Procesador: A14 Bionic; Cámara posterior: 12MP; Cámara frontal: 12MP',
								'Equipo en buen estado, vidrio reemplazado', '2020-07-15', 1, 3800.0, 'https://i.ibb.co/0rrMZt5/iphone11promax.png', 7.5, 1)
 go
 
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una celular ...', 'El equipo muestra pantalla quebrada, daño en el cuerpo y sistema bloqueado', '2021-05-10', 1, 3000.0, 'no imagen', 2.7, 1)                                    
go
insert into tb_producto values (dbo.sigIdProd(), '125487-003', 3, 'Apple', 'iPhone 12 Morado', 'Capacidad: 60 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, completamente restaurado', '2020-07-25', 1, 3500.0, 'https://i.ibb.co/sv3sC6g/iphone12.png', 7.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una celular ...', 'El equipo muestra ligeros raspones en el cuerpo', '2021-05-10', 1, 800.0, 'no imagen', 6.0, 1)                                  
go
insert into tb_producto values (dbo.sigIdProd(), '524861-001', 3, 'Xiaomi', 'Poco X3 NFC PRO Azul Noche' , 'Pantalla: 6.67" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 732G; Cámara posterior: 64MP; Cámara frontal: 20MP',
								'Equipo en buen estado, pintura refaccionada', '2020-07-07', 1, 1000.0, 'https://i.ibb.co/dMSH8kR/pocox3pro.png', 8.5, 1)
  go 
   
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una celular ...', 'El equipo se muestra con pantalla quebrada', '2021-05-10', 1, 600.0, 'no imagen', 4.5, 1)                                   
go
insert into tb_producto values (dbo.sigIdProd(), '524861-002', 3, 'Xiaomi', 'Poco X3 NFC Azul', 'Pantalla: 6.67" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 732G; Cámara posterior: 64MP; Cámara frontal: 20MP',
								'Equipo en buen estado, vidrio reemplazado', '2020-07-15', 1, 800.0, 'https://i.ibb.co/nf1bCP2/pocox3nfc.png', 7.5, 1)
  go   
	 
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una celular ...', 'El equipo muestra pantalla quebrada, daño en el cuerpo y sistema bloqueado', '2021-05-10', 1, 450.0, 'no imagen', 2.7, 1)                                    
go
insert into tb_producto values (dbo.sigIdProd(), '524861-003', 3, 'Xiaomi', 'Poco X3 Negro', 'Pantalla: 6.67" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 732G; Cámara posterior: 64MP; Cámara frontal: 20MP',
								'Equipo en buen estado, completamente restaurado', '2020-07-25', 1, 750.0, 'https://i.ibb.co/TrfXbbc/pocox3.png', 7.0, 1)
  go     
	   
 insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una celular ...', 'El equipo muestra ligeros raspones en el cuerpo', '2021-05-10', 1, 1200.0, 'no imagen', 6.0, 1)                                  
 go
insert into tb_producto values (dbo.sigIdProd(), '993254-001', 3, 'Samsung', 'Galaxy A21 Azul', 'Pantalla: 6.7" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 730; Cámara posterior: 40MP; Cámara frontal: 32MP',
								'Equipo en buen estado, pintura refaccionada', '2020-07-07', 1, 1400.0, 'https://i.ibb.co/Gp7x3zx/galaxy21.png', 8.5, 1)
    go   
	   
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una celular ...', 'El equipo se muestra con pantalla quebrada', '2021-05-10', 1, 1000.0, 'no imagen', 4.5, 1)                                   
go
insert into tb_producto values (dbo.sigIdProd(), '993254-002', 3, 'Samsung', 'Galaxy A31 Rojo', 'Pantalla: 6.7" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 730; Cámara posterior: 40MP; Cámara frontal: 32MP',
								'Equipo en buen estado, vidrio reemplazado', '2020-07-15', 1, 1200.0, 'https://i.ibb.co/mb850K5/galaxy31.png', 7.5, 1)
  go        
		  
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una celular ...', 'El equipo muestra pantalla quebrada, daño en el cuerpo y sistema bloqueado', '2021-05-10', 1, 600.0, 'no imagen', 2.7, 1)                                   
go
insert into tb_producto values (dbo.sigIdProd(), '993254-003', 3, 'Samsung', 'Galaxy A31 Blanco', 'Pantalla: 6.7" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 730; Cámara posterior: 40MP; Cámara frontal: 32MP',
								'Equipo en buen estado, completamente restaurado', '2020-07-25', 1, 800.0, 'https://i.ibb.co/0YXjPRK/galaxya51.png',  7.0, 1)
  go          
			
insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una celular ...', 'El equipo muestra pantalla inservivble, daño en la parte posterior y sistema bloqueado', '2021-05-10', 1, 550.0, 'no imagen', 2.0, 1)                                  
go
insert into tb_producto values (dbo.sigIdProd(), '993254-004', 3, 'Samsung', 'Galaxy A71 Negro', 'Capacidad: 100 hojas; Wi-Fi: Si; Bluetooth: No; NFC: No',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 750.0, 'https://i.ibb.co/fQqnpj3/galaxy71.png', 7.0, 1)
								go


							
/*----------------------CÁMARAS-------------------------*/

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una camara ...', 'El equipo muestra lente dañado', '2021-05-10', 1, 7000.0, 'no imagen', 5.0, 1)                                    
go
insert into tb_producto values (dbo.sigIdProd(), '640541-001', 4, 'SONY', 'ILCE9M2', 'Megapixeles: 24.2MP; Wi-Fi: Si; Bluetooth: Si; Peso: 1.56; Largo(cm): 7.75',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 13000.0, 'https://i.ibb.co/Zm7jX27/CAMARA-SONY-ILCE-9-M2.png', 7.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una camara ...', 'El equipo muestra agarre flojo y el software no prende', '2021-05-10', 1, 2000.0, 'no imagen', 6.0, 1)                                
go
insert into tb_producto values (dbo.sigIdProd(), '640541-002', 4, 'SONY', 'ILCE-7C NEGRO', 'Megapixeles: 24.2MP; Wi-Fi: Si; Bluetooth: Si; Peso: 1.56; Largo(cm): 9.97',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 5300.0, 'https://i.ibb.co/wRJtStW/SONY-ILCE-7-C-Black-1-Main.png', 7.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una camara ...', 'El equipo muestra lente dañado', '2021-05-10', 1, 9000.0, 'no imagen', 6.0, 1)                                    
go
insert into tb_producto values (dbo.sigIdProd(), '640541-003', 4, 'CANON', 'EOS 5D MARK IV 30.4 MM', 'Megapixeles: 30.4MP; Resolucion: 1368 x 758 ; Conexion: USB+HDMU; Video: 4K',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 13000.0, 'https://i.ibb.co/qRxdNKJ/CANON-C-MARA-REFLEX-EOS-5-D-MARK-IV-30-4-MM.png', 8.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una camara ...', 'El equipo no muestra daños', '2021-05-10', 1, 1000.0, 'no imagen', 7.0, 1)                                   
go
insert into tb_producto values (dbo.sigIdProd(), '640541-004', 4, 'CANON', 'EOS M200 24.1MP', 'Megapixeles: 24.1MP; Color: negro; Peso: 262g; Conexion: USB+HDMU',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 13000.0, 'https://i.ibb.co/xKbf8YL/CANON-C-MARA-MIRRORLESS-EOS-M200-24-1-MP.png', 7.0, 1)
  go                              

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una camara ...', 'El equipo no muestra daños', '2021-05-10', 1, 10000.0, 'no imagen', 5.0, 1)                           
go
insert into tb_producto values (dbo.sigIdProd(), '640541-005', 4, 'NIKON', 'D5 FX cuerpo versión XQD', 'Calidad de grabación: 4K Ultra HD; Distancia focal: Otro; Formatos de imagen: JPEG/RAW; Fuente de energía: Baterías',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 17000.0, 'https://i.ibb.co/2q6TtWW/C-mara-R-flex-D5-FX-cuerpo-versi-n-XQD.png', 8.0, 1)
  go                              

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una camara ...', 'El equipo muestra lente dañado y una leve abolladura', '2021-05-10', 1, 1000.0, 'no imagen', 5.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '640541-006', 4, 'NIKON', 'Z50 16-50 VR, 35 1.8 y FTZ', 'Alto: 9.3; Ancho: 6; Calidad de grabación: 4K Ultra HD; Formatos de imagen: JPEG/RAW; Fuente de energía: Baterías',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 3000.0, 'https://i.ibb.co/Q8tcym2/C-mara-Mirrorless-Z50-16-50-VR-35-1-8-y-FTZ.png', 7.0, 1)
  go                              

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una camara ...', 'El equipo muestra daño en el boton de la camara', '2021-05-10', 1, 300.0, 'no imagen', 3.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '640541-007', 4, 'PANASONIC', 'DCSD-GX850KPPK', 'Megapíxeles: 16.84 MP; Tamaño de la pantalla: 3 pulgadas; Formatos de imagen: JPEG/RAW; Sensibilidad ISO: Auto, 100-25600, (102400 max)',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 1200.0, 'https://i.ibb.co/hZKf4Vt/C-mara-semiprofesional-4-K-Ultra-HD-16-84-mpx-DCSD-GX850-KPPK.png', 7.0, 1)
  go                              

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una camara ...', 'El equipo muestra daño en el boton de la camara', '2021-05-10', 1, 300.0, 'no imagen', 4.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '640541-008', 4, 'PANASONIC', 'DCSD-GX850KPPS', 'Megapíxeles: 16.84 MP; Tamaño de la pantalla: 3 pulgadas; Formatos de imagen: JPEG/RAW; Sensibilidad ISO: Auto, 100-25600, (102400 max)',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 1700.0, 'https://i.ibb.co/3MHRqmb/C-mara-semiprofesional-16-84-mpx-4-K-Ultra-HD-DCSD-GX850-KPPS.png', 7.0, 1)
  go                              

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una camara ...', 'El equipo muestra desgasto', '2021-05-10', 1, 500.0, 'no imagen', 5.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '640541-009', 4, 'CANON', 'VIXIA HF W11', 'Tipo: Cámaras de video; Alto: 59.5 mm; Ancho: 60 mm; Calidad de grabación: Full HD, Memoria; 96GB',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 1300.0, 'https://i.ibb.co/861vvLF/Camara-De-Video-Vixia-Hf-W11.png', 7.0, 1)
  go                              

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una camara ...', 'El equipo muestra lente dañado', '2021-05-10', 1, 1500.0, 'no imagen', 5.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '640541-010', 4, 'SONY', 'FDR-AX43/BC UC2', 'Alto: 8.05 cm; Ancho: 7.3 cm; Calidad de grabación: 4K Ultra HD; Distancia focal: Otro; Formatos de imagen: JPEG/XAVCX/MP4',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 2500.0, 'https://i.ibb.co/23mYnwt/C-mara-de-video-FDR-AX43-sensor-CMOS-Exmor-R.png', 7.0, 1)
								go

/*----------------------WEAREABLES-------------------------*/

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una WEAREABLES ...', 'El equipo muestra lentitud de software', '2021-05-10', 1, 500.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '857701-001', 5, 'SAMSUNG', 'SM-R810NZKAPEO', 'Memoria interna: 4 GB; Tamaño de Pantalla: 1.2"; Resolución de Pantalla: 360x360 px; Bluetooth: Bluetooth v4.2',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 2500.0, 'https://i.ibb.co/PGzbZS0/pe-galaxy-watch-r810-sm-r810nzkapeo-frontblack-117616162.png', 8.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una WEAREABLES ...', 'El equipo muestra rajadura en la correa', '2021-05-10', 1, 400.0, 'no imagen', 4.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '857701-002', 5, 'SAMSUNG', 'SM-R830NZDAPEO', 'Carcasa: 40 mm; Correa: 20 mm; Dimensiones: 39,5 mm x 39,5 mm x 10,5 mm; Peso (sin correa): 25 g; Pantalla: OLED de 1,1 pulgadas (360 x 360); Procesador: Exynos 9110 de doble núcleo a 1,15 GHz; Almacenamiento: 4GB; RAM: 750 MB',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 1100.0, 'https://i.ibb.co/XZwc7ZD/Galaxy-Watch-Active2-40mm-Pink.png', 7.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una WEAREABLES ...', 'El equipo muestra desgasto', '2021-05-10', 1, 80.0, 'no imagen', 5.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '857701-003', 5, 'SAMSUNG', 'SM-R220NZKALTA', 'Sensores: Acelerómetro, Giroscopio, Sensor óptico de frecuencia cardíaca; Memoria: 2MB(RAM); Interna 32 MB',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 300.0, 'https://i.ibb.co/f4LRNjH/Galaxy-Fit2-Black.png', 7.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una WEAREABLES ...', 'El equipo muestra desgasto', '2021-05-10', 1, 50.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '857701-004', 5, 'HUAWEI', 'HUAWEI Band 6 Amber Sunrise', '96 modos de ejercicio diferentes; Medición de SpO2 día y noche;  Pantalla FullView; Duración de la batería de 2 semanas; Compatible con Android e iOS*',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 150.0, 'https://i.ibb.co/cv2STsY/orange-plp.png', 8.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una WEAREABLES ...', 'El equipo muestra lentitud de software', '2021-05-10', 1, 60.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '857701-005', 5, 'HUAWEI', 'HUAWEI WATCH FIT Black', 'Pantalla AMOLED brillante de 1.64 pulgadas; Animaciones de entrenamiento rápido; Detección de saturación de oxígeno SPO2; Compatible con Android e iOS*',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 300.0, 'https://i.ibb.co/MpRfnHv/HUAWEI-WATCH-FIT-Black.png', 7.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una WEAREABLES ...', 'El equipo muestra lentitud de software', '2021-05-10', 1, 700.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '857701-006', 5, 'APPLE', 'Apple Watch Series 5', 'Sistema operativo: watchOS 6; Almacenamiento: 32GB; Sensores: Accelerometer, Altimeter, Barometer, Compass, Gyroscope, Heart Rate, Light Sensor; Rastreador: Si; Micrófono: Si; Altavoz incorporado: Si; Vibración; Si',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 1300.0, 'https://i.ibb.co/Cm1Lssv/Promart-Apple-Watch-Series-5-GPS-44mm-Rose-Gold.png', 8.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una WEAREABLES ...', 'El equipo muestra desgaste en la correa', '2021-05-10', 1, 500.0, 'no imagen', 5.0, 1)                                 
go
insert into tb_producto values (dbo.sigIdProd(), '857701-007', 5, 'APPLE', 'SERIES 3 GPS 42MM GRIS ESPACIAL', '8 GB de capacidad; Pantalla de vidrio Ion-X; Cubierta trasera de composite; Wifi (802.11b/g/n a 2,4 GHz); Bluetooth 4.2; Hasta 18 horas de autonomía2',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 2500.0, 'https://i.ibb.co/R38hM1Q/APPLE-WATCH-SERIES-3-42-MM-GPS-COLOR-GRIS-ESPACIAL.png', 5.0, 1)
								go


/*----------------------SMART TV'S-------------------------*/

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una SMART TVS ...', 'El equipo muestra gasto de uso', '2021-05-10', 1, 900.0, 'no imagen', 6.0, 1)                                  
go
insert into tb_producto values (dbo.sigIdProd(), '260022-001', 6, 'AOC', '55U6295', 'Tamaño de Pantalla: 55"; Tipo de Pantalla: LED; Smart TV:	Sí; Diseño de pantalla: Plana; Definición de Pantalla: 4K UHD; WiFi integrado: Sí',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 1400.0, 'https://i.ibb.co/7CW8tQK/TV-AOC-LED-Smart-55-55-U6295.png', 7.0, 1);
	go	

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una SMART TVS ...', 'El equipo muestra una pata de la bse rota', '2021-05-10', 1, 100.0, 'no imagen', 5.0, 1)                                
go
insert into tb_producto values (dbo.sigIdProd(), '260022-002', 6, 'AOC', '32S5295', 'Tamaño de Pantalla: 32"; Tipo de Pantalla: LED; Diseño de pantalla: Plana; Definición: HD; WiFi: Sí; Bluetooth: No; Cámara: No; Entradas HDMI: 3',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 700.0, 'https://i.ibb.co/R20fwBr/TV-AOC-LED-HD-Smart-32-32-S5295.png', 6.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una SMART TVS ...', 'El equipo muestra DESGASTO', '2021-05-10', 1, 1500.0, 'no imagen', 7.0, 1)                                 
go
insert into tb_producto values (dbo.sigIdProd(), '260022-003', 6, 'LG', '55NANO80SPA', 'Tamaño: 55"; Pantalla:	Panel IPS 4K Nano cell; Dimming: Local Dimming; Resolución: 3840x 2160 px; WiFi: Sí; Bluetooth: Sí; Sistema Operativo: webOS 6.0',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 3000.0, 'https://i.ibb.co/yYh7xwv/TV-LG-LED-4-K-Nano-Cell-Thin-Q-AI-55-55-NANO80-2021.png', 8.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una SMART TVS ...', 'El equipo muestra daño en el control remoto', '2021-05-10', 1, 200.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '260022-004', 6, 'LG', '32LM637B', 'Tamaño: 32"; Pantalla: LED; Resolución: 1280x720 px; WiFi: Sí; Bluetooth: Sí; Sistema Operativo: webOS 4.5',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 700.0, 'https://i.ibb.co/vwbW8NK/TV-LG-LED-HD-Thin-Q-AI-32-32-LM637-B.png', 7.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una SMART TVS ...', 'El equipo muestra pata rota', '2021-05-10', 1, 200.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '260022-005', 6, 'MIRAY', 'MS32-T1000BT', 'Tamaño: 32"; Pantalla: LED; Resolucion: 1366x768 px; Diseño: Plana; Definición: HD; WiFi: Sí; Bluetooth: Sí; Sistema Operativo: Android 9',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 1100.0, 'https://i.ibb.co/Chm5n4S/TV-Miray-LED-HD-Smart-32-MS32-T1000-BT.png', 8.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una SMART TVS ...', 'El equipo se demora en prender', '2021-05-10', 1, 1000.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '260022-006', 6, 'MIRAY', 'MK50-E201', 'Tamaño: 50"; Pantalla: LED; Diseño: Plana; Definición: 4K UHD; WiFi: Sí; Bluetooth: No; Sistema Operativo: Linux; Cámara: No; Entradas HDMI: 3',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 1500.0, 'https://i.ibb.co/cDtzrCW/TV-Miray-LED-4-K-UHD-Smart-50-MK50-E201.png', 7.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una SMART TVS ...', 'El equipo muestra una raya en la pantalla mas una mala conexion HDMI', '2021-05-10', 1, 1000.0, 'no imagen', 6.0, 1)                                  
go
insert into tb_producto values (dbo.sigIdProd(), '260022-007', 6, 'PHILIPS', '70PUD6774', 'Tamaño: 70"; Tipo: LED; Diseño: Plana; Definición: 4K UHD; WiFi: Sí; Bluetooth: No; Cámara: No; Entradas HDMI: 3; Puertos USB: 2',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 2500.0, 'https://i.ibb.co/xH5McRR/TV-Philips-4-K-UHD-LED-Smart-70-70-PUD6774.png', 8.0, 1)
go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una SMART TVS ...', 'El equipo muestra gasto de uso', '2021-05-10', 1, 900.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '260022-008', 6, 'PHILIPS', 'PUD6654', 'Tamaño de Pantalla: 55"; Tipo de Pantalla: LED; Smart TV:	Sí; Diseño de pantalla: Plana; Definición de Pantalla: 4K UHD; WiFi integrado: Sí',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 1400.0, 'https://i.ibb.co/7QVYdS5/TV-Philips-LED-4-K-UHD-Smart-50-50-PUD6654.png', 8.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una SMART TVS ...', 'El equipo presenta malña conexion del HDMI', '2021-05-10', 1, 900.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '260022-009', 6, 'SAMSUNG', 'UN43AU7000GXPE', 'Tamaño: 43"; Pantalla: LED; Definición: 4K Ultra HD; WiFi: Sí; Bluetooth: Sí; Sistema Operativo: Tizen; Cámara: No; Entradas HDMI: 3; Entradas ethernet: 1',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 1500.0, 'https://i.ibb.co/QQMjX7j/TV-Samsung-LED-4-K-UHD-Smart-43-UN43-AU7000-GXPE.png', 7.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es una SMART TVS ...', 'El equipo muestra una pata de la base rota', '2021-05-10', 1, 1000.0, 'no imagen', 5.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '260022-010', 6, 'SAMSUNG', 'QN50Q60AAGXPE', 'Tamaño: 50"; Pantalla: QLED; Definición: 4K; WiFi: Sí; Bluetooth: Sí; Sistema Operativo: Tizen: Cámara: No; Entradas HDMI: 3; Entradas ethernet: 1; Puertos USB: 2',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 2000.0, 'https://i.ibb.co/hV6fLc4/TV-Samsung-LED-4-K-QLED-Smart-50-QN50-Q60-AAGXPE.png', 8.0, 1)
								go

/*----------------------AUDIO-------------------------*/

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es un AUDIFONO ...', 'El equipo muestra audio estatico', '2021-05-10', 1, 40.0, 'no imagen', 5.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '840188-001', 7, 'ANTRYX', 'S. KLIPER 7.1 AGH-8000SR7', 'Audio: 7.1; Inalámbrico: No; Micrófono: Si; Control: No; Plegable: No; Cancelacion de ruido: No',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 120.0, 'https://i.ibb.co/njjJLPR/Aud-fono-Antryx-S-KLIPER-7-1-AGH-8000-SR7.png', 7.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es un AUDIFONO ...', 'El equipo no detecta el microfono', '2021-05-10', 1, 40.0, 'no imagen', 5.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '840188-002', 7, 'ANTRYX', 'Enigma', 'Inalámbrico: No; Micrófono: Sí; Control de volumen: Sí; Plegable: No; Potencia: 112dB ± 3dB; Sensibilidad: -42 ± 3dB; Frecuencia: 20 Hz a 20000 Hz',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 140.0, 'https://i.ibb.co/WnWJxjz/Aud-fono-con-micr-fono-Antryx-Enigma.png', 7.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es un AUDIFONO ...', 'El equipo muestra orejeras desgastadas', '2021-05-10', 1, 100.0, 'no imagen', 5.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '840188-003', 7, 'HYPERX', 'HX-HSCA-RD/AM', 'Inalámbrico: No; Micrófono: Sí; Control de volumenç: Sí; Plegable: No; Sensibilidad: -43dBV (0dB=1V/Pa,1kHz); Impedencia: 65Ω; Cancelacion de ruido:	Sí',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 230.0, 'https://i.ibb.co/F3NWg1d/Aud-fono-Hyper-X-Cloud-Alpha.png', 7.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es un AUDIFONO ...', 'El equipo muestra mala conexion', '2021-05-10', 1, 100.0, 'no imagen', 5.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '840188-004', 7, 'HYPERX', 'HX-HSCLS-BL/AM', 'Inalámbrico: No; Micrófono: Si; Control de volumen: Si; Plegable: No; Cancelacion de ruido: No; Sensibilidad: -39dBV (0dB=1V/Pa,1kHz); Impedencia: 41Ω; Cancelacion de ruido: Sí',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 230.0, 'https://i.ibb.co/JrWHQ5h/Aud-fono-Hyper-X-Cloud-for-PS4.png', 7.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es un AUDIFONO ...', 'El equipo muestra audio estatico', '2021-05-10', 1, 150.0, 'no imagen', 5.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '840188-005', 7, 'CORSAIR', 'HS70 Pro', 'Peso: 330g; tipo de audifonos: Over Ear; Inalámbrico: Sí; Micrófono: Sí; Control de volumen: Sí; Plegable: Sí; Alcance: 12 Mtr; Batería: 16 horas; Sensibilidad: 111dB (+/-3dB); Frecuencia: 20 Hz a 20 kHz',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 340.0, 'https://i.ibb.co/X2hmHmM/Aud-fonos-Gamer-HS70-Pro-Wireless-Cream.png', 7.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es un AUDIFONO ...', 'El equipo muetra desgasto', '2021-05-10', 1, 200.0, 'no imagen', 5.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '840188-006', 7, 'LG', 'PM7', 'Alto: 12.7 cm; Ancho: 33.3 cm; Profundidad: 16.3 cm; Inalámbrico: Sí; Potencia	30 W; Funciones destacadas: bluetooth speaker',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 340.0, 'https://i.ibb.co/4NQ73Lr/Parlante-Port-til-LG-XBOOM-Go-PM7-2020.png', 7.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es un PARLANTE ...', 'El equipo muestra audio estatico', '2021-05-10', 1, 150.0, 'no imagen', 5.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '840188-007', 7, 'SONY', 'SRS-XB33/BC LA', 'Alto: 9.7 cm; Ancho: 24.6 cm; Inalámbrico: Sí; Iluminación estética: Sí; Tipo de Batería: Batería integrada; Duración de la batería: Hasta 24 horas',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 120.0, 'https://i.ibb.co/Jqb32Ft/Parlante-inal-mbrico-Sony-con-Bluetooth-y-Waterproof-SRS-XB33-Negro.png', 7.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es un PARLANTE ...', 'El equipo muestra audio estatico', '2021-05-10', 1, 180.0, 'no imagen', 5.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '840188-008', 7, 'PIONEER', 'TS-A1600C', 'Potencia: 350W - 80W RMS; Funciones destacadas: - Tamaño de Tweeter: 29 mm, - Concepto de diseño de sonido Open & Smooth: Experimenta la excelencia en sonido y rendimiento para obtener un sonido óptimo en el automóvil.',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 350.0, 'https://i.ibb.co/crjj58q/Parlante-Pioneer-TS-A1600-C.png', 7.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es un PARLANTE ...', 'El equipo muestra audio estatico', '2021-05-10', 1, 150.0, 'no imagen', 5.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '840188-009', 7, 'LOGITECH', 'Z407', 'Total de vatios (pico): 80W; Total de vatios reales (RMS): 40W; Subwoofer: 20W; Altavoces satélite: 2 x 10W; Entrada de 3.5 mm: 1; Entrada micro USB: 1; Bluetooth: 5.0',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 300.0, 'https://i.ibb.co/t3s8PFt/Z407-Bluetooth-Computer-Speakers-with-Subwoofer-and-Wireless-control.png', 7.0, 1)
								go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'us001', 'Es un PARLANTYE ...', 'El equipo muestra audio estatico', '2021-05-10', 1, 200.0, 'no imagen', 5.0, 1)                               
go
insert into tb_producto values (dbo.sigIdProd(), '840188-010', 7, 'LOGITECH', 'G560', 'Total de vatios de pico: 240 W; Total de vatios reales: 120 W; Versión de Bluetooth: 4.1; Confiable radio de acción de 25 metros con línea de visión directa; Entrada USB: 1; Toma de audífonos: 1',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 600.0, 'https://i.ibb.co/pzbWbPt/G560.png', 7.0, 1)
								go

/*-------------------------------------------------------------------------------*/
/*---------------------------procedimiento almacenado----------------------------*/
/*-------------------------------------------------------------------------------*/
create or alter proc sp_listado_producto
as
	select id_prod, cod_prod, p.id_categ, mar_prod, mod_prod, descrip_prod, observacion,
	fec_comp_prod, stock, precio, p.imagen, calidad, p.estado from tb_producto p
	inner join  tb_categoria c
	on p.id_categ=c.id_categ
	order by mar_prod
go

exec sp_listado_producto
go

create or alter proc sp_listado_producto_id
@id varchar(5)
as
	select id_prod, cod_prod, p.id_categ, mar_prod, mod_prod, descrip_prod, observacion,
	fec_comp_prod, stock, precio, p.imagen, calidad, p.estado from tb_producto p
	inner join  tb_categoria c
	on p.id_categ=c.id_categ
	where p.id_prod=@id
go

create or alter proc sp_listado_producto_cat
@cat int
as
	select id_prod, cod_prod, p.id_categ, mar_prod, mod_prod, descrip_prod, observacion,
	fec_comp_prod, stock, precio, p.imagen, calidad, p.estado from tb_producto p
	inner join  tb_categoria c
	on p.id_categ=c.id_categ
	where p.id_categ=@cat
go

exec sp_listado_producto_cat 1
go

create or alter proc sp_buscar_user
@user varchar(15),
@pass varchar(100)
as
	select * from tb_usuario 
	where usuario=@user and pass=@pass
go

exec sp_buscar_user 'clientealex', '12345678'

/*-------------------------------------------------------------------------------*/
/*
select*from tb_boleta;
select*from tb_categoria;
select*from tb_departamento;
select*from tb_detalle_boleta;
select*from distrito;
select*from tb_usuario;
select*from tb_producto;
select*from tb_provincia;
select*from tb_registro;
select*from tb_rol;
*/