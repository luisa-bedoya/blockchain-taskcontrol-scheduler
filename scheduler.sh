

#!/bin/bash


echo "Username: $1";
echo "Task Name: $2";
echo "Description Task: $3";

#Choose random the machine will execute the task
num=$((1 + $RANDOM % 6))

if [[ $num == 1 ]] #Computer Sciences
then
    echo "Updating status to Running"
    docker exec cli-university "./scheduler/computersciences.sh" "$1" "$2" "$3" "ToDo" "Running"
    echo "Running on Computer Sciences"
    docker exec peer0.computersciencesorg.university.com sleep $((1 + $RANDOM % 10))
    echo "Updating status to Ended"
    docker exec cli-university "./scheduler/computersciences.sh" "$1" "$2" "$3" "ToDo" "Ended"
elif [[ $num == 2 ]] #Exact Sciences
then
    echo "Updating status to Running"
    docker exec cli-university "./scheduler/exactsciences.sh" "$1" "$2" "$3" "ToDo" "Running"
    echo "Running on Exact Sciences"
    docker exec peer0.exactsciencesorg.university.com sleep $((1 + $RANDOM % 10))
    echo "Updating status to Ended"
    docker exec cli-university "./scheduler/exactsciences.sh" "$1" "$2" "$3" "ToDo" "Ended"
elif [[ $num == 3 ]] #Engineering
then
    echo "Updating status to Running"
    docker exec cli-university "./scheduler/engineering.sh" "$1" "$2" "$3" "ToDo" "Running"
    echo "Running on Engineering"
    docker exec peer0.engineeringorg.university.com sleep $((1 + $RANDOM % 10))
    echo "Updating status to Ended"
    docker exec cli-university "./scheduler/engineering.sh" "$1" "$2" "$3" "ToDo" "Ended"
elif [[ $num == 4 ]] #Statistics
then
    echo "Updating status to Running"
    docker exec cli-university "./scheduler/statistics.sh" "$1" "$2" "$3" "ToDo" "Running"
    echo "Running on Statistics"
    docker exec peer0.statisticsorg.university.com sleep $((1 + $RANDOM % 10))
    echo "Updating status to Ended"
    docker exec cli-university "./scheduler/statistics.sh" "$1" "$2" "$3" "ToDo" "Ended"
elif [[ $num == 5 ]] #Research
then
    echo "Updating status to Running"
    docker exec cli-university "./scheduler/research.sh" "$1" "$2" "$3" "ToDo" "Running"
    echo "Running on Research"
    docker exec peer0.researchorg.university.com sleep $((1 + $RANDOM % 10))
    echo "Updating status to Ended"
    docker exec cli-university "./scheduler/research.sh" "$1" "$2" "$3" "ToDo" "Ended"
elif [[ $num == 6 ]] #Chemical
then
    echo "Updating status to Running"
    docker exec cli-university "./scheduler/chemical.sh" "$1" "$2" "$3" "ToDo" "Running"
    echo "Running on Exact Sciences"
    docker exec peer0.chemicalorg.university.com sleep $((1 + $RANDOM % 10))
    echo "Updating status to Ended"
    docker exec cli-university "./scheduler/chemical.sh" "$1" "$2" "$3" "ToDo" "Ended"
fi








