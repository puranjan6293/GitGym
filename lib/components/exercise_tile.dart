import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;

  //check box changed
  void Function(bool?)? onCheckBoxChanged;

  ExerciseTile({
    super.key,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.isCompleted,
    this.onCheckBoxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Vx.green300,
      child: ListTile(
        title: Text(exerciseName),
        subtitle: Row(
          children: [
            //weight
            Chip(
              label: Text(
                "${weight}kg",
              ),
            ),
            //reps
            Chip(
              label: Text(
                "${reps}reps",
              ),
            ),
            //sets
            Chip(
              label: Text(
                "${sets}sets",
              ),
            ),
          ],
        ),
        trailing: Checkbox(
            value: isCompleted,
            onChanged: (value) => onCheckBoxChanged!(value)),
      ),
    );
  }
}
