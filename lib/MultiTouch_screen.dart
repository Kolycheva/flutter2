
import 'package:flutter/material.dart';

class MultiTouchCounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Счётчик касаний',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MultiTouchCounter(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MultiTouchCounter extends StatefulWidget {
  @override
  _MultiTouchCounterState createState() => _MultiTouchCounterState();
}

class _MultiTouchCounterState extends State<MultiTouchCounter> {
  int _touchCount = 0;
  final Map<int, PointerEvent> _activePointers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Тест мультитача'),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) {
              _activePointers[event.pointer] = event;
              _updateCounter();
            },
            onPointerMove: (event) {
              _activePointers[event.pointer] = event;
            },
            onPointerUp: (event) {
              _activePointers.remove(event.pointer);
              _updateCounter();
            },
            onPointerCancel: (event) {
              _activePointers.remove(event.pointer);
              _updateCounter();
            },
          ),
          
          
          Center(
            child: Text(
              'Касаний: $_touchCount',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateCounter() {
    final newCount = _activePointers.length;
    if (newCount != _touchCount) {
      setState(() {
        _touchCount = newCount;
      });
    }
  }
}