import 'package:fitness_app/provider/exercise.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseScreenItem extends StatefulWidget {
  const ChooseScreenItem(this.data, {super.key});
  final List<ExerciseItem> data;

  @override
  State<ChooseScreenItem> createState() => _ChooseScreenItemState();
}

class _ChooseScreenItemState extends State<ChooseScreenItem> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.data.length,
      itemBuilder: (ctx, index) {
        return ListTile(
          leading: Checkbox(
            value: widget.data[index].choose,
            onChanged: (value) {
              setState(() {
                widget.data[index].choose = value!;
              });
              if (widget.data[index].choose == true) {
                Provider.of<Exercise>(context, listen: false).addExercise(
                    widget.data[index].name, widget.data[index].choose);
                print(
                    '${Provider.of<Exercise>(context, listen: false).newItem.length}');
              } else if (widget.data[index].choose == false) {
                Provider.of<Exercise>(context, listen: false)
                    .removeExercise(widget.data[index].name);
              }
            },
          ),
          title: Text(widget.data[index].name),
        );
      },
    );
  }
}
