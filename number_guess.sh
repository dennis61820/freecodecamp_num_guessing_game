#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"


echo "Enter your username: "

# get user name
GET_USER () {
  read USER_NAME
if [[ ${#USER_NAME} -gt 22 ]]
then
  echo "Please choose a name with less than 23 characters: "
  GET_USER
else
  echo "howdy $USER_NAME"
fi
}

GET_USER

echo $USER_NAME

#check if user exists
ADD_PLAYER=$($PSQL "select name from players where name = '$USER_NAME'")
if [[ -z $ADD_PLAYER ]]
then
  # if no add and greet
  ADD_PLAYER=$($PSQL "insert into players(name) values('$USER_NAME')")
  #let PLAYER_ID = $($PSQL "select player_id from players where name = '$USER_NAME")
  echo "Welcome, $USER_NAME! It looks like this is your first time here."
# if yes - greet
else
  NUM_OF_GAMES=$($PSQL "select count(g.game_date) from games as g join players as p using(player_id) where p.name = '$USER_NAME'")
  NUM_OF_GUESSES=$($PSQL "select g.num_of_guesses from games as g join players as p using(player_id) where p.name = '$USER_NAME'")
  BEST_GAME=$($PSQL "select min(g.num_of_guesses) from games as g join players as p using(player_id) where p.name = '$USER_NAME'")
  echo -e "\nWelcome back, $USER_NAME! You have played $NUM_OF_GAMES games, and your best game took $NUM_OF_GUESSES guesses."
fi

