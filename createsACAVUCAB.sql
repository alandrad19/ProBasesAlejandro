CREATE TABLE Lugar(
FK_Lugar numeric(10),
Codigo_lugar numeric(10) NOT NULL UNIQUE,
Nombre_lugar varchar(50) NOT NULL,
Tipo_lugar varchar(10) NOT NULL,
CONSTRAINT PK_Codigo_lugar_Lugar PRIMARY KEY(Codigo_lugar),
CONSTRAINT FK_Lugar_Lugar FOREIGN KEY(FK_Lugar) references Lugar(Codigo_lugar) ON DELETE Cascade,
CONSTRAINT Check_Tipo_lugar_Lugar CHECK(Tipo_lugar in ('Estado','Municipio','Parroquia')));

CREATE TABLE Proveedor(
Rif_proveedor varchar(10) NOT NULL UNIQUE,
Razon_social varchar(30) NOT NULL,
Denominacion_comercial varchar(30) NOT NULL,
Direccion_fiscal varchar(200) NOT NULL,
Direccion_fisica varchar(200) NOT NULL,
FK_Lugar_fiscal numeric(10) NOT NULL,	
FK_Lugar_fisica numeric(10) NOT NULL,
CONSTRAINT PK_Rif_proveedor_Proveedor PRIMARY KEY(Rif_proveedor),
CONSTRAINT FK_Lugar_Fisico_Proveedor FOREIGN KEY(FK_Lugar_fisica)references Lugar(Codigo_lugar) ON DELETE Cascade,
CONSTRAINT FK_Lugar_Fiscal_Proveedor FOREIGN KEY(FK_Lugar_fiscal)references Lugar(Codigo_lugar) ON DELETE Cascade);

CREATE TABLE Cliente(
Rif_cliente varchar(10) NOT NULL UNIQUE,
Cantidad_puntos numeric(10) NOT NULL,
Cedula_natural varchar(50),
Primer_nombre varchar(50),
Segundo_nombre varchar(50),
Primer_apellido varchar(50),
Segundo_apellido varchar(50),
Denominacion_comercial varchar(50),
Razon_social varchar(50),
Pagina_web varchar(50),
Capital_disponible varchar(50),
Direccion_fiscal varchar(50),
Direccion_fisica varchar(50),
Tipo_cliente varchar(50) NOT NULL,
FK_Lugar_fisica numeric(10) NOT NULL,
FK_Lugar_fiscal numeric(10),
CONSTRAINT PK_Rif_cliente_Cliente PRIMARY KEY(Rif_cliente),
CONSTRAINT FK_Lugar_Cliente_Fisica FOREIGN KEY(FK_Lugar_fisica) references Lugar(Codigo_lugar) ON DELETE Cascade,
CONSTRAINT FK_Lugar_Cliente_Fiscal FOREIGN KEY(FK_Lugar_fiscal) references Lugar(Codigo_lugar) ON DELETE Cascade,
CONSTRAINT Check_Tipo_cliente_Cliente CHECK(Tipo_cliente in ('Natural','Juridico')));

CREATE TABLE Persona_contacto(
Codigo_persona_contacto serial NOT NULL UNIQUE,
Nombre_contacto varchar(20) NOT NULL,
Apellido_contacto varchar(20) NOT NULL,
FK_Cliente varchar(50),
FK_Proveedor varchar(10),
CONSTRAINT PK_Codigo_persona_contacto_Persona_Contacto PRIMARY KEY (Codigo_persona_contacto),
CONSTRAINT FK_Cliente_Persona_Contacto FOREIGN KEY(FK_Cliente) references Cliente(Rif_cliente) ON DELETE Cascade,
CONSTRAINT FK_Proveedor_Persona_Contacto FOREIGN KEY (FK_Proveedor) references Proveedor(Rif_proveedor) ON DELETE Cascade);

CREATE TABLE Telefono(
Codigo_telefono serial NOT NULL UNIQUE,
Codigo_area numeric(10) NOT NULL,
numero numeric(10) NOT NULL,
FK_Proveedor varchar(10),
FK_Cliente varchar(10),
FK_Contacto integer,
CONSTRAINT PK_Codigo_Telefono_Telefono PRIMARY KEY (Codigo_telefono),
CONSTRAINT FK_Proveedor_Telefono FOREIGN KEY (FK_Proveedor) references Proveedor(Rif_proveedor) ON DELETE Cascade,
CONSTRAINT FK_Cliente FOREIGN KEY (FK_Cliente) references Cliente(Rif_cliente) ON DELETE Cascade,
CONSTRAINT FK_Contacto FOREIGN KEY (FK_Contacto) references Persona_contacto(Codigo_persona_contacto) ON DELETE Cascade);

