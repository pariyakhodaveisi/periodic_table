#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
else
  # Initialize the SQL query variable
  SQL_QUERY=""
  
  if [[ $1 =~ ^[0-9]+$ ]]; then
    # Input is numeric, query by atomic number
    SQL_QUERY="SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $1"
  else
    # Input is not numeric, query by symbol or name
    SQL_QUERY="SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE symbol ILIKE '$1' OR name ILIKE '$1'"
  fi

  ELEMENT=$($PSQL "$SQL_QUERY")

  if [[ -z $ELEMENT ]]; then 
    echo "I could not find that element in the database."
  else
    echo "$ELEMENT" | while IFS='|' read ATOMIC_NUMBER ATOMIC_MASS MPC BPC SY NAME TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SY). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
    done
  fi
fi

