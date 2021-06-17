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


/*---------------tabla login----------------*/
create table tb_login (
	id_log char(5) not null,
	usuario varchar(15) not null, 
	pass varchar(15) not null,  
	email_log varchar(100) not null,
    estado int not null	default 1
)
go
alter table tb_login 
add constraint PKlogin primary key (id_log)
go
alter table tb_login 
add constraint CKusua check (len(usuario)>=7)
go
alter table tb_login 
add constraint CKpass check (len(pass)>=7)
go
alter table tb_login 
add constraint CKlogins_est check (estado in (1, 2))
go
alter table tb_login 
add constraint CKlogin_email check (len(email_log)>=10)
go

create function sigIdLogin() 
returns char(5) 
as 
begin 
	declare @ultId char(5) 
	set @ultId = (select max(id_log) from tb_login) 
	if @ultId is null set @ultId = 'lg000' 
	declare @i int 
	set @i = right(@ultId,3) + 1 
	return 'lg' + right('00' + convert(varchar(10),@i),3) 
end
go

/*CREATE TRIGGER tg_insertar_idlogin ON tb_login
INSTEAD OF INSERT
AS
BEGIN
	
END
GO*/

/*---------------tabla numero de cuenta----------------*/
create table tb_tarjeta (
	id_tarj char(5) not null,
    tip_tarj varchar(25) not null,
    num_tarj char(16) not null,
    fec_venc date not null,
    cvv int not null,
    id_log char(5) not null
)
go
alter table tb_tarjeta
add constraint PKtarjeta primary key (id_tarj)
go
alter table tb_tarjeta
add constraint FKtarj_log foreign key(id_log) references tb_login(id_log)
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
	id_log char(5) not null
)
go
alter table tb_direccion
add constraint PKdireccion primary key(id_direc)
go
alter table tb_direccion
add constraint FKdirec_log foreign key(id_log) references tb_login(id_log)
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

/*----------------tabla rol----------------*/
create table tb_rol (
	id_rol int identity(1,1) not null,
	nom_rol varchar(250) not null,
	sue_min decimal(8,2) not null,
	sue_max decimal(8,2) not null
)
go
alter table tb_rol
add constraint PKrol primary key (id_rol)
go
alter table tb_rol
add constraint CKrol_nom check (len(nom_rol)>=3)
go
alter table tb_rol
add constraint CKrol_suemax check (sue_min>=930 and sue_min<=1200)
go
alter table tb_rol
add constraint CKrol_suemin check (sue_max>=1200 and sue_max<=5000)
go
 
/*----------------tabla empleado----------------*/
create table tb_empleado (
	id_emp char(5) not null,   
	dni_emp char(8) not null,
	id_rol int not null,
	nom_emp  varchar(100) not null,
	ape_emp varchar(100) not null,
	tel_emp char(9) not null,
	dir_emp varchar(256) not null,   
	fec_nac_emp timestamp not null,
	obs_emp  varchar(256),
	sue_emp decimal(8,2) not null,
    id_log char(5) not null,
    estado int not null default 1
)
go
alter table tb_empleado
add constraint PKemp primary key (id_emp)
go
alter table tb_empleado
add constraint FKemp_rol foreign key(id_rol) references tb_rol(id_rol)
go
alter table tb_empleado
add constraint FKemp_log foreign key (id_log) references tb_login (id_log)
go
alter table tb_empleado
add constraint CKemp_dni check (len(dni_emp)=8)
go
alter table tb_empleado
add constraint CKemp_dato check (len(nom_emp)>=2 and (len(ape_emp)>=2))
go
alter table tb_empleado
add constraint CKemp_tel check (len(tel_emp)=9)
go
alter table tb_empleado
add constraint CKemp_sue check (sue_emp>=0 and sue_emp<=5000)
go
alter table tb_empleado
add constraint CKemp_est check (estado in (1, 2))
go

