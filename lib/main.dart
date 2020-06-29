import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      // home: ChannelClass(),
      home: PlayerList(),
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: Text('Prediction'),
      //   ),
      //   body: Center(
      //     child: HomeSL(),
      //   ),
      // ),
    );
  }
}

class ChannelClass extends StatefulWidget {
  @override
  _ChannelClassState createState() => _ChannelClassState();
}

class _ChannelClassState extends State<ChannelClass> {
  static const platform = const MethodChannel('EnglishChannel');
  String _result = 'let me think ...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Philosophy'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () async {
                _result =
                    await platform.invokeMethod('isGrassGreenerOnTheOtherSide');
                setState(() {});
              },
              child: Text('Is grass greener on the other side?'),
            ),
            Text(_result),
          ],
        ),
      ),
    );
  }
}

class HomeSF extends StatefulWidget {
  @override
  _HomeSFState createState() => _HomeSFState();
}

class _HomeSFState extends State<HomeSF> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CounterWidget(
          callback: (String data) {
            setState(() {});
          },
        ),
        Container(
          width: 100,
          height: 100,
          color: randomColor(),
        )
      ],
    );
  }
}

class HomeSL extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CounterWidget(
          callback: (String data) {
            print('Data = $data');
          },
        ),
        Container(
          width: 100,
          height: 100,
          color: randomColor(),
        )
      ],
    );
  }
}

class CounterWidget extends StatefulWidget {
  CounterWidget({@required this.callback});
  final PredictionCallback callback;

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  // Timer _timer;
  String _prediction = "You'll live the life of a commoner";

  String fetchPrediction() {
    int rand = math.Random().nextInt(2);
    String pred =
        rand == 0 ? 'live for 1000 years, kind one.' : 'perish tonight, worm.';
    return "You'll $pred";
  }

  void startFetchData() {
    const delay = const Duration(seconds: 3);
    Timer.periodic(
      delay,
      (Timer timer) {
        _prediction = fetchPrediction();
        widget.callback(_prediction);
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startFetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Center(
        child: Text(
          _prediction,
          style: TextStyle(fontSize: 24),
        ),
      ),
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
    int rand = math.Random().nextInt(4);
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

typedef void PredictionCallback(String data);
Color randomColor() {
  return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
      .withOpacity(1.0);
}

bool isEarthFlat() {
  return true;
}
