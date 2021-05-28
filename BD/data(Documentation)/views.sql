/*
CREATE VIEW view_name as
  SELECT BODY

 SELECT * FROM view_name;

CREATE VIEW view_name as
  SELECT BODY

  FROM other_View
  WHERE;


*/

    -- view for SELECT rol_group
CREATE OR REPLACE VIEW v_rol_group AS
    SELECT r.id_rol, g.nombre, g.monto_min, g.monto_max, g.generar_cheque, g.validar_cheque
    FROM rol AS r
    JOIN  grupo AS g
    on r.id_group = g.id_group
    ORDER BY id_rol;
-- SELECT * FROM v_rol_group;

    -- view for SELECT show sup users
CREATE OR REPLACE VIEW v_rol_user AS
    SELECT r.id_rol,
           p.nombre,
           p.crud_users,
           p.imprimir_cheque,
           p.anular_cheque,
           p.modificar_cheque,
           p.reporte_cheque,
           p.auditar_user,
           p.admin_cuenta_banc,
           p.auditar_cuenta,
           p.mostrar_bitacora_user,
           p.mostrar_bitacora_group,
           p.mostrar_bitacora_jefe,
           p.jefe
    FROM rol AS r
    JOIN  permiso_sup AS p
    on r.id_permiso_sup = p.id_permiso_sup
    ORDER BY id_rol;
-- SELECT * FROM v_rol_user;

    -- view for SELECT rol_group
CREATE OR REPLACE VIEW v_all_rol AS
    SELECT 
    id_rol,
    nombre as nombre_rol
    FROM v_rol_group
    UNION 
    SELECT 
    id_rol,
    nombre as nombre_rol
    FROM v_rol_user
    ORDER BY id_rol
    ;
-- SELECT * FROM v_all_rol;



    -- view for SELECT contactos no atendidos
CREATE OR REPLACE VIEW v_contactanos_no AS
    SELECT c.nombre, c.num_telefono, c.correo, c.mensaje
    FROM contactanos AS c
    WHERE c.estado = 0
    ORDER BY nombre
    ;
-- SELECT * FROM v_contactanos_no;

-- view for SELECT contactos si atendidos
CREATE OR REPLACE VIEW v_contactanos_si AS
    SELECT c.nombre, c.num_telefono, c.correo, c.mensaje, u.nombre as user_name, u.apellido, u.id_user
    FROM contactanos AS c
    JOIN  usuario AS u
    on u.id_user = c.id_user
    where c.estado = 1
    ORDER BY id_user
    ;

-- SELECT * FROM v_contactanos_si;

-- view for SELECT usuarios de grupo
CREATE OR REPLACE VIEW v_users_rol_group AS
    SELECT
        u.id_user,
        u.nombre,
        u.apellido,
        u.DPI,
        u.direccion,
        u.id_rol,
        u.clave,
        g.nombre as nombre_grupo,
        cu.correo,
        tfu.numero,
        tfu.compania
    FROM
        usuario AS u
    JOIN rol AS r
    ON u.id_rol = r.id_rol
    JOIN grupo AS g
    ON r.id_group = g.id_group
    JOIN correo_user AS cu
    ON u.id_user = cu.id_user
    JOIN telefono_user AS tfu
    ON u.id_user = tfu.id_user
    ORDER BY id_user
    ;
-- SELECT * FROM v_users_rol_group;

-- view for SELECT usuarios con permiso sup
CREATE OR REPLACE VIEW v_users_rol_sup AS
    SELECT
        u.id_user,
        u.nombre,
        u.apellido,
        u.DPI,
        u.direccion,
        u.id_rol,
        u.clave,
        ps.nombre as nombre_sup_user,
        cu.correo,
        tfu.numero,
        tfu.compania
    FROM
        usuario AS u
    JOIN rol AS r
    ON u.id_rol = r.id_rol
    JOIN permiso_sup AS ps
    ON r.id_permiso_sup = ps.id_permiso_sup
    JOIN correo_user AS cu
    ON u.id_user = cu.id_user
    JOIN telefono_user AS tfu
    ON u.id_user = tfu.id_user
    ORDER BY id_user
    ;
-- SELECT * FROM v_users_rol_sup;


-- view for SELECT all users
CREATE OR REPLACE VIEW v_all_users
 AS
    SELECT
        id_user,
        nombre,
        apellido,
        DPI,
        direccion,
        id_rol,
        clave,
        nombre_sup_user as nombre_rol,
        correo,
        numero,
        compania
    FROM
        v_users_rol_sup AS v_r_sup
    UNION
    SELECT
        id_user,
        nombre,
        apellido,
        DPI,
        direccion,
        id_rol,
        clave,
        nombre_grupo as nombre_rol,
        correo,
        numero,
        compania
    FROM
        v_users_rol_group AS v_r_grp
    ORDER BY id_user
    ;  
    
-- SELECT * FROM v_all_users;

-- D R O P P I N G
DROP VIEW IF EXISTS v_rol_group;
DROP VIEW IF EXISTS v_rol_user;

DROP VIEW IF EXISTS v_contactanos_no;
DROP VIEW IF EXISTS v_contactanos_si;

DROP VIEW IF EXISTS v_users_rol_group;
DROP VIEW IF EXISTS v_users_rol_sup;
DROP VIEW IF EXISTS v_all_users;