create function sigIdEmp() 
returns char(5) 
as 
begin 
	declare @ultId char(5) 
	set @ultId = (select max(id_emp) from tb_empleado) 
	if @ultId is null set @ultId = 'ep000' 
	declare @i int 
	set @i = right(@ultId,3) + 1 
	return 'ep' + right('00' + convert(varchar(10),@i),3) 
end
go

/*----------------tabla cliente----------------*/
create table tb_cliente (
	id_clie char(5) not null,
	dni_clie char(8) not null, 
	nom_clie varchar(100) not null,
	ape_clie varchar(100) not null,
	fec_nac_clie date not null default current_timestamp,
    tel_clie char(9),
    id_log char(5),
    estado int default 1
)
go
alter table tb_cliente 
add constraint PKclie primary key (id_clie)
go
alter table tb_cliente 
add constraint FKclie_log foreign key (id_log) references tb_login (id_log)
go
alter table tb_cliente 
add constraint CKclie_dni check (len(dni_clie)=8)
go
alter table tb_cliente 
add constraint CKclie_dato check (len(nom_clie)>=2 and (len(ape_clie)>=2))
go
alter table tb_cliente 
add constraint CKclie_tel check (len(tel_clie)=9)
go
alter table tb_cliente 
add constraint CKclie_est check (estado in (1, 2, null))
go

create function sigIdClie() 
returns char(5) 
as 
begin 
	declare @ultId char(5) 
	set @ultId = (select max(id_clie) from tb_cliente) 
	if @ultId is null set @ultId = 'cl000' 
	declare @i int 
	set @i = right(@ultId,3) + 1 
	return 'cl' + right('00' + convert(varchar(10),@i),3) 
end
go

/*---------------- tabla registro ----------------*/
create table tb_registro (
	id_regis char(5) not null,
	id_categ int not null,
	id_clie char(5) not null,
	descrip_prod varchar(100) not null,
	observacion varchar(256),
	fecha_regis datetime not null default current_timestamp,
	stock int not null,
	precio decimal(8,2) not null,
    image varchar(256) not null,
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
add constraint FKregis_clie foreign key (id_clie) references tb_cliente(id_clie)
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
	image varchar(256) not null,
    calidad decimal (4,2) not null,
	estado int default 2
)
go
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
	id_log char(5) not null,
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
add constraint FKbol_log foreign key (id_log) references tb_login(id_log)
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
insert into tb_categoria(nom_categ, descrip_categ) values ('Laptops', 'Computadoras portátiles de peso y tamaño ligero, su tamaño es aproximado al de un portafolio.');
go
insert into tb_categoria(nom_categ, descrip_categ) values ('Impresoras', 'Periféricos encargados de transferir las imágenes y textos de tu PC a papel.');
go
insert into tb_categoria(nom_categ, descrip_categ) values ('Smartphones', 'Teléfonos celulares inteligentes.');
go
insert into tb_categoria(nom_categ, descrip_categ) values ('Cámaras', 'Aparatos para registrar imágenes estáticas o en movimiento.');
go
insert into tb_categoria(nom_categ, descrip_categ) values ('Wearables', 'Dispositivos que se usan en el cuerpo humano y que interactúan con otros aparatos para transmitir o recoger algún tipo de datos.');
go
insert into tb_categoria(nom_categ, descrip_categ) values ('Smart TV´s', 'Televisores inteligentes.');
go
insert into tb_categoria(nom_categ, descrip_categ) values ('Audio', 'Dispositivos que reproducen, graban o procesan sonido.');
go

insert into tb_departamento(nom_dep) values ('Lima');
go

insert into tb_provincia(id_dep,nom_prov) values (1, 'Lima');
go

