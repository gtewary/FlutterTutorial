import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: PlayerList(),
    );
  }
}

class PlayerList extends StatefulWidget {
  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  TextEditingController _controller = TextEditingController();

  List<String> movieList = [
    'Fight club',
    'Roman holiday',
    'Green mile',
    'Taxi driver',
    'Kite runner',
    'The bicycle thief',
    'The pianist',
    'The machinist',
    'Seven samurai',
    'A seperation',
    '12 angry men',
    'To kill a mockingbird',
    'Eternal sunshine of the spotless mind',
    'The good, the bad, and the ugly',
    'Lord of the rings'
  ];

  String _getFeedback() {
    String feedback;
    int rand = Random().nextInt(4);
    switch (rand) {
      case 0:
        feedback = 'good';
        break;
      case 1:
        feedback = 'superb';
        break;
      case 2:
        feedback = 'exemplary';
        break;
      default:
        feedback = 'terrible';
        break;
    }

    return feedback;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_box),
            onPressed: () async {
              await showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  contentPadding: const EdgeInsets.all(16.0),
                  content: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: _controller,
                          autofocus: true,
                          autocorrect: false,
                          decoration: InputDecoration(
                            labelText: 'Enter your favourite movie',
                            hintText: 'eg. The girl next door',
                          ),
                        ),
                      )
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    FlatButton(
                        child: const Text('Confirm'),
                        onPressed: () {
                          setState(() {
                            movieList.insert(0, _controller.text);
                            _controller.text = '';
                          });
                          Navigator.pop(context);
                        })
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          print(orientation);
          if (orientation == Orientation.portrait) {
            return SafeArea(
              child: ListView.separated(
                itemCount: movieList.length,
                itemBuilder: (BuildContext context, int index) {
                  return MovieRow(
                    title: movieList[index],
                    subtitle: _getFeedback() != null
                        ? '${movieList[index]} is a ${_getFeedback()} movie'
                        : '',
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 1.0,
                    color: Colors.indigo,
                  );
                },
              ),
            );
          } else {
            return SafeArea(
              child: GridView.count(
                childAspectRatio: 2,
                crossAxisCount: MediaQuery.of(context).size.width /
                            MediaQuery.of(context).size.height >
                        1.5
                    ? 4
                    : 3,
                children: movieList
                    .map(
                      (movie) => MovieRow(
                        title: movie,
                        subtitle: _getFeedback() != null
                            ? '$movie is a ${_getFeedback()} movie'
                            : '',
                      ),
                    )
                    .toList(),
              ),
            );
          }
        },
      ),
    );
  }
}

class MovieRow extends StatelessWidget {
  MovieRow({this.title, this.subtitle});
  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        color: Colors.red,
        child: Column(
          children: <Widget>[
            Text(
              title,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            FittedBox(
              child: Text(
                (subtitle == null || subtitle.length == 0)
                    ? '$title stinks'
                    : subtitle,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
      ),
    );
  }
}
