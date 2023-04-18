import 'package:fitness_app/provider/set_number_time.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/history.dart';

class DetailHistoryScreen extends StatelessWidget {
  const DetailHistoryScreen({super.key});
  static const router = '/detail-history';

  @override
  Widget build(BuildContext context) {
    final dateTime = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: FutureBuilder(
        future: Provider.of<SetNumber>(context, listen: false)
            .fetchDatabase(dateTime),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? CircularProgressIndicator()
            : Consumer<SetNumber>(
                builder: (ctx, greatPlaces, child) => greatPlaces.item.length <=
                        0
                    ? child!
                    : Container(
                        height: 500,
                        child: ListView.builder(
                          itemCount: greatPlaces.item.length,
                          itemBuilder: (ctx, i) => ListTile(
                            leading: Text(greatPlaces.item[i]!.name),
                            title:
                                Text(greatPlaces.item[i]!.setNumber.toString()),
                            trailing: Text(greatPlaces.item[i]!.time),
                          ),
                        ),
                      ),
                child: Center(
                  child: const Text('Got no places yet, start adding some!'),
                ),
              ),
      ),
    );
  }
}