insert into tb_distrito(id_prov,nom_dist) values (1, 'Cercado de Lima');
go
insert into tb_distrito(id_prov,nom_dist) values (1, 'San Luis');    
go
insert into tb_distrito(id_prov,nom_dist) values (1, 'Breña');    
go
insert into tb_distrito(id_prov,nom_dist) values (1, 'La Victoria');    
go
insert into tb_distrito(id_prov,nom_dist) values (1, 'Rimac');
go
insert into tb_distrito(id_prov,nom_dist) values (1, 'Lince');    
go
insert into tb_distrito(id_prov,nom_dist) values (1, 'San Miguel');
go
insert into tb_distrito(id_prov,nom_dist) values (1, 'Jesús María');
go
insert into tb_distrito(id_prov,nom_dist) values (1, 'Magdalena');    
go
insert into tb_distrito(id_prov,nom_dist) values (1, 'Pblo. Libre');
go


insert into tb_login(id_log, usuario, pass, email_log) values (dbo.sigIdLogin(), 'madel_12', '12345678', 'madeliyricra@gmail.com');
go
insert into tb_login(id_log, usuario, pass, email_log) values (dbo.sigIdLogin(), 'calax590', '321654987', 'luizito590@gmail.com');
go
insert into tb_login(id_log, usuario, pass, email_log) values (dbo.sigIdLogin(), 'mknecroc12', '741852963', 'willymas123@gmail.com');
go
insert into tb_login(id_log, usuario, pass, email_log) values (dbo.sigIdLogin(), 'maver78', '987523641', 'maverick78@gmail.com');
go


insert into tb_cliente values (dbo.sigIdClie(),'70915220', 'Madeliy', 'Ricra Gutierrez', '2002-04-23', '987654321', 'lg001', 1);
go
insert into tb_cliente values (dbo.sigIdClie(),'72450000', 'Luis Fernando', 'Pérez Burga', '2000-09-05', '987654321', 'lg002', 1);
go
insert into tb_cliente values (dbo.sigIdClie(),'72397705', 'Willy Alberto', 'Melendez Gamarra', '2000-10-21', '987654321', 'lg003', 1);
go
insert into tb_cliente values (dbo.sigIdClie(),'71234568', 'Maverick', 'Champi Romero', '1999-05-07', '987654321', 'lg004', 1);
go
insert into tb_cliente values (dbo.sigIdClie(),'76428945', 'Juan', 'Rodriguez Suarez', '2002-04-23',  '987654321', null, 1);
go
insert into tb_cliente values (dbo.sigIdClie(),'73248756', 'Roberto', 'Fernandez Ramirez', '2002-04-23', '987654321', null, 1);
go
insert into tb_cliente values (dbo.sigIdClie(),'73200896', 'Alex', 'Quispe Cavero', '2002-04-23', '987654321', null, 1);
go

insert into tb_rol(nom_rol,sue_min,sue_max) values ('técnico infomático', 1200, 2000);
go
insert into tb_rol(nom_rol,sue_min,sue_max) values ('personal seguridad', 1200, 1800);
go
insert into tb_rol(nom_rol,sue_min,sue_max) values ('personal delivery', 930, 1200);
go