CREATE TABLE  Correo_electronico(
Codigo_correo serial NOT NULL UNIQUE,
Direccion_correo varchar(30) NOT NULL,
Dominio_correo varchar(20) NOT NULL,
FK_Cliente varchar(10),
FK_Proveedor varchar(10),
FK_Contacto integer,
CONSTRAINT PK_Codigo_Correo_Correo_Electronico PRIMARY KEY (Codigo_correo),
CONSTRAINT FK_Cliente_Correo_Electronico FOREIGN KEY (FK_Cliente) references Cliente(Rif_cliente) ON DELETE Cascade,
CONSTRAINT FK_Proveedor_Correo_Electronico FOREIGN KEY (FK_Proveedor) references Proveedor(Rif_proveedor) ON DELETE Cascade,
CONSTRAINT FK_Contacto_Correo_Electronico FOREIGN KEY (FK_Contacto) references Persona_contacto(Codigo_persona_contacto) ON DELETE Cascade);

CREATE TABLE Divisa(
Codigo_divisa serial NOT NULL UNIQUE,
Nombre_divisa varchar(30) NOT NULL,
Valor_divisa numeric(10) NOT NULL,
CONSTRAINT PK_Codigo_divisa_Divisa PRIMARY KEY (Codigo_divisa));

CREATE TABLE Historico_divisa(
Codigo_historico_divisa serial NOT NULL UNIQUE,
Valor_divisa numeric(10) NOT NULL,
Fecha_valor date NOT NULL,
FK_divisa integer NOT NULL,
CONSTRAINT PK_Codigo_Historico_Divisa PRIMARY KEY (Codigo_historico_divisa),
CONSTRAINT FK_Divisa_Historico_divisa FOREIGN KEY (FK_divisa) references Divisa(Codigo_divisa) ON DELETE Cascade);

CREATE TABLE Historico_valor_punto(
	Codigo_valor_punto serial NOT NULL UNIQUE,
	Valor_punto numeric(10) NOT NULL,
	Fecha date NOT NULL,
	CONSTRAINT PK_Codigo_valor_punto PRIMARY KEY(Codigo_valor_punto)
);

CREATE TABLE Metodo_pago(
Codigo_metodo_pago serial NOT NULL UNIQUE,
Denominacion numeric(10),
Banco varchar(30),
Tipo_metodo_pago varchar(20) NOT NULL,
Numero_cheque numeric(20),
Numero_cuenta numeric(20),
Numero_tarjeta_debito varchar(40),
Tipo_tarjeta_credito varchar(20),
Numero_tarjeta_credito varchar(40),
Fecha_vencimiento varchar(30),
Cantidad_canjeada numeric(10),
FK_Divisa integer,
FK_Cliente varchar(10),	
FK_Historico_punto integer,
Valor_moneda numeric(50),
CONSTRAINT PK_Codigo_metodo_pago_Metodo_Pago PRIMARY KEY (Codigo_metodo_pago),
CONSTRAINT FK_Divisa_Metodo_Pago FOREIGN KEY (FK_Divisa) references Divisa(Codigo_divisa) ON DELETE Cascade,
CONSTRAINT FK_Cliente_Metodo_Pago FOREIGN KEY (FK_Cliente) references Cliente(Rif_cliente) ON DELETE Cascade,
CONSTRAINT FK_Historico_punto_Metodo_pago FOREIGN KEY (FK_Historico_punto) references Historico_valor_punto(Codigo_valor_punto) ON DELETE Cascade,
CONSTRAINT check_Tipo_Tarjeta_Credito_Metodo_Pago CHECK(Tipo_tarjeta_credito in ('MasterCard','Visa','American_Express')),
CONSTRAINT check_Tipo_metodo_pago_Metodo_Pago CHECK(Tipo_metodo_pago in ('Efectivo','Cheque','Tarjeta de Crédito','Tarjeta de Débito','Puntos')));

CREATE TABLE Cuota_afiliacion(
Codigo_cuota serial NOT NULL UNIQUE,
Fecha_cuota date NOT NULL,
Monto_cuota numeric(10) NOT NULL,
CONSTRAINT PK_Codigo_Cuota_Cuota_afiliacion PRIMARY KEY (Codigo_cuota));

CREATE TABLE Proveedor_y_Cuota(
Codigo_proveedor_y_cuota serial NOT NULL UNIQUE,
Rif_proveedor varchar(10) NOT NULL,
Codigo_cuota integer NOT NULL,
Estatus varchar(10) NOT NULL,
Fecha_pago date,
FK_Metodo_pago integer,
CONSTRAINT PK_Codigo_proveedor_y_cuota PRIMARY KEY(Codigo_proveedor_y_cuota),
CONSTRAINT FK_Rif_Proveedor_Proveedor_y_Cuota FOREIGN KEY (Rif_proveedor) references Proveedor (Rif_proveedor) ON DELETE Cascade,
CONSTRAINT FK_Metodo_pago_Cuota FOREIGN KEY (FK_Metodo_pago) references Metodo_pago(Codigo_metodo_pago) ON DELETE Cascade,
CONSTRAINT FK_Codigo_cuota_Proveedor_y_Cuota FOREIGN KEY (Codigo_cuota) references Cuota_afiliacion(Codigo_cuota) ON DELETE Cascade);

