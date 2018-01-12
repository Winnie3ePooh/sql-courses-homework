create or replace type arrayofnames is table of varchar2(128);
/
create or replace function emp_dep(dep_id in number)
  return arrayofnames
is
  cursor cur_one is
    select first_name from employees
    where department_id = dep_id;
  empl arrayofnames := arrayofnames();
  empl_name employees.first_name%type;
  e_err exception;
begin
  if not cur_one%isopen then
    open cur_one;
  end if;
  empl.extend;
  empl(empl.last) := 'Explicit cursor';
  loop
    fetch cur_one into empl_name;
    if (cur_one%rowcount = 0) then
      empl.extend;
      empl(empl.last) := 'Nothing found';
      raise e_err;
    end if;
    if cur_one%found then
      empl.extend;
      empl(empl.last) := empl_name;
    end if;
    EXIT WHEN cur_one%notfound;
  end loop;
  if cur_one%isopen then
   close cur_one;
  end if;
  empl.extend;
  empl(empl.last) := '----------------';
  empl.extend;
  empl(empl.last) := 'Implicit cursor';
  for i in (select first_name, rownum from employees
              where department_id = dep_id)
  loop
    empl.extend;
    empl(empl.last) := i.first_name;
  end loop;
  return empl;
exception
  when e_err then
    dbms_output.put_line('Nothing found/There is no such department');
    return empl;
end;
/
declare 
  finding_empl arrayofnames := arrayofnames();
begin
  finding_empl := emp_dep(100);
  for i in finding_empl.first..finding_empl.last
  loop
    dbms_output.put_line(finding_empl(i));
  end loop;
 exception 
  when value_error then
    dbms_output.put_line('Input argument is wrong');
end;
/
select * from table(emp_dep(90));
/
--ЗАДАНИЕ 2
create or replace package PKG_OPERATIONS is
  procedure make(table_name varchar2, cols varchar2);
  procedure add_row(table_name VARCHAR2, vals VARCHAR2, cols VARCHAR2 := null);
  procedure update_row(table_name in VARCHAR2, new_vals in VARCHAR2, find_val in VARCHAR2);
  procedure remove_row(table_name in VARCHAR2, find_val in VARCHAR2);
  procedure remove(table_name varchar2);
end PKG_OPERATIONS;
/
create or replace package body PKG_OPERATIONS is
  procedure make(table_name in varchar2, cols in varchar2) 
  is
    create_stmt varchar2(1000);
    e_null_cols exception;
  begin
    if cols is null then
      raise e_null_cols;
    end if;
    create_stmt := 'CREATE TABLE '||table_name||' ('||cols||')';
    EXECUTE IMMEDIATE create_stmt;
    dbms_output.put_line('Table '||table_name||' created');
  exception
    when e_null_cols then
      dbms_output.put_line('Cols shouldn''t be empty');
    when others then
      if  sqlcode = -955 then
        dbms_output.put_line('Table '||table_name||' already exists');
      end if;
  end make;
  
  procedure add_row(table_name in VARCHAR2, vals in VARCHAR2, cols in VARCHAR2 := null) 
  is
    create_stmt varchar2(1000);
  begin
    create_stmt := 'INSERT INTO '||table_name||'';
    if(cols is null) then
      create_stmt := ''||create_stmt||' VALUES ('||vals||')';
    else
      create_stmt := ''||create_stmt||' ('||cols||') VALUES ('||vals||')';
    end if;
    EXECUTE IMMEDIATE create_stmt;
    dbms_output.put_line('Row added');
  exception
    when others then
      if sqlcode = -913 then
        dbms_output.put_line('Check the number of input data and the corresponding columns');
      end if;
  end add_row;
  
  procedure update_row(table_name in VARCHAR2, new_vals in VARCHAR2, find_val in VARCHAR2) 
  is
    create_stmt varchar2(1000);
    e_new_vals exception;
  begin
    if new_vals is null then
     raise e_new_vals;
    end if;
    if find_val is null then
      create_stmt := 'UPDATE '||table_name||' SET '||new_vals;
    else
      create_stmt := 'UPDATE '||table_name||' SET '||new_vals||' WHERE '||find_val;
    end if;
    EXECUTE IMMEDIATE create_stmt;
    dbms_output.put_line('Row updated');
  exception
    when e_new_vals then
      dbms_output.put_line('Seconds argument shouldnt be null');
    when others then
      if  sqlcode = -904 then
        dbms_output.put_line('Invalid column identifier. Check your second and third arguments');
      elsif sqlcode = -942 then
        dbms_output.put_line('Such table doesn''t exist. Check your first argument');
      end if;
  end update_row;
  
  procedure remove_row(table_name in VARCHAR2, find_val in VARCHAR2) 
  is
    create_stmt varchar2(1000);
  begin
    if find_val is null then
      create_stmt := 'DELETE FROM '||table_name;
    else 
      create_stmt := 'DELETE FROM '||table_name||' WHERE '||find_val||'';
    end if;
    EXECUTE IMMEDIATE create_stmt;
  exception
    when others then
    if  sqlcode = -904 then
      dbms_output.put_line('Invalid column identifier. Check your second argument');
    elsif sqlcode = -942 then
      dbms_output.put_line('Such table doesn''t exist. Check your first argument');
    end if;
  end remove_row;
  
  procedure remove(table_name in varchar2)
  is
    create_stmt varchar2(1000);
  begin
    create_stmt := 'DELETE FROM '||table_name||'';
    EXECUTE IMMEDIATE create_stmt;
    dbms_output.put_line('Rows deleted:'||to_char(SQL%ROWCOUNT)||'');
    create_stmt := 'DROP TABLE '||table_name||'';
    EXECUTE IMMEDIATE create_stmt;
  exception 
   when others then
    dbms_output.put_line('Table '||table_name||' doesn''t exist');
  end remove;
