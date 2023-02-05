import 'package:flutter/cupertino.dart';
import 'package:gitgym/datetime/date_time.dart';
import 'package:gitgym/models/exercise.dart';
import 'package:gitgym/models/workout.dart';
import 'hive_databse.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();
  /*
  WORKOUT DATA STRUCTURE
   - This overal list contains the different workouts
   - Each workout has a name, and list of exercises
  */

  List<Workout> workoutList = [
    //default workout
    Workout(
      name: "Upper Body",
      exercise: [
        Exercise(name: "Bicep Curls", weight: "10", reps: "10", steps: "3"),
      ],
    ),
  ];

  //if there are workouts already in database, then get the workout list

  void initializeWorkoutList() {
    if (db.previosDataExists()) {
      workoutList = db.readFromDatabase();
    }
    //otherwise just return the default workout
    else {
      db.saveToDatabase(workoutList);
    }

    //load heat map
    loadHeatMap();
  }

  //get the list of workout
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  //getting the length of the workout
  int numberOfExercisesInWorkoutList(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercise.length;
  }

  //add a work out
  void addWorkout(String name) {
    //add a new workout with a blank list of exercises
    workoutList.add(Workout(name: name, exercise: []));

    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
  }

  //add an exercise in a workout
  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String steps) {
    //find the relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    relevantWorkout.exercise.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, steps: steps));

    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
  }

  //check of the exercise
  void checkOffExercise(String workoutName, String exerciseName) {
    //find the relevant workout and relevant workout in that list
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    //check off option to show user completed the exercise
    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);

    //load heat map
    loadHeatMap();
  }

  //return the relevant workout object , given a workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);

    return relevantWorkout;
  }

  //return the relevant exercise object , given a workout name + exercise name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    //find relevant workout first
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    //then find the relevant exercise
    Exercise relevantExercise = relevantWorkout.exercise
        .firstWhere((exercise) => exercise.name == exerciseName);
    return relevantExercise;
  }

  //get start date
  String getStartDate() {
    return db.getStartDate();
  }

  //Heatmap dataset
  Map<DateTime, int> heatMapDataSet = {};

  //function for loading the heatmap
  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(getStartDate());

    //count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    //go from start date to today, and add each completion status to the dataset
    //"COMPLETION_STATUS_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd =
          convertDateTimeToYYYYMMDD(startDate.add(Duration(days: i)));

      //completion status = 0 or 1
      int completionStatus = db.getCompletionStatus(yyyymmdd);

      //year
      int year = startDate.add(Duration(days: i)).year;
      //month
      int month = startDate.add(Duration(days: i)).month;
      //day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): completionStatus
      };
      //add to the heatMap dataset
      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}