CREATE TABLE Cargo(
Codigo_cargo serial NOT NULL UNIQUE,
Nombre_cargo varchar(40) NOT NULL,
CONSTRAINT PK_Codigo_cargo_Cargo PRIMARY KEY (Codigo_cargo));

CREATE TABLE Empleado(
Cedula_empleado varchar(10) NOT NULL UNIQUE,
Primer_nombre_empleado varchar(20) NOT NULL,
Segundo_nombre_empleado varchar(20),
Primer_apellido_empleado varchar(20) NOT NULL,
Segundo_apellido_empleado varchar(20),
Fecha_nacimiento date NOT NULL,
Salario numeric(10) NOT NULL,
FK_Cargo integer NOT NULL,
CONSTRAINT PK_Cedula_empleado_Empleado PRIMARY KEY(Cedula_empleado),
CONSTRAINT FK_Cargo_Empleado FOREIGN KEY (FK_Cargo) references Cargo(Codigo_cargo) ON DELETE Cascade);

CREATE TABLE Rol(
Codigo_rol serial NOT NULL UNIQUE,
Nombre_rol varchar(20) NOT NULL,
CONSTRAINT PK_Codigo_rol_Rol PRIMARY KEY (Codigo_rol));

CREATE TABLE Usuario(
Codigo_usuario serial NOT NULL UNIQUE,
Nombre_usuario varchar(40) NOT NULL UNIQUE,
Contraseña varchar(20) NOT NULL,
FK_Rol integer NOT NULL,
FK_Cliente varchar(10),
FK_Proveedor varchar(10),
FK_Empleado varchar(10),
CONSTRAINT PK_Codigo_usuario_Usuario PRIMARY KEY (Codigo_usuario),
CONSTRAINT FK_Rol_Usuario FOREIGN KEY (FK_Rol) references Rol(Codigo_rol) ON DELETE Cascade,
CONSTRAINT FK_Cliente_Usuario FOREIGN KEY (FK_Cliente) references Cliente(Rif_cliente) ON DELETE Cascade,
CONSTRAINT FK_Proveedor_Usuario FOREIGN KEY (FK_Proveedor) references Proveedor(Rif_proveedor) ON DELETE Cascade,
CONSTRAINT FK_Empleado_Usuario FOREIGN KEY (FK_Empleado) references Empleado(Cedula_empleado) ON DELETE Cascade);

CREATE TABLE Privilegio(
Codigo_privilegio serial NOT NULL UNIQUE,
Nombre_privilegio varchar(20) NOT NULL,
CONSTRAINT PK_Codigo_privilegio_Privilegio PRIMARY KEY (Codigo_privilegio));

CREATE TABLE Rol_y_Privilegio(
Codigo_rol_privilegio serial NOT NULL UNIQUE,
FK_Rol integer NOT NULL,
FK_Privilegio integer NOT NULL,
CONSTRAINT PK_Codigo_rol_privilegio PRIMARY KEY (Codigo_rol_privilegio),
CONSTRAINT FK_Rol_Rol_y_Privilegio FOREIGN KEY (FK_Rol) references Rol(Codigo_rol) ON DELETE Cascade,
CONSTRAINT FK_Privilegio_Rol_y_Privilegio FOREIGN KEY (FK_Privilegio) references Privilegio(Codigo_privilegio) ON DELETE Cascade);

CREATE TABLE Beneficio(
Codigo_beneficio serial NOT NULL UNIQUE,
Tipo_beneficio varchar(20) NOT NULL,
Descripcion_beneficio varchar(70) NOT NULL,
FK_Empleado varchar(10) NOT NULL,
CONSTRAINT PK_Codigo_Beneficio_Beneficio PRIMARY KEY (Codigo_beneficio),
CONSTRAINT FK_Empleado_Beneficio FOREIGN KEY (FK_Empleado) references Empleado(Cedula_empleado) ON DELETE Cascade);

CREATE TABLE Vacacion(
Codigo_vacacion serial NOT NULL UNIQUE,
Fecha_inicio_vacacion date NOT NULL,
Fecha_fin_vacacion date NOT NULL,
FK_Empleado varchar(10) NOT NULL,
CONSTRAINT PK_Codigo_Vacacion_Vacacion PRIMARY KEY (Codigo_vacacion),
CONSTRAINT FK_Empleado_Vacacion FOREIGN KEY (FK_Empleado) references Empleado(Cedula_empleado) ON DELETE Cascade);

