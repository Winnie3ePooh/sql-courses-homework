--TABLES
CREATE TABLE object_types (
  object_type_id Number PRIMARY KEY,
  parent_id number REFERENCES object_types(object_type_id),
  name varchar2(20) Not null,
  description varchar2(250),
  properties number GENERATED ALWAYS AS (object_type_id + 1) VIRTUAL
);

CREATE TABLE objects(
  object_id number PRIMARY KEY,
  parent_id number REFERENCES objects(object_id),
  object_type_id number REFERENCES object_types(object_type_id),
  name varchar(50) Not null,
  description varchar2(250),
  order_number number
);

CREATE TABLE attr_types(
  attr_type_id number CONSTRAINT attr_type_pk PRIMARY KEY,
  name varchar(20) Not null,
    properties number GENERATED ALWAYS AS (attr_type_id + 1) VIRTUAL
);

CREATE TABLE attr_groups(
  attr_group_id number CONSTRAINT attr_group_pk PRIMARY KEY,
  name varchar(40) Not null,
    properties number GENERATED ALWAYS AS (attr_group_id + 1) VIRTUAL
);

CREATE TABLE attributes(
  attr_id number CONSTRAINT attr_pk PRIMARY KEY,
  attr_type_id number REFERENCES attr_types(attr_type_id),
  attr_group_id number REFERENCES attr_groups(attr_group_id),
  name varchar(40) Not null Unique,
  description varchar2(250),
  ismultiple number(1,0),
    properties number GENERATED ALWAYS AS (attr_id + 1) VIRTUAL
);

CREATE TABLE attr_binds(
  object_type_id number REFERENCES object_types(object_type_id),
  attr_id number REFERENCES attributes (attr_id),
  isrequired number(1,0),
  default_value varchar2(250),
    options varchar(250)
);

CREATE TABLE params(
  object_id number REFERENCES objects(object_id),
  attr_id number REFERENCES attributes (attr_id),
  value varchar(30),
  date_value date,
  show_order number
);

CREATE TABLE references(
    object_id number REFERENCES objects(object_id),
  attr_id number REFERENCES attributes,
  reference number REFERENCES objects(object_id),
  show_order number
);

-- INSERTS

INSERT INTO object_types (object_type_id,parent_id,name,description) VALUES (1,null,'Region','Main class');
INSERT INTO object_types (object_type_id,parent_id,name,description) VALUES (2,1,'Shop','Shop class');
INSERT INTO object_types (object_type_id,parent_id,name,description) VALUES (3,2,'Category','Good categories');
INSERT INTO object_types (object_type_id,parent_id,name,description) VALUES (4,3,'Good','Good class');

INSERT INTO objects (object_id,parent_id,object_type_id,name,description,order_number) VALUES (1,null,1,'RU','RU Region',1);
INSERT INTO objects (object_id,parent_id,object_type_id,name,description,order_number) VALUES (2,1,2,'Roga i kopita','Electronics store',1);
INSERT INTO objects (object_id,parent_id,object_type_id,name,description,order_number) VALUES (3,2,3,'Accessories','PCs accessories',1);
INSERT INTO objects (object_id,parent_id,object_type_id,name,description,order_number) VALUES (4,3,4,'Intel Core i7-8700K','Processor',1);
INSERT INTO objects (object_id,parent_id,object_type_id,name,description,order_number) VALUES (5,3,4,'ASUS Xonar DX','Sound card',2);
INSERT INTO objects (object_id,parent_id,object_type_id,name,description,order_number) VALUES (6,1,2,'Roga i Roga','Electronics store',1);

INSERT INTO attr_types (attr_type_id,name) VALUES (1,'number');
INSERT INTO attr_types (attr_type_id,name) VALUES (2,'string');
INSERT INTO attr_types (attr_type_id,name) VALUES (3,'bool');
INSERT INTO attr_types (attr_type_id,name) VALUES (4,'date');
INSERT INTO attr_types (attr_type_id,name) VALUES (5,'relation');

