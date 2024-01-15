declare
resultado number;
numero number:='&ingresar';
multiplicador NUMBER := 0;
v_limite number:='&ingresar';
begin
loop
    resultado := numero*multiplicador;
    multiplicador := multiplicador+1;
    EXIT WHEN multiplicador > v_limite;
    DBMS_OUTPUT.PUT_LINE(to_char(numero)||'*'||TO_CHAR(multiplicador)||'='||TO_CHAR(resultado));
end loop;
end;