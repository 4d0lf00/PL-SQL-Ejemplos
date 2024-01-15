DECLARE
--Creacion de variables
    v_impuesto         NUMBER;
    v_descuentos_linea NUMBER;
    v_delivery         NUMBER;
    v_monto_descuento  NUMBER;
    v_total_ventas     NUMBER;
    v_mensaje_error    VARCHAR2(200);
    v_num_ventas       NUMBER;
    v_monto_ventas     NUMBER;

--Creacion de cursos de linea es la principal(El McDonald)
    CURSOR cur_nombre_linea IS
    SELECT
        nom_linea
    FROM
        linea
    ORDER BY
        nom_linea;


--Creacion de cursos(EXPLICAR COMO FUNCIONA!!)
    CURSOR cur_linea_ventas (
        p_nombre_linea VARCHAR
    ) IS
    SELECT
        v.fec_venta                 fecha_venta,
        COUNT(*)                    total_ventas,
        --El monto de ventas se calcula el precio X la cantidad
        SUM(p.precio * dv.cantidad) monto_ventas
    FROM
             venta v
        INNER JOIN detalle_venta dv ON v.id_venta = dv.id_venta
        INNER JOIN producto      p ON p.id_producto = dv.id_producto
        INNER JOIN linea         l ON p.id_linea = l.id_linea
    WHERE
            to_char(v.fec_venta, 'MMYYYY') = 052021
        AND l.nom_linea = p_nombre_linea
    GROUP BY
        v.fec_venta;
        
--Se crean los varray de impuestos y delivery
    TYPE tipo_varray IS
        VARRAY(5) OF NUMBER;
    varray_venta       tipo_varray;
    
    TYPE tipo_varray_delivery IS
        VARRAY(1) OF NUMBER;
    varray_delivery    tipo_varray_delivery;
BEGIN
--Se definen los valores del varray de impuesto
    varray_venta := tipo_varray(0.19, 0.17, 0.15, 0.13, 0.11);

--Se define varray de delivery
    varray_delivery := tipo_varray_delivery(1500);
    
    EXECUTE IMMEDIATE ('DROP SEQUENCE SEQ_ERROR');
    EXECUTE IMMEDIATE ('CREATE SEQUENCE SEQ_ERROR');
    EXECUTE IMMEDIATE ( 'TRUNCATE TABLE ERROR_PROCESO' );
    EXECUTE IMMEDIATE ( 'TRUNCATE TABLE RESUMEN_LINEA' );

--Creacion primer FOR
    FOR reg_linea IN cur_nombre_linea LOOP
        v_impuesto := 0;
        v_descuentos_linea := 0;
        v_delivery := 0;
        v_monto_descuento := 0;
        v_total_ventas := 0;
        v_num_ventas := 0;
        v_monto_ventas := 0;
    
    --Creacion segundo FOR
        FOR reg_ventas IN cur_linea_ventas(reg_linea.nom_linea) LOOP
        
        --Creacion variable total ventas
        v_num_ventas := v_total_ventas+reg_ventas.total_ventas;
        
        --Creacion variable monto de ventas
        v_monto_ventas := v_monto_ventas+reg_ventas.monto_ventas;
        --Creacion de impuestos
            BEGIN
                SELECT
                    pctimpuesto / 100
                INTO v_impuesto
                FROM
                    impuesto
                WHERE
                    reg_ventas.monto_ventas BETWEEN mto_venta_inf AND mto_venta_sup;
    
    --Creacion de las excepciones
            EXCEPTION
                WHEN no_data_found THEN
                    v_mensaje_error := sqlerrm;
                    INSERT INTO error_proceso VALUES (
                        seq_error.NEXTVAL,
                        v_mensaje_error,
                        'mensahe '
                    );

                WHEN too_many_rows THEN
                    v_mensaje_error := sqlerrm;
                    INSERT INTO error_proceso VALUES (
                        seq_error.NEXTVAL,
                        v_mensaje_error,
                        'mensahe'
                    );

            END;
    
    --Creacion descuentos en linea
            v_descuentos_linea :=
                CASE reg_linea.nom_linea
                    WHEN 'Reserva Especial' THEN
                        round((reg_ventas.monto_ventas * varray_venta(1)))
                    WHEN 'Reserva' THEN
                        round((reg_ventas.monto_ventas * varray_venta(2)))
                    WHEN 'Gran Reserva' THEN
                        round((reg_ventas.monto_ventas * varray_venta(3)))
                    WHEN 'Seleccion' THEN
                        round((reg_ventas.monto_ventas * varray_venta(4)))
                    ELSE round((reg_ventas.monto_ventas * varray_venta(5)))
                END;
        
    
                
    --Creacion del monto delivery
            v_delivery := reg_ventas.total_ventas * varray_delivery(1);
    
    --Creacion de monto descuento
            v_monto_descuento := v_impuesto + v_descuentos_linea + v_delivery;
    
    --Creacion total de ventas
            v_total_ventas := reg_ventas.monto_ventas - v_monto_descuento;
        END LOOP;
        INSERT INTO resumen_linea VALUES (
        reg_linea.nom_linea,
        v_num_ventas,
        v_monto_ventas,
        v_impuesto,
        v_descuentos_linea,
        v_delivery,
        v_monto_descuento,
        v_total_ventas
        );
    END LOOP;

END;