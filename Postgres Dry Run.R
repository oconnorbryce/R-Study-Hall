library(RPostgreSQL)
library(rpostgis)

### To create database vis psql shell enter past all the first command lines
### and then enter password. After use SQL CREATE DATABASE (databasename).
### otherwise create database in pgadmin and conect from here


#### CREATE connection between postgreSQL & R
# create user password 
pw <- {"parsnipgrayling"}
# load the postgresql 
drv <- dbDriver("PostgreSQL")
# creates a connection to the postgres database
# "con" will be used later in each connect
con <- dbConnect(drv, dbname = "postgres_dry_run", host="localhost", port=5432, user="postgres", password=pw)
rm(pw) # removes the password


#### Connect with spatial data analysis interfaces
dbExecute(con, "CREATE EXTENSION IF NOT EXISTS postgis;")


#add schema for temperature data
dbExecute(con, "CREATE SCHEMA lookup;
          COMMENT ON SCHEMA lookup IS 'Schema to store stable information like
          waypoints, or indexes of stream names etc';")




###  Create waypoints table in lookup schema ------------
dbExecute(con, "DROP TABLE IF EXISTS lookup.waypoints CASCADE;
CREATE TABLE lookup.waypoints (
  waypoint_name varchar,
  site_code varchar,
  stream integer,
  lat double precision,
  lon double precision,
  comment varchar,
  geom geometry(Point,4326),
  insertion_time timestamp with time zone DEFAULT now()
);")