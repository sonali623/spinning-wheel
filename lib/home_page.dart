import 'dart:math';

import 'package:flutter/material.dart';

import 'board_view.dart';
import 'model.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  double _angle = 0;
  double _current = 0;
  AnimationController _ctrl;
  Animation _ani;
  List<Luck> _items = [
    Luck("apple", Colors.accents[0],"Eat Healthy"),
    Luck("family", Colors.accents[2],"Spend time with Family"),
    Luck("workout", Colors.accents[12],"Do some Yoga"),
    Luck("friends", Colors.accents[6],"Go play with friends"),
    Luck("collaboration", Colors.accents[8],"Help someone in need"),
    //Luck("milk", Colors.accents[8]),
    Luck("meditation", Colors.accents[10],"Relax and meditate"),
   // Luck("cheese", Colors.accents[4]),
    //Luck("carrot", Colors.accents[14]),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var _duration = Duration(milliseconds: 5000);
    _ctrl = AnimationController(vsync: this, duration: _duration);
    _ani = CurvedAnimation(parent: _ctrl, curve: Curves.fastLinearToSlowEaseIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green, Colors.blue.withOpacity(0.2)])),
        child: AnimatedBuilder(
            animation: _ani,
            builder: (context, child) {
              final _value = _ani.value;
              final _angle = _value * this._angle;
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  BoardView(items: _items, current: _current, angle: _angle),
                  _buildGo(),
                  _buildResult(_value),
                ],
              );
            }),
      ),
    );
  }

  _buildGo() {
    return Material(
      color: Colors.white,
      shape: CircleBorder(),
      child: InkWell(
        customBorder: CircleBorder(),
        child: Container(
          alignment: Alignment.center,
          height: 72,
          width: 72,
          child: Text(
            "GO",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: _animation,
      ),
    );
  }

  _animation() {
    if (!_ctrl.isAnimating) {
      var _random = Random().nextDouble();
      _angle = 20 + Random().nextInt(5) + _random;
      _ctrl.forward(from: 0.0).then((_) {
        _current = (_current + _random);
        _current = _current - _current ~/ 1;
        _ctrl.reset();
      });
    }
  }

  int _calIndex(value) {
    var _base = (2 * pi / _items.length / 2) / (2 * pi);
    return (((_base + value) % 1) * _items.length).floor();
  }

  _buildResult(_value) {
    var _index = _calIndex(_value * _angle + _current);
    String task = _items[_index].task;
    String _asset = _items[_index].asset;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          children: <Widget>[
            SizedBox(width: 15.0,),
            Image.asset(_asset, height: 80.0, width: 80.0),
            SizedBox(height: 5.0,),
            Text(task,style: TextStyle(fontSize: 18.0),),
          ],
        ),
      ),
    );
  }
}
