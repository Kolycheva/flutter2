import 'package:flutter/material.dart';

class PixelsTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Тест касаний',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PixelsTestPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PixelsTestPage extends StatefulWidget {
  @override
  _PixelsTestPageState createState() => _PixelsTestPageState();
}

class _PixelsTestPageState extends State<PixelsTestPage> {
  
  Map<int, Offset> touchPoints = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Тест касаний'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          
          Container(color: Colors.black),
          
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) => _updateTouchPoint(event),
            onPointerMove: (event) => _updateTouchPoint(event),
            onPointerUp: (event) => _removeTouchPoint(event),
            onPointerCancel: (event) => _removeTouchPoint(event),
          ),
          
          ...touchPoints.entries.map((entry) => _buildTouchCircle(entry.value)),
        ],
      ),
    );
  }

  void _updateTouchPoint(PointerEvent event) {
    setState(() {
      touchPoints[event.pointer] = event.position;
    });
  }

  void _removeTouchPoint(PointerEvent event) {
    setState(() {
      touchPoints.remove(event.pointer);
    });
  }

  Widget _buildTouchCircle(Offset position) {
    return Positioned(
      left: position.dx - 40,
      top: position.dy - 40,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}