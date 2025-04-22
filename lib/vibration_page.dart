import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class vibro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VibrationTestScreen(),
    );
  }
}

class VibrationTestScreen extends StatelessWidget {

  Future<void> _checkVibration() async {
    
    if (await Vibration.hasVibrator() ?? false) {
      
      await Vibration.vibrate(
        duration: 500, 
      );
    } else {
      
      print("Вибрация недоступна на этом устройстве");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Проверка вибрации'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _checkVibration,
          child: Text('Проверить вибрацию'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}