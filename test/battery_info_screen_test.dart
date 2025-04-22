import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/battery_info_screen.dart'; // Замените на путь к вашему файлу
import 'package:battery_plus/battery_plus.dart';

void main() {
  // Мокируем данные для уровня заряда и состояния батареи
  const int mockBatteryLevel = 75;
  const BatteryState mockBatteryState = BatteryState.discharging;
  const double mockBatteryTemperature = 30.0;
  const double mockBatteryVoltage = 4.2;

  // Мок-функции для замены реальных данных батареи
  Future<int> mockGetBatteryLevel() async {
    return mockBatteryLevel;
  }

  Future<BatteryState> mockGetBatteryState() async {
    return mockBatteryState;
  }

  Future<double> mockGetBatteryTemperature() async {
    return mockBatteryTemperature;
  }

  Future<double> mockGetBatteryVoltage() async {
    return mockBatteryVoltage;
  }

  Widget createBatteryInfoScreen() {
    return MaterialApp(
      home: BatteryInfoScreenWithMock(
        mockGetBatteryLevel: mockGetBatteryLevel,
        mockGetBatteryState: mockGetBatteryState,
        mockGetBatteryTemperature: mockGetBatteryTemperature,
        mockGetBatteryVoltage: mockGetBatteryVoltage,
      ),
    );
  }

  testWidgets('Тест: Отображение основных элементов интерфейса и данных батареи', (WidgetTester tester) async {
    // Запускаем экран с мок-данными
    await tester.pumpWidget(createBatteryInfoScreen());

    // Ожидаем завершения перерисовки экрана после обновления данных батареи
    await tester.pumpAndSettle();

    // Проверяем, что заголовок экрана отображается
    expect(find.text('Информация об аккумуляторе'), findsOneWidget);

    // Проверяем, что индикатор заряда батареи отображает корректные данные
    expect(find.text('$mockBatteryLevel%'), findsOneWidget);

    // Проверяем наличие карточки состояния батареи
    expect(find.text('Состояние'), findsOneWidget);
    expect(find.text('Разряжается'), findsOneWidget); // Мокированные данные

    // Проверяем наличие карточки температуры батареи
    expect(find.text('Температура'), findsOneWidget);
    expect(find.text('$mockBatteryTemperature°C'), findsOneWidget);

    // Проверяем наличие карточки напряжения батареи
    expect(find.text('Напряжение'), findsOneWidget);
    expect(find.text('$mockBatteryVoltage V'), findsOneWidget);

    // Проверяем, что кнопка обновления отображается с правильным текстом
    expect(find.text('Обновить информацию'), findsOneWidget);
  });
}

// Модифицированная версия экрана, чтобы использовать мок-данные для тестирования
class BatteryInfoScreenWithMock extends StatefulWidget {
  final Future<int> Function() mockGetBatteryLevel;
  final Future<BatteryState> Function() mockGetBatteryState;
  final Future<double> Function() mockGetBatteryTemperature;
  final Future<double> Function() mockGetBatteryVoltage;

  BatteryInfoScreenWithMock({
    required this.mockGetBatteryLevel,
    required this.mockGetBatteryState,
    required this.mockGetBatteryTemperature,
    required this.mockGetBatteryVoltage,
  });

  @override
  _BatteryInfoScreenWithMockState createState() =>
      _BatteryInfoScreenWithMockState();
}

class _BatteryInfoScreenWithMockState extends State<BatteryInfoScreenWithMock> {
  int _batteryLevel = 0;
  BatteryState _batteryState = BatteryState.unknown;
  double _batteryTemperature = 0.0;
  double _batteryVoltage = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getBatteryInfo();
  }

  Future<void> _getBatteryInfo() async {
    final batteryLevel = await widget.mockGetBatteryLevel();
    final batteryState = await widget.mockGetBatteryState();
    final batteryTemperature = await widget.mockGetBatteryTemperature();
    final batteryVoltage = await widget.mockGetBatteryVoltage();

    if (mounted) {
      setState(() {
        _batteryLevel = batteryLevel;
        _batteryState = batteryState;
        _batteryTemperature = batteryTemperature;
        _batteryVoltage = batteryVoltage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Информация об аккумуляторе'),
        backgroundColor: Colors.blueGrey[900],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: CircularProgressIndicator(
                      value: _batteryLevel / 100,
                      strokeWidth: 12,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getBatteryLevelColor(_batteryLevel),
                      ),
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  Text(
                    '$_batteryLevel%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getBatteryLevelColor(_batteryLevel),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            _buildInfoCard(
              title: 'Состояние',
              value: _getBatteryStateDescription(_batteryState),
              icon: Icons.power,
              backgroundColor: Colors.orange[100],
            ),
            SizedBox(height: 20),
            _buildInfoCard(
              title: 'Температура',
              value: '$_batteryTemperature°C',
              icon: Icons.thermostat,
              backgroundColor: Color.fromARGB(255, 44, 110, 209),
            ),
            SizedBox(height: 20),
            _buildInfoCard(
              title: 'Напряжение',
              value: '$_batteryVoltage V',
              icon: Icons.electrical_services,
              backgroundColor: Colors.purple[100],
            ),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: _getBatteryInfo,
                icon: Icon(Icons.refresh),
                label: Text(
                  'Обновить информацию',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 44, 110, 209),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getBatteryStateDescription(BatteryState state) {
    switch (state) {
      case BatteryState.charging:
        return 'Заряжается';
      case BatteryState.discharging:
        return 'Разряжается';
      case BatteryState.full:
        return 'Полный заряд';
      case BatteryState.unknown:
      default:
        return 'Неизвестно';
    }
  }

  Color _getBatteryLevelColor(int level) {
    if (level > 75) {
      return Colors.green;
    } else if (level < 20) {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color? backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.blueGrey[800]),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey[800],
                ),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
