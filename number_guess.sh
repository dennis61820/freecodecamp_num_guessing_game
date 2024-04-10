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


#check if user exists
NEW_PLAYER=$($PSQL "select name from players where name = '$USER_NAME'")
if [[ -z $ADD_PLAYER ]]
then
  # if no add and greet
  ADD_PLAYER=$($PSQL "insert into players(name) values('$USER_NAME')")
  echo "Welcome, $USER_NAME! It looks like this is your first time here."
# if yes - greet
else
  NUM_OF_GAMES=$($PSQL "select count(g.game_date) from games as g join players as p using(player_id) where p.name = '$USER_NAME'")
  NUM_OF_GUESSES=$($PSQL "select g.num_of_guesses from games as g join players as p using(player_id) where p.name = '$USER_NAME'")
  BEST_GAME=$($PSQL "select min(g.num_of_guesses) from games as g join players as p using(player_id) where p.name = '$USER_NAME'")
  echo -e "\nWelcome back, $USER_NAME! You have played $NUM_OF_GAMES games, and your best game took $NUM_OF_GUESSES guesses."
fi

# echo $ADD_PLAYER

 # generate a number between 1 and 1000
NUMBER=$(($RANDOM % 1000 + 1))
#echo -e "\nthe number is $NUMBER"
 echo -e "\nGuess the secret number between 1 and 1000:"
   PLAYER_ID=$($PSQL "select player_id from players where name = '$USER_NAME'")
  # echo -e "\nyour id is $PLAYER_ID"
   BEGIN_GAME=$($PSQL "insert into games(player_id) values($PLAYER_ID) ")
   GAME_ID=$($PSQL "select max(game_id) from games where player_id = $PLAYER_ID")
# echo $BEGIN_GAME
# echo $GAME_ID
# echo $NUMBER
 


NUMBER_OF_GUESSES=0

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
