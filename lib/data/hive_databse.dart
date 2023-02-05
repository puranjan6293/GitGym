import 'package:gitgym/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/exercise.dart';
import '../models/workout.dart';

class HiveDatabase {
  //reference our hive box
  final _myBox = Hive.box("workout_database");

  //check if there is already data stored, record the start date
  bool previosDataExists() {
    if (_myBox.isEmpty) {
      print("Previous data doesnot exists");
      _myBox.put("START_DATE", todaysDateYYYYMMDD());

      return false;
    } else {
      print("Previous data exists");
      return true;
    }
  }

  //return the start date as yyyymmdd
  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  //write data
  void saveToDatabase(List<Workout> workouts) {
    //convert workout objects in to list of strings so that we can save in hive
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    //check if any of the exercises have been done
    //we put 0 or 1 for each date
    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 0);
    }

    //save into Hive
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  //read data, and return a list of workouts
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    //create workout objects
    for (int i = 0; i < workoutNames.length; i++) {
      //each workout can have multiple exercises
      List<Exercise> exercisesInEachWorkout = [];

      for (int j = 0; j < exerciseDetails[i].length; j++) {
        //add each exercise in to a list
        exercisesInEachWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            steps: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == "true" ? true : false,
          ),
        );
      }
      //create the individual workout
      Workout workout =
          Workout(name: workoutNames[i], exercise: exercisesInEachWorkout);

      //add individual workout to overal list
      mySavedWorkouts.add(workout);
    }
    return mySavedWorkouts;
  }

  //check if any exercise have been done
  bool exerciseCompleted(List<Workout> workouts) {
    //going through each workout
    for (var workout in workouts) {
      //go through each exercise in workout
      for (var exercise in workout.exercise) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  //return completion status of a given date yyyymmdd
  int getCompletionStatus(String yyyymmdd) {
    //return 0 or 1, if null the return 0
    int completionStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }
}

//converts workout objects into a list
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [];

  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(
      workouts[i].name,
    );
  }
  return workoutList;
}

//converts the exercise in a workout object into a list of strings
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [];

  //go though each workout
  for (int i = 0; i < workouts.length; i++) {
    //get exercise from each workout
    List<Exercise> exerciseInWorkout = workouts[i].exercise;

    List<List<String>> individualWorkout = [];

    //go through each exercise in exercise list
    for (int j = 0; j < exerciseInWorkout.length; j++) {
      List<String> individualExercise = [];
      individualExercise.addAll(
        [
          exerciseInWorkout[j].name,
          exerciseInWorkout[j].weight,
          exerciseInWorkout[j].reps,
          exerciseInWorkout[j].steps,
          exerciseInWorkout[j].isCompleted.toString(),
        ],
      );
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }
  return exerciseList;
}