CREATE TABLE Asistencia(
Codigo_asistencia serial NOT NULL UNIQUE,
Fecha_asistencia date,
Hora_entrada_asistencia time,
Hora_salida_asistencia time,
FK_Empleado varchar(10) NOT NULL,
CONSTRAINT PK_Codigo_asistencia_Asistencia PRIMARY KEY (Codigo_asistencia),
CONSTRAINT FK_Empleado_Asistencia FOREIGN KEY (FK_Empleado) references Empleado(Cedula_empleado) ON DELETE Cascade);

CREATE TABLE Horario(
Codigo_horario serial NOT NULL UNIQUE,
Dia varchar(10) NOT NULL,
Hora_entrada varchar(20) NOT NULL,
Hora_salida varchar(20) NOT NULL,
CONSTRAINT PK_Codigo_horario_Horario PRIMARY KEY (Codigo_horario));

CREATE TABLE Horario_y_Empleado(
Codigo_horario integer NOT NULL,
Cedula_empleado varchar(10) NOT NULL,
Codigo_horario_y_empleado serial NOT NULL UNIQUE,
CONSTRAINT PK_Codigo_horario_Horario_y_Empleado PRIMARY KEY (Codigo_horario_y_empleado),
CONSTRAINT FK_Codigo_horario_Horario_y_Empleado FOREIGN KEY (Codigo_horario) references Horario(Codigo_horario) ON DELETE Cascade,
CONSTRAINT FK_Cedula_empleado_Horario_y_Empleado FOREIGN KEY (Cedula_empleado) references Empleado(Cedula_empleado) ON DELETE Cascade);

CREATE TABLE Tipo_de_cerveza(
Codigo_tipo_cerveza serial NOT NULL UNIQUE,
Nombre_tipo_cerveza varchar(50) NOT NULL,
Historia text NOT NULL,
FK_Tipo_de_cerveza integer,
CONSTRAINT PK_Codigo_tipo_cerveza_Tipo_de_Cerveza PRIMARY KEY (Codigo_tipo_cerveza),
CONSTRAINT FK_Tipo_de_cerveza_Tipo_de_cerveza FOREIGN KEY (FK_Tipo_de_cerveza) references Tipo_de_cerveza(Codigo_tipo_cerveza) ON DELETE Cascade);

CREATE TABLE Cerveza(
Codigo_cerveza serial NOT NULL UNIQUE,
Nombre_cerveza varchar(50) NOT NULL,
FK_Tipo_de_cerveza integer NOT NULL,
FK_Proveedor varchar(20) NOT NULL,
Imagen_cerveza varchar(30) NOT NULL,
Precio numeric(10) NOT NULL,
CONSTRAINT PK_Codigo_Cerveza_Cerveza PRIMARY KEY (Codigo_cerveza),
CONSTRAINT FK_Tipo_de_cerveza_Cerveza FOREIGN KEY (FK_Tipo_de_cerveza) references Tipo_de_cerveza(Codigo_tipo_cerveza) ON DELETE Cascade,
CONSTRAINT FK_Proveedor_Cerveza FOREIGN KEY (FK_Proveedor) references Proveedor(Rif_proveedor) ON DELETE Cascade);

CREATE TABLE Oferta(
Codigo_oferta serial NOT NULL UNIQUE,
Fecha_inicio_oferta date NOT NULL,
Fecha_fin_oferta date NOT NULL,
Porcentaje numeric(10) NOT NULL,
FK_Empleado varchar(10) NOT NULL,
FK_Cerveza integer NOT NULL,
CONSTRAINT PK_Codigo_oferta_Oferta PRIMARY KEY (Codigo_oferta),
CONSTRAINT FK_Empleado_Oferta FOREIGN KEY (FK_Empleado) references Empleado(Cedula_empleado) ON DELETE Cascade,
CONSTRAINT FK_Cerveza_Oferta FOREIGN KEY (FK_Cerveza) references Cerveza(Codigo_cerveza) ON DELETE Cascade);

CREATE TABLE Oferta_y_cerveza(
Codigo_oferta_y_cerveza serial NOT NULL UNIQUE,
FK_Oferta integer NOT NULL,
FK_Cerveza integer NOT NULL,
CONSTRAINT PK_Codigo_Oferta_y_Cerveza PRIMARY KEY (Codigo_oferta_y_cerveza),
CONSTRAINT FK_Oferta_Oferta_y_Cerveza FOREIGN KEY (FK_Oferta) references Oferta(Codigo_oferta) ON DELETE Cascade,
CONSTRAINT FK_Cerveza_Oferta_y_Cerveza FOREIGN KEY (FK_Cerveza) references Cerveza(Codigo_cerveza) ON DELETE Cascade);