/*----------------------LAPTOPS-------------------------*/
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una laptop HP...', 'El equipo muestra ligero rapones en la pintura de la parte frontal, software y componentes en buen estado.', '2021-05-01', 1, 800.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '632541-001', 1, 'HP', '15-dw1085la', 'Procesador: i3-10110U; RAM: 4GB DDR4; ROM: 256GB SSD; Pantalla: 15,6" FHD','Equipo en buen estado, pintura refaccionada', '2021-05-07', 1, 1500.0, 'no imagen', 8.5, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una laptop ...', 'El equipo se muestra sin sistema operativo, y daño en uno de los puertos USB', '2021-05-10', 1, 500.0,'no imagen', 4.5, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '632541-002', 1, 'HP', '15-dw1085la', 'Procesador: i3-10110U; RAM: 4GB DDR4; ROM: 256GB SSD; Pantalla: 15,6" FHD','Equipo en buen estado, sistema instalado y puerto usb reparado', '2021-05-15', 1, 1000.0, 'no imagen', 7.5, 1)
go
  
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una laptop ...', 'El equipo muestra placa base destruida, pantalla inservible y teclado con falta de teclas', '2021-05-10', 1, 200.0, 'no imagen', 2.7, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '632541-003', 1, 'HP', '15-dw1085la', 'Procesador: i3-10110U; RAM: 4GB DDR4; ROM: 256GB SSD; Pantalla: 15,6" FHD','Equipo en buen estado, completamente restaurado','2021-05-25', 1, 800.0, 'no imagen', 7.0, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una laptop ...', 'El equipo muestra ligero rapones en la pintura de la parte frontal, software y componentes en buen estado.', '2021-05-10', 1, 2800.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '732685-001', 1, 'Apple', 'Macbook Air 13', 'Procesador: M1; RAM: 8GB; ROM: 256GB; Pantalla: 13" FHD','Equipo en buen estado, pintura refaccionada','2020-07-07', 1, 4000.0, 'no imagen', 8.5, 1)
go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una laptop ...', 'El equipo se muestra sin sistema operativo, y daño en uno de los puertos USB', '2021-05-10', 1, 2000.0, 'no imagen', 4.5, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '732685-002', 1, 'Apple', 'Macbook Air 13', 'Procesador: M1; RAM: 8GB; ROM: 256GB; Pantalla: 13" FHD','Equipo en buen estado, sistema instalado y puerto usb reparado', '2020-07-15', 1,  2700.0, 'no imagen', 7.5, 1)
go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una laptop ...', 'El equipo muestra placa base destruida, pantalla inservible y teclado con falta de teclas', '2021-05-10', 1,  1200.0, 'no imagen', 2.7, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '732685-003', 1, 'Apple', 'Macbook Air 13', 'Procesador: M1; RAM: 8GB; ROM: 256GB; Pantalla: 13" FHD','Equipo en buen estado, completamente restaurado','2020-07-25', 1, 2000.0, 'no imagen', 7.0, 1)
go
 
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una laptop ...', 'El equipo muestra placa base destruida, pantalla inservible y teclado con falta de teclas', '2021-05-10', 1,  4000.0, 'no imagen', 2.7, 1)     
go
insert into tb_producto values (dbo.sigIdProd(), '852147-001', 1, 'ASUS', 'ROG Zephyrus G14', 'Procesador: Ryzen 9 4900HS; RAM: 16GB; ROM: 1TB SSD; Pantalla: 14" QHD','Equipo en buen estado, completamente restaurado', '2020-11-07', 1, 7000.0, 'no imagen', 7.0, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una laptop ...', 'El equipo muestra ligero rapones en la pintura de la parte frontal, software y componentes en buen estado.', '2021-05-10', 1, 3500.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '852147-002', 1, 'ASUS', 'ROG Zephyrus G14', 'Procesador: Ryzen 9 4900HS; RAM: 16GB; ROM: 1TB SSD; Pantalla: 14" QHD','Equipo en buen estado, pintura refaccionada', '2021-11-13', 1, 6000.0, 'no imagen', 8.5, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una laptop ...', 'El equipo se muestra sin sistema operativo, y daño en uno de los puertos USB', '2021-05-10', 1, 3000.0, 'no imagen', 4.5, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '852147-003', 1, 'ASUS', 'ROG Zephyrus G14', 'Procesador:Ryzen 9 4900HS; RAM: 16GB; ROM: 1TB SSD; Pantalla: 14" QHD','Equipo en buen estado, sistema instalado y puerto usb reparado', '2021-11-25', 1, 5500.0, 'no imagen', 7.5, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una laptop ...', 'El equipo se muestra sin placa base, pantalla inservible y teclado con falta de teclas', '2021-05-10', 1, 2500.0, 'no imagen', 2.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '852147-004', 1, 'ASUS', 'ROG Zephyrus G14', 'Procesador: Ryzen 9 4900HS; RAM: 16GB; ROM: 1TB SSD; Pantalla: 14" QHD','Equipo en buen estado, completamente restaurado', '2021-11-30', 1, 5000.0, 'no imagen', 2.0, 1)
go