INSERT INTO attr_groups (attr_group_id,name) VALUES (1,'Common');
INSERT INTO attr_groups (attr_group_id,name) VALUES (2,'Classification');
INSERT INTO attr_groups (attr_group_id,name) VALUES (3,'Сore and architecture');

INSERT INTO attributes (attr_id,attr_type_id,attr_group_id,name,description,ismultiple) VALUES (1,2,1,'Model','Full name',0);
INSERT INTO attributes (attr_id,attr_type_id,attr_group_id,name,description,ismultiple) VALUES (2,2,1,'Color','Good color',0);
INSERT INTO attributes (attr_id,attr_type_id,attr_group_id,name,description,ismultiple) VALUES (3,2,1,'Socket','Sockets name',0);
INSERT INTO attributes (attr_id,attr_type_id,attr_group_id,name,description,ismultiple) VALUES (4,2,2,'Location','Where in PC',0);
INSERT INTO attributes (attr_id,attr_type_id,attr_group_id,name,description,ismultiple) VALUES (5,1,3,'Cores number','Number of cores',0);
INSERT INTO attributes (attr_id,attr_type_id,attr_group_id,name,description,ismultiple) VALUES (6,5,null,'Category','Relation for good category',1);
INSERT INTO attributes (attr_id,attr_type_id,attr_group_id,name,description,ismultiple) VALUES (7,5,null,'Common relation','Common relation (for example)',1);

INSERT INTO attr_binds (object_type_id,attr_id,isrequired,default_value,options) VALUES (4,1,1,'In developing','-');
INSERT INTO attr_binds (object_type_id,attr_id,isrequired,default_value,options) VALUES (4,2,0,'In developing','-');
INSERT INTO attr_binds (object_type_id,attr_id,isrequired,default_value,options) VALUES (4,3,0,'In developing','-');
INSERT INTO attr_binds (object_type_id,attr_id,isrequired,default_value,options) VALUES (4,4,0,'In developing','-');
INSERT INTO attr_binds (object_type_id,attr_id,isrequired,default_value,options) VALUES (4,5,0,'In developing','-');

INSERT INTO params (object_id,attr_id,value,date_value,show_order) VALUES (3,6,'Example',null,3);
INSERT INTO params (object_id,attr_id,value,date_value,show_order) VALUES (4,1,'Intel Core i7-8700 BOX',null,1);
INSERT INTO params (object_id,attr_id,value,date_value,show_order) VALUES (4,3,'LGA 1151-v2',null,2);
INSERT INTO params (object_id,attr_id,value,date_value,show_order) VALUES (4,5,'6',null,3);
INSERT INTO params (object_id,attr_id,value,date_value,show_order) VALUES (5,1,'ASUS Xonar DSX',null,1);
INSERT INTO params (object_id,attr_id,value,date_value,show_order) VALUES (5,2,'Black',null,2);
INSERT INTO params (object_id,attr_id,value,date_value,show_order) VALUES (5,4,'Inside',null,3);
INSERT INTO params (object_id,attr_id,value,date_value,show_order) VALUES (5,6,'Xonar ref example',null,3);

INSERT INTO references (object_id,attr_id,reference,show_order) VALUES (4,6,3,1);
INSERT INTO references (object_id,attr_id,reference,show_order) VALUES (5,6,3,2);
INSERT INTO references (object_id,attr_id,reference,show_order) VALUES (3,7,2,1);
INSERT INTO references (object_id,attr_id,reference,show_order) VALUES (2,7,1,1);
/
-- TASKS
-- 1
-- Получение информации о всех атрибутах(учитывая только атрибутную группу и атрибутные типы)
SELECT
  attr.name as attr_name,
  attr_t.name as type_name,
  attr_g.name as group_name
FROM 
  ATTRIBUTES attr
