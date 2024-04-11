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
    echo "~~~~~~the new player is $NEW_PLAYER and the player id is $PLAYER_ID~~~~~~"
  else
  echo "welcome back $NEW_PLAYER, as you recall your id is $PLAYER_ID"
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
  fi
  
  # 1 number correct
    if [[ $GUESS < $NUMBER ]]
    then
      echo "It's higher than that, guess again: "
      GUESS_NUM
  # 2 number low
    elif [[ $GUESS > $NUMBER ]]
    then
      echo "It's lower than that, guess again: "
      GUESS_NUM
  # 3 number high 
    else
      
      echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $NUMBER. Nice job!" 
    fi
  
}
 GUESS_NUM