end PKG_OPERATIONS;
/
DECLARE
BEGIN
  PKG_OPERATIONS.make('testst', 'id number(4), name varchar2(40)');
  PKG_OPERATIONS.add_row('testst','2,''Ivan Ivanov''','id,name');
  PKG_OPERATIONS.add_row('testst','2,''Ivan Neivanov''','id,name');
  PKG_OPERATIONS.update_row('testst','name=''Ivanov I. Ivan''', 'id=2');
  PKG_OPERATIONS.remove_row('testst','id=2');
  PKG_OPERATIONS.remove_row('testst','asd=3');
  PKG_OPERATIONS.remove('testst');
END;
/

--Задание 3
SELECT COUNT(*) AS RESULT FROM 
    (SELECT ROWNUM-1 D1 FROM DUAL CONNECT BY ROWNUM <= 10),  
    (SELECT ROWNUM-1 D2 FROM DUAL CONNECT BY ROWNUM <= 10),
    (SELECT ROWNUM-1 D3 FROM DUAL CONNECT BY ROWNUM <= 10),
    (SELECT ROWNUM-1 D4 FROM DUAL CONNECT BY ROWNUM <= 10),
    (SELECT ROWNUM-1 D5 FROM DUAL CONNECT BY ROWNUM <= 10),
    (SELECT ROWNUM-1 D6 FROM DUAL CONNECT BY ROWNUM <= 10)
WHERE D1+D2+D3=D4+D5+D6
/
--Задание 4
create table workhours
(
  id number(4) primary key not null,
  start_date date not null,
  end_date date not null,
  worker varchar2(50) not null
);
--/
--drop sequence workhours_s;
/
create sequence workhours_s
  start with 1
  increment by 1
  nocache;
/
create or replace trigger workhours_t
  before insert on workhours
  for each row 
  begin 
    select workhours_s.nextval 
    into :new.id from dual; 
  end; 
/
insert into workhours(start_date,end_date,worker) values (to_date('20.09.2017', 'dd.mm.yyyy'),to_date('21.12.2017', 'dd.mm.yyyy'),'Maxim Stepanov');
insert into workhours(start_date,end_date,worker) values (to_date('20.09.2017', 'dd.mm.yyyy'),to_date('21.12.2017', 'dd.mm.yyyy'),'Ivan Ivanov');
insert into workhours(start_date,end_date,worker) values (to_date('20.09.2017', 'dd.mm.yyyy'),to_date('21.12.2017', 'dd.mm.yyyy'),'Test testovich');
delete from workhours where id=3;
insert into workhours(start_date,end_date,worker) values (to_date('20.09.2017', 'dd.mm.yyyy'),to_date('21.12.2017', 'dd.mm.yyyy'),'David Moonlight');
select * from workhours;