LEFT OUTER JOIN attr_groups attr_g ON attr.attr_group_id = attr_g.attr_group_id
JOIN attr_types attr_t using (attr_type_id)
/
-- 2
-- Получение атрибутов для конкретного объектного типа(вывести также имя объектного типа и имена атрибутов)
SELECT
  ot.object_type_id, ot.name as object_type_name,
  attr.attr_id, attr.name as attr_name,
  ab.options,
  CASE WHEN ab.isrequired = 1
      then 'Y'
      else 'N'
  END AS REQUIRED,
  ab.default_value
FROM
  object_types ot,
  attr_binds ab,
  attributes attr
WHERE
  ot.object_type_id = 4
  AND ot.object_type_id = ab.object_type_id
  AND attr.attr_id = ab.attr_id;
/
-- 3
-- Получение иерархии ОТ(объектных типов) для заданного объектного типа(нужно получить иерархию наследования)
SELECT
  SYS_CONNECT_BY_PATH (name, '/') as Path
FROM  
  object_types
START WITH 
  object_type_id = 3
CONNECT BY 
  object_type_id = PRIOR parent_id;
/
-- 4
-- Получение вложенности объектов для заданного объекта(нужно получить иерархию вложенности)
SELECT 
  SYS_CONNECT_BY_PATH(name, '/') as Path 
FROM 
  objects
START WITH 
  object_id = 2
CONNECT BY  
  object_id = PRIOR parent_id;
/
-- 5
-- Получение объектов заданного объектного типа(учитывая только наследование ОТ)
select 
  objects.name
from objects
where
  object_type_id in (
    select object_type_id from object_types   
    start with object_type_id = 3
    connect by prior parent_id = object_type_id
  );
/
-- 6
-- Получение значений атрибутов для заданного объекта(без учета наследования ОТ). 
-- Вывести в виде(ID_атрибута – Имя_атрибута – Значение_атрибута)/    
SELECT 
  attributes.attr_id as attr_id,
  attributes.name as attr_name, 
  case
    when params.value is not null
      then params.value
    when params.date_value is not null
      then to_char(params.date_value)
  end as value
FROM 
  attributes
JOIN params ON attributes.attr_id = params.attr_id
JOIN objects ON params.object_id = objects.object_id
WHERE 
  objects.object_id = 4
UNION
SELECT
  attributes.attr_id as attr_id,
  attributes.name as attr_name, 
  to_char(references.reference) as value
FROM references
JOIN attributes ON attributes.attr_id = references.attr_id
WHERE
  references.object_id = 4
/
-- 7
-- Получение ссылок на заданный объект(все объекты, которые ссылаются на текущий)
SELECT
  r.object_id
FROM
  references r
WHERE 
  r.reference = 3
/
SELECT
  o.object_id,
  o.name
FROM
  objects o
WHERE 
  o.object_id in (select r.object_id from references r where r.reference = 3)
/
-- 8
-- Получение значений атрибутов(без повторяющихся атрибутов) 
-- для заданного объекта(с учетом наследования ОТ) Вывести в виде см. п.6
SELECT DISTINCT
  attr_id,
  name,
  value
FROM
  (
    SELECT 
      ab.attr_id,
      attr.name,
      case
        when params.value is not null
          then params.value
        when params.date_value is not null
          then to_char(params.date_value)
      end as value
    FROM (
      SELECT object_type_id FROM object_types   
        START WITH object_type_id = (
          SELECT object_type_id FROM objects
          WHERE object_id = 4
        )
        CONNECT BY PRIOR parent_id = object_type_id
      ) ot
    JOIN attr_binds ab
      ON ot.object_type_id = ab.object_type_id
    JOIN attributes attr
      ON ab.attr_id = attr.attr_id
    LEFT JOIN params
      ON params.object_id = 4 and params.attr_id = attr.attr_id
    LEFT JOIN references refer
      ON params.object_id = refer.object_id
    UNION
    SELECT
      attr.attr_id,
      attr.name,
      to_char(references.reference) as value
    FROM references
    JOIN attributes attr ON attr.attr_id = references.attr_id
    WHERE
      references.object_id = 4
  );
/