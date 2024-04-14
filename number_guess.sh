#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
# generate a number between 1 and 1000
NUMBER=$(($RANDOM % 1000 + 1))
# calculate the number of guesses
NUMBER_OF_GUESSES=0


# get user name
echo "Enter your username: "
GET_USER () {
  read USER_NAME
  # if longer than 22 ask again
if [[ ${#USER_NAME} -gt 22 ]]
then
  echo "Please choose a name with less than 23 characters: "
  GET_USER
else
  NEW_PLAYER=$($PSQL "select name from players where name = '$USER_NAME'")
  PLAYER_ID=$($PSQL "select player_id from players where name = '$NEW_PLAYER'")
  if [[ -z $NEW_PLAYER ]]
  then
    ADD_NEW_PLAYER=$($PSQL "insert into players(name) values('$USER_NAME')")
    NEW_PLAYER=$($PSQL "select name from players where name = '$USER_NAME'")
    PLAYER_ID=$($PSQL "select player_id from players where name = '$NEW_PLAYER'")
    echo Welcome, $NEW_PLAYER! It looks like this is your first time here.
  else
    NUM_OF_GAMES=$($PSQL "select count(g.game_date) from games as g join players as p using(player_id) where p.player_id = '$PLAYER_ID'")
    NUM_OF_GUESSES=$($PSQL "select g.num_guesses from games as g join players as p using(player_id) where p.player_id = '$PLAYER_ID'")
    BEST_GAME=$($PSQL "select min(g.num_guesses) from games as g join players as p using(player_id) where p.player_id = '$PLAYER_ID'")
  
    echo "Welcome back, $NEW_PLAYER! You have played $NUM_OF_GAMES games, and your best game took $BEST_GAME guesses."
  fi

fi
}

GET_USER






# start the game

echo -e "\nGuess the secret number between 1 and 1000: "

# guess the number
GUESS_NUM () {
  BEGIN_GAME=$($PSQL "insert into games(player_id) values($PLAYER_ID) ")
  GAME_ID=$($PSQL "select max(game_id) from games where player_id = $PLAYER_ID")
  
  read GUESS
  
   let NUMBER_OF_GUESSES+=1
  EDIT_NUM_OF__GUESSES=$($PSQL "update games set num_of_guesses = $NUMBER_OF_GUESSES where (player_id = $PLAYER_ID and game_id = $GAME_ID)")
 # echo $NUMBER_OF_GUESSES
   
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again: "
    GUESS_NUM 
  elif [[ $GUESS -lt $NUMBER ]]
    then
      echo "It's higher than that, guess again: "
      GUESS_NUM
  elif [[ $GUESS -gt $NUMBER ]]
    then
      echo "It's lower than that, guess again: "
      GUESS_NUM
  else  
      echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $NUMBER. Nice job!" 
    fi
  
}
 GUESS_NUM