/*----------------------IMPRESORAS-------------------------*/
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una impresora ...', 'El equipo muestra ligeros raspones en el cuerpo y nivel de tinta al 50%', '2021-05-10', 1, 450.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '524786-001', 2, 'HP', 'Multifuncional Ink Tank 415', 'Capacidad: 60 hojas; Wi-Fi: No; Bluetooth: No; NFC: No','Equipo en buen estado, pintura refaccionada y tinta al 100%', '2020-07-07', 1, 700.0, 'no imagen', 8.5, 1)
go
                        
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una impresora ...', 'El equipo se muestra con daños en la bandeja y sin deposito de tinta', '2021-05-10', 1, 400.0, 'no imagen', 4.5, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '524786-002', 2, 'HP', 'Multifuncional Ink Tank 415', 'Capacidad: 60 hojas; Wi-Fi: No; Bluetooth: No; NFC: No','Equipo en buen estado, partes refaccionadas y tinta al 100%', '2020-07-15', 1, 650.0, 'no imagen', 7.5, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una impresora ...', 'El equipo muestra sistema de impresion dañado, partes del cuerpo rotas y sin deposito de tinta', '2021-05-10', 1, 250.0, 'no imagen', 2.7, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '524786-003', 2, 'HP', 'Multifuncional Ink Tank 415', 'Capacidad: 60 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, completamente restaurado y tinta al 100%','2020-07-25', 1, 550.0, 'no imagen', 7.0, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una impresora ...', 'El equipo muestra ligeros raspones en el cuerpo y nivel de tinta al 50%', '2021-05-10', 1, 300.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '374905-001', 2, 'CANON', 'Multifuncional Color G2110', 'Capacidad: 100 hojas; Wi-Fi: No; Bluetooth: No; NFC: No','Equipo en buen estado, pintura refaccionada y tinta al 100%', '2020-07-07', 1, 500.0, 'no imagen', 8.5, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una impresora ...', 'El equipo se muestra con daños en la bandeja y sin deposito de tinta', '2021-05-10', 1, 250.0, 'no imagen', 4.5, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '374905-002', 2, 'CANON', 'Multifuncional Color G2110', 'Capacidad: 100 hojas; Wi-Fi: No; Bluetooth: No; NFC: No','Equipo en buen estado, partes refaccionadas y tinta al 100%', '2020-07-15', 1,  450.0, 'no imagen', 7.5, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una impresora ...', 'El equipo muestra sistema de impresion dañado, partes del cuerpo rotas y sin deposito de tinta', '2021-05-10', 1, 150.0, 'no imagen', 2.7, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '374905-003', 2, 'CANON', 'Multifuncional Color G2110', 'Capacidad: 100 hojas; Wi-Fi: No; Bluetooth: No; NFC: No','Equipo en buen estado, completamente restaurado y tinta al 100%', '2020-07-25', 1, 400.0, 'no imagen', 7.0, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una impresora ...', 'El equipo muestra ligeros raspones en el cuerpo y nivel de tinta al 50%', '2021-05-10', 1, 700.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '842364-001', 2, 'Epson', 'Multifuncional Wifi EcoTank L4160', 'Capacidad: 100 hojas; Wi-Fi: Si; Bluetooth: No; NFC: No','Equipo en buen estado, pintura refaccionada y tinta al 100%', '2020-07-07', 1, 1000.0, 'no imagen', 8.5, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una impresora ...', 'El equipo se muestra con daños en la bandeja y sin deposito de tinta', '2021-05-10', 1, 650.0, 'no imagen', 4.5, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '842364-002', 2, 'Epson', 'Multifuncional Wifi EcoTank L4160', 'Capacidad: 100 hojas; Wi-Fi: Si; Bluetooth: No; NFC: No','Equipo en buen estado, partes refaccionadas y tinta al 100%', '2020-07-15', 1, 850.0, 'no imagen', 7.5, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una impresora ...', 'El equipo muestra sistema de impresion dañado, partes del cuerpo rotas y sin deposito de tinta', '2021-05-10', 1, 500.0, 'no imagen', 2.7, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '842364-003', 2, 'Epson', 'Multifuncional Wifi EcoTank L4160', 'Capacidad: 100 hojas; Wi-Fi: Si; Bluetooth: No; NFC: No','Equipo en buen estado, completamente restaurado y tinta al 100%', '2020-07-25', 1, 700.0, 'no imagen', 7.0, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una impresora ...', 'El equipo se muestra sin sistema de impresion, partes del cuerpo rotas y sin deposito de tinta', '2021-05-10', 1, 450.0, 'no imagen', 2.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '842364-004', 2, 'Epson', 'Multifuncional Wifi EcoTank L4160', 'Capacidad: 100 hojas; Wi-Fi: Si; Bluetooth: No; NFC: No','Equipo en buen estado, completamente restaurado y tinta al 100%', '2020-07-25', 1, 650.0, 'no imagen', 7.0, 1)
go
              
              
/*----------------------SMARTPHONES-------------------------*/
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una celular ...', 'El equipo muestra ligeros raspones en el cuerpo', '2021-05-10', 1, 3500.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '125487-001', 3, 'Apple', 'iPhone 12 Blue', 'Pantalla: 6.1" FHD+; RAM: 4GB; ROM: 128GB; Procesador: A14 Bionic; Cámara posterior: 12MP; Cámara frontal: 12MP','Equipo en buen estado, pintura refaccionada', '2020-07-07', 1, 4000.0, 'no imagen', 8.5, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una celular ...', 'El equipo se muestra con parte posterior quebrada', '2021-05-10', 1, 3200.0, 'no imagen', 4.5, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '125487-002', 3, 'Apple', 'iPhone 12 Blue', 'Pantalla: 6.1" FHD+; RAM: 4GB; ROM: 128GB; Procesador: A14 Bionic; Cámara posterior: 12MP; Cámara frontal: 12MP','Equipo en buen estado, vidrio reemplazado', '2020-07-15', 1, 3800.0, 'no imagen', 7.5, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una celular ...', 'El equipo muestra pantalla quebrada, daño en el cuerpo y sistema bloqueado', '2021-05-10', 1, 3000.0, 'no imagen', 2.7, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '125487-003', 3, 'Apple', 'iPhone 12 Blue', 'Capacidad: 60 hojas; Wi-Fi: No; Bluetooth: No; NFC: No','Equipo en buen estado, completamente restaurado', '2020-07-25', 1, 3500.0, 'no imagen', 7.0, 1)
go

insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una celular ...', 'El equipo muestra ligeros raspones en el cuerpo', '2021-05-10', 1, 800.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '524861-001', 3, 'Xiaomi', 'Poco X3 NFC', 'Pantalla: 6.67" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 732G; Cámara posterior: 64MP; Cámara frontal: 20MP','Equipo en buen estado, pintura refaccionada', '2020-07-07', 1, 1000.0, 'no imagen', 8.5, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una celular ...', 'El equipo se muestra con pantalla quebrada', '2021-05-10', 1, 600.0, 'no imagen', 4.5, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '524861-002', 3, 'Xiaomi', 'Poco X3 NFC', 'Pantalla: 6.67" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 732G; Cámara posterior: 64MP; Cámara frontal: 20MP','Equipo en buen estado, vidrio reemplazado', '2020-07-15', 1, 800.0, 'no imagen', 7.5, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una celular ...', 'El equipo muestra pantalla quebrada, daño en el cuerpo y sistema bloqueado', '2021-05-10', 1, 450.0, 'no imagen', 2.7, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '524861-003', 3, 'Xiaomi', 'Poco X3 NFC', 'Pantalla: 6.67" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 732G; Cámara posterior: 64MP; Cámara frontal: 20MP','Equipo en buen estado, completamente restaurado', '2020-07-25', 1, 750.0, 'no imagen', 7.0, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una celular ...', 'El equipo muestra ligeros raspones en el cuerpo', '2021-05-10', 1, 1200.0, 'no imagen', 6.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '993254-001', 3, 'Samsung', 'Galaxy A71 Blanco', 'Pantalla: 6.7" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 730; Cámara posterior: 40MP; Cámara frontal: 32MP','Equipo en buen estado, pintura refaccionada', '2020-07-07', 1, 1400.0, 'no imagen', 8.5, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una celular ...', 'El equipo se muestra con pantalla quebrada', '2021-05-10', 1, 1000.0, 'no imagen', 4.5, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '993254-002', 3, 'Samsung', 'Galaxy A71 Blanco', 'Pantalla: 6.7" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 730; Cámara posterior: 40MP; Cámara frontal: 32MP','Equipo en buen estado, vidrio reemplazado', '2020-07-15', 1, 1200.0, 'no imagen', 7.5, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una celular ...', 'El equipo muestra pantalla quebrada, daño en el cuerpo y sistema bloqueado', '2021-05-10', 1, 600.0, 'no imagen', 2.7, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '993254-003', 3, 'Samsung', 'Galaxy A71 Blanco', 'Pantalla: 6.7" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 730; Cámara posterior: 40MP; Cámara frontal: 32MP','Equipo en buen estado, completamente restaurado', '2020-07-25', 1, 800.0, 'no imagen',  7.0, 1)
go
                                
