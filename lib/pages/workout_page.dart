import 'package:flutter/material.dart';
import 'package:gitgym/components/exercise_tile.dart';
import 'package:gitgym/data/workout_data.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  //checkBox was tapped
  void onCheckBoxChanged(
    String workoutName,
    String exerciseName,
  ) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  //text controller
  final exerciseNameController = TextEditingController();
  final exerciseWeightController = TextEditingController();
  final exerciseRepsController = TextEditingController();
  final exerciseSetsController = TextEditingController();

  //create new exercise
  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Exercise"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              //Exercise name
              TextField(
                controller: exerciseNameController,
              ),

              //Weight
              TextField(
                controller: exerciseWeightController,
              ),

              //reps
              TextField(
                controller: exerciseRepsController,
              ),

              //sets
              TextField(
                controller: exerciseSetsController,
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: save,
            child: Text("save"),
          ),

          //cancel button
          MaterialButton(
            onPressed: cancel,
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  //save workout
  void save() {
    //get exercise name from the text controller
    String newExerciseName = exerciseNameController.text;
    String weight = exerciseWeightController.text;
    String reps = exerciseRepsController.text;
    String sets = exerciseSetsController.text;

    //add exercise to workout
    Provider.of<WorkoutData>(context, listen: false)
        .addExercise(widget.workoutName, newExerciseName, weight, reps, sets);

    //pop the dialog box
    Navigator.pop(context);
    //clear the dialog box
    clear();
  }

  //cancel workout
  void cancel() {
    //pop the dialog box
    Navigator.pop(context);
    //clear the dialog box
    clear();
  }

  //clear controller i,e: after we hit save we want to clear the controller
  void clear() {
    exerciseNameController.clear();
    exerciseWeightController.clear();
    exerciseRepsController.clear();
    exerciseSetsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(title: Text(widget.workoutName)),
        //create new exercise
        floatingActionButton: FloatingActionButton(
          //for void function we dont need this- () =>
          onPressed: createNewExercise,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.numberOfExercisesInWorkoutList(widget.workoutName),
          itemBuilder: (context, index) => ExerciseTile(
            exerciseName: value
                .getRelevantWorkout(widget.workoutName)
                .exercise[index]
                .name,
            weight: value
                .getRelevantWorkout(widget.workoutName)
                .exercise[index]
                .weight,
            reps: value
                .getRelevantWorkout(widget.workoutName)
                .exercise[index]
                .reps,
            sets: value
                .getRelevantWorkout(widget.workoutName)
                .exercise[index]
                .steps,
            isCompleted: value
                .getRelevantWorkout(widget.workoutName)
                .exercise[index]
                .isCompleted,
            onCheckBoxChanged: (val) => onCheckBoxChanged(
                widget.workoutName,
                value
                    .getRelevantWorkout(widget.workoutName)
                    .exercise[index]
                    .name),
          ),
        ),
      ),
    );
  }
}