CREATE TABLE Caracteristica(
Codigo_caracteristica serial NOT NULL UNIQUE,
Nombre_caracteristica varchar(100) NOT NULL,
CONSTRAINT PK_Codigo_caracteristica_Caracteristica PRIMARY KEY (Codigo_caracteristica));

CREATE TABLE Caracteristica_y_Tipo_de_Cerveza(
Codigo_caracteristica_tcer serial NOT NULL UNIQUE,
Descripcion_caracteristica text,
Valor_Caracteristica numeric(10),
Unidad_valor varchar(10),
Codigo_tipo_cerveza integer NOT NULL,
Codigo_caracteristica integer NOT NULL,
CONSTRAINT PK_Codigo_caracteristica_tcer_Caracteristica_y_Tipo_de_Cerveza PRIMARY KEY(Codigo_caracteristica_tcer),
CONSTRAINT FK_Codigo_tipo_cerveza_Caracteristica_y_Tipo_de_Cerveza FOREIGN KEY (Codigo_tipo_cerveza) references Tipo_de_cerveza(Codigo_tipo_cerveza) ON DELETE Cascade,
CONSTRAINT FK_Codigo_cerveza_Caracteristica_y_Tipo_de_Cerveza FOREIGN KEY (Codigo_caracteristica) references Caracteristica(Codigo_caracteristica) ON DELETE Cascade);

CREATE TABLE Comentario(
Codigo_comentario serial NOT NULL UNIQUE,
Descripcion_comentario text NOT NULL,
FK_Tipo_de_cerveza integer,
CONSTRAINT PK_Codigo_comentario_Comentario PRIMARY KEY(Codigo_comentario),
CONSTRAINT FK_Tipo_de_cerveza_Comentario FOREIGN KEY (FK_Tipo_de_cerveza) references Tipo_de_cerveza(Codigo_tipo_cerveza) ON DELETE Cascade);

CREATE TABLE Ingrediente(
Codigo_ingrediente serial NOT NULL UNIQUE,
Nombre_ingrediente varchar(50) NOT NULL,
Descripcion_ingrediente text NOT NULL,
CONSTRAINT PK_Codigo_ingrediente_Ingrediente PRIMARY KEY (Codigo_ingrediente));

CREATE TABLE Receta(
Codigo_receta serial NOT NULL UNIQUE,
Cantidad_ingrediente numeric(20) NOT NULL,
Descripcion_receta varchar(50) ,
Unidad_ingrediente varchar(50),
Codigo_cerveza integer NOT NULL,
Codigo_ingrediente integer NOT NULL,
CONSTRAINT PK_Codigo_receta_Receta PRIMARY KEY (Codigo_receta, Codigo_cerveza, Codigo_ingrediente),
CONSTRAINT FK_Codigo_cerveza_Receta FOREIGN KEY (Codigo_cerveza) references Cerveza(Codigo_cerveza) ON DELETE Cascade,
CONSTRAINT FK_Codigo_ingrediente_Receta FOREIGN KEY (Codigo_ingrediente) references Ingrediente(Codigo_ingrediente) ON DELETE Cascade);

CREATE TABLE Estatus(
	Codigo_estatus serial NOT NULL UNIQUE,
	Nombre_estatus varchar(40) NOT NULL,
	CONSTRAINT PK_Codigo_estatus_Estatus PRIMARY KEY (Codigo_estatus),
	CONSTRAINT check_Nombre_estatus_Estatus CHECK(Nombre_estatus in ('Pendiente','Listo para la entrega','Entregado'))
);

CREATE TABLE Tienda_web(
	Codigo_tienda numeric(10) NOT NULL UNIQUE,
	Nombre_tienda varchar(20) NOT NULL,
	CONSTRAINT PK_Codigo_tienda_Tienda_web PRIMARY KEY (Codigo_tienda)
);

CREATE TABLE Tienda_fisica(
	Codigo_tienda numeric(10) NOT NULL UNIQUE,
	Nombre_tienda varchar(20) NOT NULL,
	FK_Lugar integer NOT NULL,
	CONSTRAINT PK_Codigo_tienda_Tienda_fisica PRIMARY KEY (Codigo_tienda),
	CONSTRAINT FK_Lugar_Tienda_fisica FOREIGN KEY (FK_Lugar) references Lugar(Codigo_lugar) ON DELETE Cascade
);

