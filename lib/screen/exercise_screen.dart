import 'package:fitness_app/provider/exercise.dart';
import 'package:fitness_app/screen/workout_screen.dart';
import 'package:fitness_app/widget/choose_screen_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseExerciseScreen extends StatefulWidget {
  ChooseExerciseScreen({super.key});

  @override
  State<ChooseExerciseScreen> createState() => _ChooseExerciseScreenState();
}

class _ChooseExerciseScreenState extends State<ChooseExerciseScreen> {
  var _editExercise = ExerciseItem(name: '', set: 0, restTime: 0);

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Exercise>(context, listen: false).newItem;

    _showDialog(BuildContext context, int count) {
      final _from = GlobalKey<FormState>();
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            return AlertDialog(
                scrollable: true,
                title: Text(data[count].name),
                content: Form(
                  key: _from,
                  child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Set'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter set.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a number greater than zero.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editExercise = ExerciseItem(
                              name: data[count].name,
                              set: double.parse(value!).toInt(),
                              restTime: _editExercise.restTime,
                              choose: data[count].choose);
                        },
                      ),
                      TextFormField(
                          decoration: InputDecoration(labelText: 'Rest Time'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Rest time.';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number.';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Please enter a number greater than zero.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editExercise = ExerciseItem(
                                name: data[count].name,
                                set: _editExercise.set,
                                restTime: double.parse(value!).toInt(),
                                choose: data[count].choose);
                          })
                    ]),
                  ),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        final isValid = _from.currentState!.validate();
                        if (!isValid) {
                          return;
                        }
                        _from.currentState!.save();
                        Provider.of<Exercise>(context, listen: false)
                            .updateExercise(_editExercise);
                        print('${data[count].restTime}');

                        Navigator.of(ctx).pop();
                        setState(() {
                          counter++;
                        });
                        print('$counter');
                        if (counter == data.length) {
                          Navigator.of(context).pushNamed(WorkoutScreen.router);
                          setState(() {
                            counter = 0;
                          });
                        } else {
                          _showDialog(context, counter);
                        }
                      },
                      child: Text('next'))
                ]);
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Choose'),
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ChooseScreenItem(),
              ElevatedButton(
                  onPressed: () => _showDialog(context, counter),
                  child: Text(
                    'Done',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ))
            ]),
      ),
    );
  }
}
