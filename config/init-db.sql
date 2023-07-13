create user ovirt_cinderlib password 'ovirt_cinderlib';
drop database IF EXISTS ovirt_cinderlib;
create database ovirt_cinderlib owner ovirt_cinderlib template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';

create user engine password 'engine';
drop database IF EXISTS engine;
create database engine owner engine template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';

\c engine
CREATE EXTENSION "uuid-ossp"
