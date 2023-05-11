PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

NUMB_CHECK='^[0-9]+$'

CANT_FIND(){
 echo 'I could not find that element in the database.'
}

CONSTRUCT_OUTPUT(){
  if [[ $1 = 'Name' ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$2'")
  elif [[ $1 = 'Symbol' ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$2'")
  else
    ATOMIC_NUMBER=$2
  fi

  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
}

MAIN_MENU(){
if [[ $1 ]]
then
  if [[ $1 =~ $NUMB_CHECK ]] 
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
    if [[ -z $ATOMIC_NUMBER ]]
    then
      CANT_FIND
    else
      CONSTRUCT_OUTPUT "Number" $ATOMIC_NUMBER
    fi
  else
    NAME=$($PSQL "SELECT name FROM elements WHERE name='$1'")
    if [[ -z $NAME ]]
    then
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
      if [[ -z $SYMBOL ]]
      then
        CANT_FIND
      else
        CONSTRUCT_OUTPUT "Symbol" $SYMBOL
      fi
    else
      CONSTRUCT_OUTPUT "Name" $NAME
    fi
  fi
else 
  echo "Please provide an element as an argument."
fi
}

MAIN_MENU $1