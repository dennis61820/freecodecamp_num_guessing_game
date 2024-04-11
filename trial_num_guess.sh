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

fi
}

GET_USER


ADD_PLAYER () {
  NEW_PLAYER=$($PSQL "select name from players where name = '$USER_NAME'")
  PLAYER_ID=$($PSQL "select player_id from players where name = '$NEW_PLAYER'")
  if [[ -z $NEW_PLAYER ]]
  then 
    NEWLY_ADDED_PLAYER=$($PSQL "insert into players(name) values('$USER_NAME')")
    let PLAYER_ID=$($PSQL "select player_id from players where name = '$USER_NAME'")
    echo "Welcome, $USER_NAME! It looks like this is your first time here."
  else
    NUM_OF_GAMES=$($PSQL "select count(g.game_date) from games as g join players as p using(player_id) where p.name = '$NEW_PLAYER'")
    NUM_OF_GUESSES=$($PSQL "select g.num_of_guesses from games as g join players as p using(player_id) where p.name = '$NEW_PLAYER'")
    BEST_GAME=$($PSQL "select min(g.num_of_guesses) from games as g join players as p using(player_id) where p.name = '$NEW_PLAYER' limit 1")
  
    echo -e "\nWelcome back, $NEW_PLAYER! You have played $NUM_OF_GAMES games, and your best game took $NUM_OF_GUESSES guesses."
  fi
}
ADD_PLAYER



  echo $PLAYER_ID
   BEGIN_GAME=$($PSQL "insert into games(player_id) values($PLAYER_ID) ")
   GAME_ID=$($PSQL "select max(game_id) from games where player_id = $PLAYER_ID")
# generate a number between 1 and 1000
NUMBER=$(($RANDOM % 1000 + 1))
echo -e "\nthe number is $NUMBER"
echo -e "\nGuess the secret number between 1 and 1000: "

NUMBER_OF_GUESSES=0

# start the game

GUESS_NUM () {
  
  read GUESS
  
   let NUMBER_OF_GUESSES+=1
  EDIT_NUM_OF__GUESSES=$($PSQL "update games set num_of_guesses = $NUMBER_OF_GUESSES where (player_id = $PLAYER_ID and game_id = $GAME_ID)")
 # echo $NUMBER_OF_GUESSES
   
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo -e "\nThat is not an integer, guess again:"
    GUESS_NUM 
  fi
  
  # 1 number correct
    if [[ $GUESS < $NUMBER ]]
    then
      echo -e "\nIt's higher than that, guess again:"
      GUESS_NUM
  # 2 number low
    elif [[ $GUESS > $NUMBER ]]
    then
      echo -e "\nIt's lower than that, guess again:"
      GUESS_NUM
  # 3 number high 
    else
      
      echo -e "\nYou guessed it in $NUMBER_OF_GUESSES tries. The secret number was $NUMBER. Nice job!" 
    fi
  
}
 GUESS_NUM




