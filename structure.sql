
drop database coachmanagement;

CREATE DATABASE IF NOT EXISTS coachmanagement
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

use coachmanagement;

create table Users(
  id_users int primary key auto_increment,
  username varchar(50) not null,
  password varchar(255) not null,
  email varchar(50) unique,
  phone varchar(30) unique,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);