insert into tb_registro values (dbo.sigIdRegis(), 1, 'cl001', 'Es una celular ...', 'El equipo muestra pantalla inservivble, daño en la parte posterior y sistema bloqueado', '2021-05-10', 1, 550.0, 'no imagen', 2.0, 1)
go
insert into tb_producto values (dbo.sigIdProd(), '993254-004', 3, 'Samsung', 'Galaxy A71 Blanco', 'Capacidad: 100 hojas; Wi-Fi: Si; Bluetooth: No; NFC: No','Equipo en buen estado, completamente restaurado', '2020-07-25',  1, 750.0, 'no imagen', 7.0, 1)
go

/*----------------------CÁMARAS-------------------------*/


/*----------------------WEAREABLES-------------------------*/


/*----------------------SMART TV'S-------------------------*/


/*----------------------AUDIO-------------------------*/

/*-------------------------------------------------------------------------------*/
/*---------------------------procedimiento almacenado----------------------------*/
/*-------------------------------------------------------------------------------*/
create or alter proc sp_listado_producto
as
	select id_prod, cod_prod, p.id_categ, mar_prod, mod_prod, descrip_prod, observacion,
	fec_comp_prod, stock, precio, p.image, calidad, p.estado from tb_producto p
	inner join  tb_categoria c
	on p.id_categ=c.id_categ
go

exec sp_listado_producto
go

create or alter proc sp_listado_producto_id
@id varchar(5)
as
	select id_prod, cod_prod, p.id_categ, mar_prod, mod_prod, descrip_prod, observacion,
	fec_comp_prod, stock, precio, p.image, calidad, p.estado from tb_producto p
	inner join  tb_categoria c
	on p.id_categ=c.id_categ
	where p.id_prod=@id
go

create or alter proc sp_listado_producto_cat
@cat int
as
	select id_prod, cod_prod, p.id_categ, mar_prod, mod_prod, descrip_prod, observacion,
	fec_comp_prod, stock, precio, p.image, calidad, p.estado from tb_producto p
	inner join  tb_categoria c
	on p.id_categ=c.id_categ
	where p.id_categ=@cat
go
/*-------------------------------------------------------------------------------*/
/*
select*from tb_boleta;
select*from tb_categoria;
select*from tb_cliente;
select*from tb_departamento;
select*from tb_detalle_boleta;
select*from distrito;
select*from tb_empleado;
select*from tb_login;
select*from tb_producto;
select*from tb_provincia;
select*from tb_registro;
select*from tb_rol;
*/