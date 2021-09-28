

package main

import (
	"encoding/json"
	"fmt"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	"time"
)

// SmartContract provides functions for control the status of the task
type SmartContract struct {
	contractapi.Contract
}

// Task describes basic details of a task
type Task struct {
	User  string `json:"user"`
	Name string `json:"name"`
	Description string `json:"description"`
	Traceability string `json:"traceability"`
}

// Type of list of tasks
type TaskList map[int]*Task

// Funcion in charge of add a task to a task list
func appendTask(user string, name string, desc string, status string, list TaskList, machine string) {
	
	taskKey := getTaskKey(name, list)

	obj := &Task{
        User: user,
		Name: name,
		Description: desc,
		Traceability: "",
    }

	if taskKey > 0 {
		current_object := list[taskKey]
		obj.Traceability = addTraceability(current_object.Traceability, status, machine)
		list[taskKey] = obj
	} else {
		obj.Traceability = addTraceability("Date  Status  Machine", status, machine)
		list[len(list)+1] = obj
	}
    
}

// Function in charge of removing a task from a task list and add it to other one
func deleteTask(name string, listToDo TaskList, listEnded TaskList) {

	taskKey := getTaskKey(name, listToDo)
	obj := listToDo[taskKey]
	listEnded[len(listEnded)+1] = obj
	delete(listToDo, taskKey);
}

// Function to apply a filter to a task list
func (m TaskList) FilterBy(parameter string, fn func(e *Task, n string) bool) TaskList {
	filteredMap := make(map[int]*Task)
	for k, v := range m {
		if fn(v, parameter) {
			filteredMap[k] = v
		}
	}
	return filteredMap
}

// Function in charge of append traceability to a task
func addTraceability(current_data string, status string, machine string) (traceability string){
	traceability = current_data + ` /// ` + time.Now().Format("2006-January-02 15:04:05") + " " + status + " " + machine
	return
}

// Function in charge of return the key of a task in list if exists
func getTaskKey(taskName string, list TaskList) (taskKey int){
	taskKey = -1
	for k, v := range list {
		if v.Name == taskName {
			taskKey = k
			break;
		}
	}
	return
}

// Function that adds tasks to the task list and saves to the block
func (s *SmartContract) Set(ctx contractapi.TransactionContextInterface, taskList string, user string, name string, description string, traceability string, machine string) error {

	if taskList != "ToDo" {
		return fmt.Errorf("Task List not valid. ")
	}

	listAsBytes, err := ctx.GetStub().GetState(taskList)

	if err != nil {
		return fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	if listAsBytes == nil {
		// if task list does not exist then it will be created
		taskListEmpty := TaskList{}

		appendTask(user, name, description, traceability, taskListEmpty, machine)

		taskListEmptyAsBytes, err := json.Marshal(taskListEmpty)

		if err != nil {
			fmt.Printf("Marshal error: %s", err.Error())
			return err
		}

		return ctx.GetStub().PutState(taskList, taskListEmptyAsBytes)
	} 
		// if task list already exist the it will be updated
		taskMap := new(TaskList)

		err = json.Unmarshal(listAsBytes, taskMap)

		if err != nil {
			return fmt.Errorf("Unmarshal error. %s", err.Error())
		}
			
		appendTask(user, name, description, traceability, *taskMap, machine)

		if traceability == "Ended" {

			// if task end the execution then it will move to the ended task list
			listAsBytesEnded, err := ctx.GetStub().GetState("Ended")

			if err != nil {
				return fmt.Errorf("Failed to read from world state. %s", err.Error())
			}
		
			if listAsBytesEnded == nil {
				// if task list does not exist then it will be created
				taskListEnded := TaskList{}

				deleteTask(name, *taskMap, taskListEnded)

				taskListEmptyAsBytes, err := json.Marshal(taskListEnded)

				if err != nil {
					fmt.Printf("Marshal error: %s", err.Error())
					return err
				}
				
				err = ctx.GetStub().PutState("Ended", taskListEmptyAsBytes)

				if err != nil {
					return fmt.Errorf("failed to save on ended list. %v", err)
				}

			} else {

				// if task list already exist the it will be updated
				taskMapEnded := new(TaskList)

				err = json.Unmarshal(listAsBytesEnded, taskMapEnded)

				if err != nil {
					return fmt.Errorf("Unmarshal error 2. %s", err.Error())
				}

				deleteTask(name, *taskMap, *taskMapEnded)
	
				taskAsBytesEnded, err := json.Marshal(taskMapEnded)

				if err != nil {
					fmt.Printf("Marshal error: %s", err.Error())
					return err
				}

				err = ctx.GetStub().PutState("Ended", taskAsBytesEnded)

				if err != nil {
					return fmt.Errorf("failed to save task on ended list. %v", err)
				}
			}
		}

		taskAsBytes, err := json.Marshal(taskMap)

		if err != nil {
			fmt.Printf("Marshal error 1: %s", err.Error())
			return err
		}

		return ctx.GetStub().PutState(taskList, taskAsBytes)
}

// Function in charge of do querys to the current status of the block
func (s *SmartContract) Query(ctx contractapi.TransactionContextInterface, taskListName string, filter string, value string) (string, error) {

	if filter != "user" && filter != "task" && filter != "all" {
		return "", fmt.Errorf("Query unknown operation")
	}

	taskAsBytes, err := ctx.GetStub().GetState(taskListName)

	if err != nil {
		return "", fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	if taskAsBytes == nil {
		return "", fmt.Errorf("%s does not exist", taskListName)
	}

	taskMap := new(TaskList)

	err = json.Unmarshal(taskAsBytes, taskMap)

	if err != nil {
		return "", fmt.Errorf("Unmarshal error. %s", err.Error())
	}

	if filter == "user" || filter == "task" {
		
		filtered := taskMap.FilterBy(value, func(e *Task, list string) bool {
			if filter == "user" {
				if len(e.User) == 0 {
					return false
				}
				return e.User == value
			} 
			if len(e.Name) == 0 {
				return false
			}
			return e.Name == value
		})

		taskListFiltered, err := json.MarshalIndent(filtered, "", "    ")
		if err != nil {
			fmt.Printf("Marshal error: %s", err.Error())
			return "", err
		}

		return string(taskListFiltered), nil
	}

	return string(taskAsBytes), nil
}

func main() {

	chaincode, err := contractapi.NewChaincode(new(SmartContract))

	if err != nil {
		fmt.Printf("Error create taskcontrol chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error starting taskcontrol chaincode: %s", err.Error())
	}

}
