#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE games, teams")"

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS;
do 
  if [[ $YEAR != 'year' ]]
    then
      WINNER_IN_DB="$($PSQL "SELECT * FROM teams WHERE name='$WINNER'")"
      if [[ -z $WINNER_IN_DB ]]
        then
          # echo "$WINNER IS '$WINNER'"
          INSERT_WINNER="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER') ")"
          if [[ -z INSERT_WINNER ]]
            then
              echo "There was a problem inserting the winner into the DB"
          fi
      fi
      #repeat for opponent
  
      OPPONENT_IN_DB="$($PSQL "SELECT * FROM teams WHERE name='$OPPONENT'")"
      if [[ -z $OPPONENT_IN_DB ]]
        then
          # echo 'should insert opponent'
          INSERT_OPPONENT="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT') ")"
          if [[ -z INSERT_OPPONENT ]]
            then
              echo "There was a problem inserting the opponent into the DB"
          fi
      fi

    # insert games data into games table
    WINNER_ID_FROM_TEAMS="$($PSQL " SELECT team_id FROM teams WHERE name='$WINNER' " )"
    OPPEONENT_ID_FROM_TEAMS="$($PSQL " SELECT team_id FROM teams WHERE name='$OPPONENT' " )"

    # insert game data
    INSERT_GAME_DATA="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID_FROM_TEAMS, $OPPEONENT_ID_FROM_TEAMS, $WINNER_GOALS, $OPPONENT_GOALS  )")"

  fi
done


