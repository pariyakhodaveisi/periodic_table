#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table  --no-align --tuples-only -c"

if [[ $1 ]]
 then
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
  ELEMENT=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $1 LIMIT 1")
  else
  ELEMENT=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE elements.atomic_number=$1")
  fi
    if [[ -z $ELEMENT ]] 
    then 
      echo "I could not find that element in the database."
  else
    echo $ELEMENT | while IFS=\| read ATOMIC_NUMBER ATOMIC_MAS
    do
      echo "$ATOMIC_NUMBER - $ATOMIC_MAS"
    done

  fi
else
  echo "Please provide an element as an argument."
fi
