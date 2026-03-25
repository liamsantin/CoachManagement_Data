
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

create table Cantons(
    id_cantons int primary key auto_increment,
    code varchar(4) not null,
    name varchar(100) not null
);

create table Localites (
    id_localites int primary key auto_increment,
    fk_cantons_id int not null,
    npa VARCHAR(5) not null,
    localite VARCHAR(50) not null,
    CONSTRAINT fk_loc_cantons foreign key (fk_cantons_id) references Cantons(id_cantons)
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

create table ClubsLocalites_a(
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

create table Opponents(
    id_opponents int primary key auto_increment,
    fk_leagues_id int not null,
    name VARCHAR(50) not null,
    club varchar(50) null,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uni_leagues_name_club unique (fk_leagues_id, name, club),
    CONSTRAINT fk_oppo_leagues foreign key (fk_leagues_id) references Leagues(id_leagues)
);

create table StatusMatch(
    id_statusMatch int primary key auto_increment,
    name varchar(50) not null
);
INSERT INTO StatusMatch (name) VALUES ('Prévu'), ('Joué'), ('Annulé');

create table TypesMatch (
    id_typesMatch int primary key auto_increment,
    name varchar(50) not null
);
INSERT INTO TypesMatch (name) VALUES ('Amical'), ('Championnat'), ('Coupe');

create table Seasons (
    id_seasons int primary key auto_increment,
    startDate DATETIME not null,
    endDate DATETIME not null,
    name VARCHAR(50) null,
    notes TEXT null,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

create table Events(
    id_events int primary key,
    date DATE not null,
    name VARCHAR(100) null,
    startDate DATETIME not null,
    endDate DATETIME not null,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

create table Formations(
    id_formations int primary key auto_increment,
    format VARCHAR(20) not null,
    description TEXT null
);

create table Lineup(
    id_lineup int primary key auto_increment,
    fk_matchs_id int null,
    fk_formations_id int not null,
    name VARCHAR(50) not null,
    notes TEXT null,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_lineup_formations foreign key (fk_formations_id) references Formations(id_formations)
);

create table Matchs (
    id_events int primary key,
    fk_teams_id int not null,
    fk_opponents_id int not null,
    fk_status_id int not null,
    fk_types_id int not null,
    fk_seasons_id int not null,
    fk_lineup_id int not null,
    fk_localites_id int not null,
    scoreEquipe int,
    scoreOpponent int,
    temps decimal(5,2),
    stade varchar(50),
    arbitre varchar(50),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_fk_matchs_events FOREIGN KEY (id_events) references Events(id_events),
    CONSTRAINT fk_matchs_opponents foreign key (fk_opponents_id) references Opponents(id_opponents),
    CONSTRAINT fk_matchs_status foreign key (fk_status_id) references StatusMatch(id_statusMatch),
    CONSTRAINT fk_matchs_types foreign key (fk_types_id) references TypesMatch (id_typesMatch),
    CONSTRAINT fk_matchs_seasons foreign key (fk_seasons_id) references Seasons(id_seasons),
    CONSTRAINT fk_matchs_lineup foreign key (fk_lineup_id) references Lineup(id_lineup),
    CONSTRAINT fk_matchs_loca foreign key (fk_localites_id) references Localites(id_localites)
);

ALTER TABLE Lineup ADD CONSTRAINT fk_lineup_matchs
    foreign key (fk_matchs_id) references Matchs(id_events);

create table TypesTraining(
    id_typesTraining int primary key auto_increment,
    type VARCHAR(50) not null
);
INSERT INTO TypesTraining (type)
VALUES ('Technique'), ('Tactique'), ('Physique'), ('Gardien'), ('Spécifique');

create table Trainings (
    id_events int primary key,
    fk_localites_id int not null,
    fk_types_id int null,
    description TEXT null,
    nbrPlayer int default 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_fk_trainings_events foreign key (id_events) references Events(id_events),
    CONSTRAINT fk_trainings_loc foreign key (fk_localites_id) references Localites(id_localites),
    CONSTRAINT fk_trainings_types foreign key (fk_types_id) references TypesTraining(id_typesTraining)
);

create table Positions (
    id_positions int primary key auto_increment,
    code VARCHAR(4) null,
    description VARCHAR(100) null
);

create table Players(
    id_players int primary key auto_increment,
    fk_teams_id int not null,
    fk_positions_id int not null,
    nom VARCHAR(50) not null,
    prenom varchar(50) not null,
    numeroMaillot int null,
    email varchar(100) unique,
    phone varchar(15) unique,
    anneeExp int,
    poids decimal(5,2),
    taille decimal(5,2),
    dateNaiss date,
    dateArrivee date,
    photoUrl varchar(200),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_players_teams foreign key (fk_teams_id) references Teams(id_teams),
    CONSTRAINT fk_players_positions foreign key (fk_positions_id)
        references Positions(id_positions),
    CONSTRAINT uni_numMaillot_team unique (fk_teams_id, numeroMaillot)
);

create table Attendances_a (
    id_players int not null,
    id_trainings int not null,
    notes TEXT null,
    retard boolean default false,
    motif text null,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_att_player_train PRIMARY KEY (id_players, id_trainings),
    CONSTRAINT fk_att_players foreign key (id_players) references Players(id_players),
    CONSTRAINT fk_att_trainings foreign key (id_trainings) references Trainings(id_events)
);

create table Participations_a (
    id_players int not null,
    id_matchs int not null,
    noteOn10 varchar(6),
    notes text,
    tempsJeu decimal(5,2),
    but int default 0,
    passeD int default 0,
    cartonJaune int default 0,
    cartonRouge int default 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_part_play_match primary key (id_players, id_matchs),
    CONSTRAINT fk_part_players foreign key (id_players) references Players(id_players),
    CONSTRAINT fk_part_matchs foreign key (id_matchs) references Matchs(id_events)
);

create table PlayersLineup (
    id_playersLineup int primary key auto_increment,
    fk_players_id int not null,
    fk_lineup_id int not null,
    fk_positions_id int not null,
    titulaire boolean default true,
    numMaillot int,
    capitaine boolean default false,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_playLineup_player foreign key (fk_players_id) references Players(id_players),
    CONSTRAINT fk_playLineup_lineup foreign key (fk_lineup_id) references Lineup(id_lineup),
    CONSTRAINT fk_playLineup_positions foreign key (fk_positions_id) references Positions(id_positions)
);

create table Replacements(
    id_replacements int primary key auto_increment,
    minute decimal(5,2) not null,
    fk_matchs_id int not null,
    fk_play_entering int not null,
    fk_play_outgoing int not null,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_replace_matchs foreign key (fk_matchs_id) references Matchs(id_events),
    CONSTRAINT fk_replace_entering foreign key (fk_play_entering) references Players(id_players),
    CONSTRAINT fk_replace_outgoing foreign key (fk_play_outgoing) references Players(id_players),
    CONSTRAINT uni_match_minute_out_ent
        UNIQUE (fk_matchs_id, minute, fk_play_outgoing, fk_play_entering)
);