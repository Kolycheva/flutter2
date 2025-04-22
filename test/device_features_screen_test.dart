import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/device_features_screen.dart'; // Путь к вашему файлу

void main() {
  // Мокируем данные для устройства
  List<String> mockDeviceFeatures = [
    'android.hardware.camera',
    'android.hardware.bluetooth',
    'android.hardware.wifi'
  ];

  // Функция, которая заменит реальный запрос данных с устройством
  Future<List<String>> mockGetDeviceFeatures() async {
    return mockDeviceFeatures;
  }

  // Обертка для использования нашего мокированного метода
  Widget createDeviceFeaturesScreen() {
    return MaterialApp(
      home: DeviceFeaturesScreenWithMock(mockGetDeviceFeatures), // Используем экран с мок-данными
    );
  }

  testWidgets('Тест: Отображение списка поддерживаемых функций устройства', (WidgetTester tester) async {
    // Запускаем экран с мокированными данными
    await tester.pumpWidget(createDeviceFeaturesScreen());

    // Проверяем, что отображается заголовок секции
    expect(find.text('Поддерживаемые функции'), findsOneWidget);

    // Пока данные загружаются, должен отображаться CircularProgressIndicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Завершаем загрузку данных
    await tester.pumpAndSettle(); // Ожидаем завершения всех асинхронных операций

    // Проверяем, что мокированные функции отображаются корректно
    for (String feature in mockDeviceFeatures) {
      expect(find.text(feature), findsOneWidget);
    }

    // Проверяем, что индикатор загрузки исчез после завершения загрузки данных
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}

// Модифицированная версия экрана, чтобы использовать мок-данные
class DeviceFeaturesScreenWithMock extends StatelessWidget {
  final Future<List<String>> Function() getDeviceFeatures;

  DeviceFeaturesScreenWithMock(this.getDeviceFeatures);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Функции устройства'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Поддерживаемые функции', Icons.info),
              Divider(),
              _buildFeaturesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 28, color: Color.fromARGB(255, 44, 110, 209)),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection() {
    return FutureBuilder<List<String>>(
      future: getDeviceFeatures(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        } else {
          List<String> features = snapshot.data ?? [];
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.check, color: Color.fromARGB(255, 44, 110, 209)),
                  title: Text(feature),
                ),
              );
            },
          );
        }
      },
    );
  }
}
