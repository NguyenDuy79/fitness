import 'package:fitness_app/provider/exercise.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseScreenItem extends StatefulWidget {
  const ChooseScreenItem({super.key});

  @override
  State<ChooseScreenItem> createState() => _ChooseScreenItemState();
}

class _ChooseScreenItemState extends State<ChooseScreenItem> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Exercise>(context, listen: false).item;

    return Container(
      height: 600,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            leading: Checkbox(
              value: data[index].choose,
              onChanged: (value) {
                setState(() {
                  data[index].choose = value!;
                });
                if (data[index].choose == true) {
                  Provider.of<Exercise>(context, listen: false)
                      .addExercise(data[index].name, data[index].choose);
                  print(
                      '${Provider.of<Exercise>(context, listen: false).newItem.length}');
                } else if (data[index].choose == false) {
                  Provider.of<Exercise>(context, listen: false)
                      .removeExercise(data[index].name);
                }
              },
            ),
            title: Text(data[index].name),
          );
        },
      ),
    );
  }
}
