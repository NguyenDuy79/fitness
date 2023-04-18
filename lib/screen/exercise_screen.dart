import 'package:fitness_app/provider/exercise.dart';
import 'package:fitness_app/screen/workout_screen.dart';
import 'package:fitness_app/widget/choose_screen_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class ChooseExerciseScreen extends StatefulWidget {
  ChooseExerciseScreen({super.key});
  static const router = '/choose-screen';

  @override
  State<ChooseExerciseScreen> createState() => _ChooseExerciseScreenState();
}

class _ChooseExerciseScreenState extends State<ChooseExerciseScreen> {
  var _editExercise = ExerciseItem(name: '', set: 0, restTime: 0);

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Exercise>(context, listen: false).newItem;
    final exercise = Provider.of<Exercise>(context).item;

    _showDialog(BuildContext context, int count) {
      final _from = GlobalKey<FormState>();
      return showDialog(
          context: context,
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
                          exercise.forEach((element) {
                            element.choose = false;
                          });
                          Navigator.of(context)
                              .pushReplacementNamed(WorkoutScreen.router);
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

    final appBar = AppBar(
      title: const Text('choose'),
    );

    return WillPopScope(
      onWillPop: () async {
        exercise.forEach((element) {
          element.choose = false;
        });
        Provider.of<Exercise>(context, listen: false).newList = [];
        return true;
      },
      child: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.9,
                  child: ChooseScreenItem(
                    exercise,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (data.isEmpty) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Please choose exercise'),
                          duration: Duration(seconds: 2),
                        ));
                      } else {
                        _showDialog(context, counter);
                      }
                    },
                    child: const Text(
                      'Done',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.025,
                )
              ]),
        ),
      ),
    );
  }
}