CREATE TABLE Venta (
	Numero_factura serial NOT NULL UNIQUE,
	Fecha_venta date NOT NULL,
	Monto_total_venta numeric(10) NOT NULL,
	FK_Empleado_1 varchar(10),
	FK_Empleado_2 varchar(10),
	FK_Cliente varchar(10) NOT NULL,
	FK_Metodo_pago integer NOT NULL,
	FK_Tienda_web numeric(10),
	FK_Tienda_fisica numeric(10),
	CONSTRAINT PK_Numero_factura_Venta PRIMARY KEY (Numero_factura),
	CONSTRAINT FK_Empleado_1_Venta FOREIGN KEY (FK_Empleado_1) references Empleado(Cedula_empleado) ON DELETE Cascade,
	CONSTRAINT FK_Empleado_2_Venta FOREIGN KEY (FK_Empleado_2) references Empleado(Cedula_empleado) ON DELETE Cascade,
	CONSTRAINT FK_Cliente_Venta FOREIGN KEY (FK_Cliente) references Cliente(Rif_cliente) ON DELETE Cascade,
	CONSTRAINT FK_Metodo_pago_Venta FOREIGN KEY (FK_Metodo_pago) references Metodo_pago(Codigo_metodo_pago) ON DELETE Cascade,
	CONSTRAINT FK_Tienda_fisica_Venta FOREIGN KEY (FK_Tienda_fisica) references Tienda_fisica(Codigo_tienda) ON DELETE Cascade,
	CONSTRAINT FK_Tienda_web_Venta FOREIGN KEY (FK_Tienda_web) references Tienda_web(Codigo_tienda) ON DELETE Cascade
);

CREATE TABLE Estatus_y_venta(
	Codigo_estatus_y_venta serial NOT NULL UNIQUE,
	Estatus integer NOT NULL,
	Venta integer NOT NULL,
	Fecha_estatus date NOT NULL,
	CONSTRAINT PK_Estatus_Estatus_y_venta PRIMARY KEY (Codigo_estatus_y_venta),
	CONSTRAINT FK_Estatus_Estatus_y_venta FOREIGN KEY (Estatus) references Estatus(Codigo_estatus) ON DELETE Cascade,
	CONSTRAINT FK_Venta_Estatus_y_venta FOREIGN KEY (Venta) references Venta(Numero_factura) ON DELETE Cascade	
);

CREATE TABLE Orden_compra(
	Codigo_orden_compra serial NOT NULL UNIQUE,
	Fecha_orden_compra date NOT NULL,
	Monto_total_orden_compra numeric(10) NOT NULL,
	FK_Empleado varchar(10),
	FK_Proveedor varchar(10) NOT NULL,
	CONSTRAINT PK_Codigo_orden_compra_Orden_compra PRIMARY KEY (Codigo_orden_compra),
	CONSTRAINT FK_Empleado_Orden_compra FOREIGN KEY (FK_Empleado) references Empleado(Cedula_empleado) ON DELETE Cascade,
	CONSTRAINT FK_Proveedor_Orden_compra FOREIGN KEY (FK_Proveedor) references Proveedor(Rif_proveedor) ON DELETE Cascade	
);

CREATE TABLE Estatus_y_orden(
	Codigo_estatus serial NOT NULL UNIQUE,
	Estatus integer NOT NULL,
	Orden integer NOT NULL,
	Fecha_estatus date NOT NULL,
	CONSTRAINT PK_Estatus_Estatus_y_orden PRIMARY KEY (Codigo_estatus),
	CONSTRAINT FK_Estatus_Estatus_y_orden FOREIGN KEY (Estatus) references Estatus(Codigo_estatus) ON DELETE Cascade,
	CONSTRAINT FK_Orden_Estatus_y_orden FOREIGN KEY (Orden) references Orden_compra(Codigo_orden_compra) ON DELETE Cascade	
);

CREATE TABLE Evento(
	Codigo_evento serial NOT NULL UNIQUE,
	Fecha_inicio_evento date NOT NULL,
	Fecha_fin_evento date NOT NULL,
	Hora_inicio_evento time NOT NULL,
	Hora_fin_evento time NOT NULL,
	Nombre_evento varchar(30) NOT NULL,
	Descripcion_evento varchar(70) NOT NULL,
	Direccion_evento varchar(50),
	Precio_entrada numeric(10),
	Cantidad_entradas numeric(10),
	FK_Lugar integer NOT NULL,
	CONSTRAINT PK_Codigo_evento_Evento PRIMARY KEY (Codigo_evento),
	CONSTRAINT FK_Lugar_Evento FOREIGN KEY (FK_Lugar) references Lugar(Codigo_lugar) ON DELETE CASCADE	
);

CREATE TABLE Evento_y_proveedor(
	Codigo_evento_proveedor serial NOT NULL UNIQUE,
	FK_Evento integer NOT NULL,
	FK_Proveedor varchar(10) NOT NULL,
	Total numeric(10),
	CONSTRAINT PK_Codigo_evento_y_proveedor PRIMARY KEY (Codigo_evento_proveedor),
	CONSTRAINT FK_Evento_Evento_y_proveedor FOREIGN KEY (FK_Evento) references Evento(Codigo_evento) ON DELETE CASCADE,
	CONSTRAINT FK_Proveedor_Evento_y_proveedor FOREIGN KEY (FK_Proveedor) references Proveedor(Rif_proveedor) ON DELETE CASCADE
);

