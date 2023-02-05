import 'package:flutter/material.dart';
import 'package:gitgym/data/workout_data.dart';
import 'package:gitgym/pages/workout_page.dart';
import 'package:provider/provider.dart';

import '../components/hit_map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  //Text controller
  final newWorkoutNameController = TextEditingController();

  //create a new workout
  void createNewWorkout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Create new workout"),
              content: TextField(
                controller: newWorkoutNameController,
              ),
              actions: [
                //save button
                MaterialButton(
                  onPressed: save,
                  child: Text("save"),
                ),

                //cancel button
                MaterialButton(
                  onPressed: cancel,
                  child: Text("Cancel"),
                )
              ],
            ));
  }

  //go to workout page
  void goToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutPage(
            workoutName: workoutName,
          ),
        ));
  }

  //save workout
  void save() {
    //get workout name from the text controller
    String newWorkoutName = newWorkoutNameController.text;
    //add workout to workout data list
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

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
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text("GitGym"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            //Heat Map
            MyHeatMap(
                datasets: value.heatMapDataSet,
                startdateYYYYMMDD: value.getStartDate()),

            //Workout List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: value.getWorkoutList().length,
              itemBuilder: (context, index) => ListTile(
                //going through the workout list just print the workout name
                title: Text(value.getWorkoutList()[index].name),
                //after clicking on tiles, going to individual workout
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () =>
                      goToWorkoutPage(value.getWorkoutList()[index].name),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
