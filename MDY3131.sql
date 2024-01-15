VAR b_id_emp NUMBER
EXEC :b_id_emp:='&ingrese'
DECLARE
v_nombre_emp VARCHAR2(40);
v_salario NUMBER(10);
v_nombre_depto VARCHAR2(30);
BEGIN
  SELECT e.nombre_emp || ' ' || e.appaterno_emp, e.sueldo_emp , d.desc_categoria_emp
    INTO v_nombre_emp, v_salario, v_nombre_depto
    FROM empleado e JOIN categoria_empleado d
     ON d.id_categoria_emp = e.id_categoria_emp
  WHERE e.numrut_emp=:b_id_emp;
  DBMS_OUTPUT.PUT_LINE('LOS DATOS DEL EMPLEADO ' || :b_id_emp || ' SON LOS SIGUIENTES:');
  DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre_emp);
  DBMS_OUTPUT.PUT_LINE('Salario: ' || v_salario);
  DBMS_OUTPUT.PUT_LINE('Trabaja en el Depto.: ' || v_nombre_depto);
END;
