
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

create table Localites (
    id_localites int primary key auto_increment,
    npa VARCHAR(5) not null,
    localite VARCHAR(50) not null
);

create table Clubs (
    id_clubs int primary key auto_increment,
    fk_users_id int not null,
    name VARCHAR(50) not null,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uni_users_name UNIQUE (fk_users_id, name),
    CONSTRAINT fk_clubs_users FOREIGN KEY (fk_users_id) references Users(id_users)
);

create table ClubsLocalites(
    id_localites int not null,
    id_clubs int not null,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_loc_club PRIMARY KEY (id_localites, id_clubs),
    CONSTRAINT fk_clubLoc_loc FOREIGN KEY (id_localites) references Localites(id_localites),
    CONSTRAINT fk_clubLoc_clubs FOREIGN KEY (id_clubs) references Clubs(id_clubs)
);

create table Leagues(
    id_leagues int auto_increment primary key,
    name VARCHAR(50) not null
);

create table Teams (
    id_teams int primary key auto_increment,
    fk_users_id int not null,
    fk_clubs_id int null,
    fk_leagues_id int not null,
    name VARCHAR(50) not null,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uni_users_club_name unique (fk_users_id, fk_clubs_id, name),
    CONSTRAINT fk_teams_users foreign key (fk_users_id) references Users(id_users),
    CONSTRAINT fk_teams_clubs foreign key (fk_clubs_id) references Clubs(id_clubs),
    CONSTRAINT fk_teams_leagues foreign key (fk_leagues_id) references Leagues(id_leagues)
);