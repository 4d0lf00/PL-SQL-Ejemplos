DECLARE
--Cursor empleado
    CURSOR cur_suc IS
    SELECT
        id_suc
    FROM
        sucursal;

    CURSOR cur_emp (p_id number)IS
    SELECT
        runempleado,
        nombreemp,
        sueldobase,
        round(months_between(
            sysdate, fecha_ing
        ) / 12)     anios
    FROM
        empleado
    where id_suc = p_id;

v_total_emp number:=0;
v_total_suc number:=0;
v_emp_sucursal number:=0;

BEGIN
for reg_suc in cur_suc loop
    FOR reg_emp IN cur_emp(reg_suc.id_suc) LOOP
        dbms_output.put_line('RUN: ' || reg_emp.runempleado);
        dbms_output.put_line('Nombre: ' || reg_emp.nombreemp);
        dbms_output.put_line('Sueldo: '
                             || to_char(
                                       reg_emp.sueldobase,
                                       'FML9G999G999'
                                ));
        dbms_output.put_line('Años de servicio: '
                             || reg_emp.anios
                             || ' '||'años');
        dbms_output.put_line(' ');
        v_total_emp := v_total_emp+1;
    END LOOP;
    v_total_suc := v_total_suc+1;
end loop;
DBMS_OUTPUT.PUT_LINE('Total empleados: '||v_total_emp);
DBMS_OUTPUT.PUT_LINE('Total sucursal: '||v_total_suc);
END;