CREATE TABLE Venta_entrada(
	Codigo_venta_entrada serial NOT NULL UNIQUE,
	Precio_entrada numeric(10),
	Fecha_venta_entrada date,
	FK_Evento integer NOT NULL,
	FK_Cliente varchar(10) NOT NULL,
	CONSTRAINT PK_Codigo_venta_entrada_Venta_entrada PRIMARY KEY (Codigo_venta_entrada),
	CONSTRAINT FK_Evento_Venta_entrada FOREIGN KEY (FK_Evento) references Evento(Codigo_evento) ON DELETE Cascade,
	CONSTRAINT FK_Cliente_Venta_entrada FOREIGN KEY (FK_Cliente) references Cliente(Rif_cliente) ON DELETE Cascade
);

CREATE TABLE Venta_evento(
	Numero_factura_evento serial NOT NULL UNIQUE,
	Fecha_venta_evento date NOT NULL,
	Monto_total_evento numeric(10) NOT NULL,
	FK_Cliente varchar(10) NOT NULL,
	FK_Evento integer NOT NULL,
	CONSTRAINT PK_Numero_factura_evento_Venta_evento PRIMARY KEY (Numero_factura_evento),
	CONSTRAINT FK_Cliente_Venta_evento FOREIGN KEY (FK_Cliente) references Cliente(Rif_cliente) ON DELETE Cascade,
	CONSTRAINT FK_Evento_Venta_evento FOREIGN KEY (FK_Evento) references Evento(Codigo_evento) ON DELETE Cascade
);

CREATE TABLE Pasillo(
	Codigo_pasillo serial NOT NULL UNIQUE,
	Nombre_pasillo varchar(20) NOT NULL,
	FK_Tienda_fisica numeric(10) NOT NULL,
	CONSTRAINT PK_Codigo_pasillo_Pasillo PRIMARY KEY (Codigo_pasillo),
	CONSTRAINT FK_Tienda_fisica_Pasillo FOREIGN KEY (FK_Tienda_fisica) references Tienda_fisica(Codigo_tienda) ON DELETE Cascade
);

CREATE TABLE Anaquel(
	Codigo_anaquel serial NOT NULL UNIQUE,
	Zona_anaquel varchar(20) NOT NULL,
	FK_Pasillo integer NOT NULL,
	CONSTRAINT PK_Codigo_anaquel_Anaquel PRIMARY KEY (Codigo_anaquel),
	CONSTRAINT FK_Pasillo_Anaquel FOREIGN KEY (FK_Pasillo) references Pasillo(Codigo_pasillo) ON DELETE Cascade
);

CREATE TABLE Detalle_compra(
	Codigo_detalle_compra serial NOT NULL UNIQUE,
	Cantidad_compra numeric(10) NOT NULL,
	Precio_unitario_compra numeric(10) NOT NULL,
	Cerveza integer NOT NULL,
	Orden_compra integer NOT NULL,
	CONSTRAINT PK_Codigo_detalle_compra_Detalle_compra PRIMARY KEY (Codigo_detalle_compra),
	CONSTRAINT FK_Cerveza_Detalle_compra FOREIGN KEY (Cerveza) references Cerveza(Codigo_cerveza) ON DELETE Cascade,
	CONSTRAINT FK_Orden_compra_Detalle_compra FOREIGN KEY (Orden_compra) references Orden_compra(Codigo_orden_compra) ON DELETE Cascade
);

CREATE TABLE Detalle_venta(
	Codigo_detalle_venta serial NOT NULL UNIQUE,
	Cantidad_venta numeric(10) NOT NULL,
	Precio_unitario_venta numeric(10) NOT NULL,
	Cerveza integer NOT NULL,
	Venta integer NOT NULL,
	CONSTRAINT PK_Codigo_detalle_venta_Detalle_venta PRIMARY KEY (Codigo_detalle_venta),
	CONSTRAINT FK_Cerveza_Detalle_venta FOREIGN KEY (Cerveza) references Cerveza(Codigo_cerveza) ON DELETE Cascade,
	CONSTRAINT FK_Venta_Detalle_venta FOREIGN KEY (Venta) references Venta(Numero_factura) ON DELETE Cascade
);

