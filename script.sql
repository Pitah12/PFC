use vulne;
create table user
(
nombre varchar(35) primary key not null,
passwd varchar(35) not null
)engine=innodb;