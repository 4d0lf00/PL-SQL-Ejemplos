--caso 1
-- id empleado, nombre y sueldo
var b_id_emp number;
var b_porcentaje number;
exec :b_id_emp:='&ingrese';
exec :b_porcentaje:='&a';

DECLARE
    v_nombre_emp         VARCHAR2(50);
    v_sueldo_emp         NUMBER(10);
    v_nuevo_sueldo       NUMBER(20);
    v_sueldo_actualizado NUMBER(20);
    v_sum_sueldo         NUMBER;
    v_sum_actualizada    NUMBER;
BEGIN
    SELECT
        nombres
        || ' '
        || apellidos,
        sueldo
    INTO
        v_nombre_emp,
        v_sueldo_emp
    FROM
        empleado
    WHERE
        id_empleado = :b_id_emp;

    dbms_output.put_line('ID empleado: ' || :b_id_emp);
    dbms_output.put_line('Nombre empleado: ' || v_nombre_emp);
    dbms_output.put_line('Sueldo empleado: ' || to_char(
                                                       v_sueldo_emp,
                                                       'FML9G999G999'
                                                ));
    SELECT
        sueldo * ( :b_porcentaje / 100 )
    INTO v_nuevo_sueldo
    FROM
        empleado
    WHERE
        id_empleado = :b_id_emp;

    dbms_output.put_line('porcentaje: ' || v_nuevo_sueldo);
    SELECT
        sueldo + v_nuevo_sueldo
    INTO v_sueldo_actualizado
    FROM
        empleado
    WHERE
        id_empleado = :b_id_emp;

    dbms_output.put_line('nuevo sueldo: ' || to_char(
                                                    v_sueldo_actualizado,
                                                    'fml9g999g999'
                                             ));
    
    --Caso 3

    SELECT
        SUM(sueldo)
    INTO v_sum_sueldo
    FROM
        empleado;

    dbms_output.put_line('Suma de los sueldo: ' || to_char(
                                                          v_sum_sueldo,
                                                          'FML9G999G999'
                                                   ));
    SELECT
        v_sum_sueldo * ( :b_porcentaje / 100 )
    INTO v_sum_actualizada
    FROM
        empleado;

    dbms_output.put_line('Sueldo mas porcentaje: ' || to_char(
                                                             v_sum_actualizada,
                                                             'FML9G99G999'
                                                      ));
END;