CREATE TABLE Detalle_venta_evento(
	Codigo_detalle_venta_evento serial NOT NULL UNIQUE,
	Cantidad_venta_evento numeric(10) NOT NULL,
	Precio_unitario_venta_evento numeric(10) NOT NULL,
	Cerveza integer NOT NULL,
	Venta_evento integer NOT NULL,
	CONSTRAINT PK_Codigo_detalle_venta_evento_Detalle_venta_evento PRIMARY KEY (Codigo_detalle_venta_evento),
	CONSTRAINT FK_Cerveza_Detalle_venta_evento FOREIGN KEY (Cerveza) references Cerveza(Codigo_cerveza) ON DELETE Cascade,
	CONSTRAINT FK_Venta_evento_1_Detalle_venta_evento FOREIGN KEY (Venta_evento) references Venta_evento(Numero_factura_evento) ON DELETE Cascade
);

CREATE TABLE Presupuesto(
	Codigo_presupuesto serial NOT NULL UNIQUE,
	Fecha_presupuesto date NOT NULL,
	Monto_total_presupuesto numeric(10) NOT NULL,
	FK_Cliente varchar(10) NOT NULL,
	CONSTRAINT PK_Codigo_presupuesto_Presupuesto PRIMARY KEY (Codigo_presupuesto),
	CONSTRAINT FK_Cliente_Presupuesto FOREIGN KEY(FK_Cliente) references Cliente(Rif_cliente) ON DELETE Cascade
);

CREATE TABLE Detalle_presupuesto(
	Codigo_detalle_presupuesto serial NOT NULL UNIQUE,
	Cantidad_presupuesto numeric(10) NOT NULL,
	Precio_unitario_presupuesto numeric(10) NOT NULL,
	FK_Presupuesto integer NOT NULL,
	FK_Cerveza integer NOT NULL,
	CONSTRAINT PK_Codigo_detalle_presupuesto PRIMARY KEY (Codigo_detalle_presupuesto),
	CONSTRAINT FK_Detalle_presupuesto_Presupuesto FOREIGN KEY(FK_Presupuesto) references Presupuesto(Codigo_presupuesto) ON DELETE Cascade,
	CONSTRAINT FK_Cerveza_Presupuesto FOREIGN KEY(FK_Cerveza) references Cerveza(Codigo_cerveza) ON DELETE Cascade
);

CREATE TABLE Inventario_evento(
	Codigo_inventario_evento serial NOT NULL UNIQUE,
	Cantidad_operacion numeric(10) NOT NULL,
	Cantidad_disponible numeric(10) NOT NULL,
	Fecha_operacion date NOT NULL,
	FK_Cerveza integer NOT NULL,
	FK_Venta_evento integer,
	CONSTRAINT PK_Codigo_inventario_evento PRIMARY KEY (Codigo_inventario_evento),
	CONSTRAINT FK_Cerveza_inventario_evento FOREIGN KEY(FK_Cerveza) references Cerveza(Codigo_cerveza) ON DELETE Cascade,
	CONSTRAINT FK_Venta_inventario_evento FOREIGN KEY(FK_Venta_evento) references Detalle_venta_evento(Codigo_detalle_venta_evento) ON DELETE Cascade
);

CREATE TABLE Inventario(
	Codigo_inventario serial NOT NULL UNIQUE,
	Cantidad_operacion numeric(10) NOT NULL,
	Cantidad_disponible numeric(10) NOT NULL,
	Fecha_operacion date NOT NULL,
	FK_Cerveza integer NOT NULL,
	FK_Venta integer,
	Fk_Orden integer,
	FK_Evento integer,
	CONSTRAINT PK_Codigo_inventario PRIMARY KEY (Codigo_inventario),
	CONSTRAINT FK_Cerveza_inventario FOREIGN KEY(FK_Cerveza) references Cerveza(Codigo_cerveza) ON DELETE Cascade,
	CONSTRAINT FK_Venta_inventario FOREIGN KEY(FK_Venta) references Detalle_venta(Codigo_detalle_venta) ON DELETE Cascade,
	CONSTRAINT FK_Orden_inventario FOREIGN KEY(FK_Orden) references Detalle_compra(Codigo_detalle_compra) ON DELETE Cascade,
	CONSTRAINT FK_Evento_inventario FOREIGN KEY(FK_Evento) references Inventario_evento(Codigo_inventario_evento) ON DELETE Cascade
);


CREATE TABLE Carrito(
	Codigo_carrito serial NOT NULL UNIQUE,
	Cantidad numeric(10) NOT NULL,
	Precio_unitario	numeric(10) NOT NULL,
	FK_Cliente varchar(10) NOT NULL, 
	FK_Cerveza integer NOT NULL,
	CONSTRAINT PK_Codigo_carrito PRIMARY KEY (Codigo_carrito),
	CONSTRAINT FK_Carrito_Cliente FOREIGN KEY (FK_Cliente) references Cliente(Rif_cliente) ON DELETE Cascade,
	CONSTRAINT FK_Carrito_Cerveza FOREIGN KEY (FK_Cerveza) references Cerveza(Codigo_cerveza) ON DELETE Cascade
);