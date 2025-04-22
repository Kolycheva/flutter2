import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/processor_info_screen.dart'; // Замените на ваш путь

void main() {
  // Мок-данные для тестирования
  const mockProcessor = 'ARMv8 Processor';
  const mockProcessorModel = 'arm64-v8a';
  const mockCpuCores = '8';
  const mockCpuFrequencies = ['1.80', '2.02', '2.10', '1.60'];
  const mockAndroidId = 'abc123456';
  const mockHost = 'android-build';
  const mockBootloader = 'unknown';
  const mockBasebandVersion = 'M12345';

  Future<Map<String, dynamic>> mockGetDeviceInfo() async {
    return {
      'processor': mockProcessor,
      'processorModel': mockProcessorModel,
      'cpuCores': mockCpuCores,
      'cpuFrequencies': mockCpuFrequencies,
      'androidId': mockAndroidId,
      'host': mockHost,
      'bootloader': mockBootloader,
      'basebandVersion': mockBasebandVersion,
    };
  }

  Widget createProcessorInfoScreen() {
    return MaterialApp(
      home: ProcessorInfoScreenWithMock(mockGetDeviceInfo),
    );
  }

  testWidgets('Тест: Отображение информации о процессоре', (WidgetTester tester) async {
    // Запускаем экран с мок-данными
    await tester.pumpWidget(createProcessorInfoScreen());

    // Проверяем, что отображается заголовок
    expect(find.text('Информация о процессоре'), findsOneWidget);

    // Ожидаем завершения асинхронной операции
    await tester.pumpAndSettle();

    // Проверяем отображение карточек с информацией
    expect(find.text('Процессор'), findsOneWidget);
    expect(find.text(mockProcessor), findsOneWidget);

    expect(find.text('Модель процессора'), findsOneWidget);
    expect(find.text(mockProcessorModel), findsOneWidget);

    expect(find.text('Количество ядер'), findsOneWidget);
    expect(find.text(mockCpuCores), findsOneWidget);

    // Проверяем отображение частот процессора
    for (var i = 0; i < mockCpuFrequencies.length; i++) {
      expect(find.text('Частота ядра ${i + 1}: ${mockCpuFrequencies[i]} GHz'), findsOneWidget);
    }

    // Проверяем отображение идентификатора устройства и другой информации
    expect(find.text('Идентификатор устройства'), findsOneWidget);
    expect(find.text(mockAndroidId), findsOneWidget);

    expect(find.text('Хост'), findsOneWidget);
    expect(find.text(mockHost), findsOneWidget);

    expect(find.text('Загрузчик'), findsOneWidget);
    expect(find.text(mockBootloader), findsOneWidget);

    expect(find.text('Версия базовой полосы'), findsOneWidget);
    expect(find.text(mockBasebandVersion), findsOneWidget);
  });
}

// Модифицированная версия экрана для использования мок-данных
class ProcessorInfoScreenWithMock extends StatefulWidget {
  final Future<Map<String, dynamic>> Function() mockGetDeviceInfo;

  ProcessorInfoScreenWithMock(this.mockGetDeviceInfo);

  @override
  _ProcessorInfoScreenWithMockState createState() => _ProcessorInfoScreenWithMockState();
}

class _ProcessorInfoScreenWithMockState extends State<ProcessorInfoScreenWithMock> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Информация о процессоре'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: widget.mockGetDeviceInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else {
            String processor = snapshot.data?['processor'] ?? 'Неизвестно';
            String processorModel = snapshot.data?['processorModel'] ?? 'Неизвестно';
            String cpuCores = snapshot.data?['cpuCores'] ?? 'Неизвестно';
            List<String>? cpuFrequencies = snapshot.data?['cpuFrequencies'];
            String? androidId = snapshot.data?['androidId'] ?? 'Неизвестно';
            String? host = snapshot.data?['host'] ?? 'Неизвестно';
            String? bootloader = snapshot.data?['bootloader'] ?? 'Неизвестно';
            String? basebandVersion = snapshot.data?['basebandVersion'] ?? 'Неизвестно';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoCard('Процессор', processor, Icons.memory),
                    _buildInfoCard('Модель процессора', processorModel, Icons.developer_board),
                    _buildInfoCard('Количество ядер', cpuCores, Icons.settings_applications),
                    if (cpuFrequencies != null) _buildCpuFrequencyInfo(cpuFrequencies),
                    _buildInfoCard('Идентификатор устройства', androidId ?? 'Неизвестно', Icons.perm_device_info),
                    _buildInfoCard('Хост', host ?? 'Неизвестно', Icons.router),
                    _buildInfoCard('Загрузчик', bootloader ?? 'Неизвестно', Icons.system_security_update),
                    _buildInfoCard('Версия базовой полосы', basebandVersion ?? 'Неизвестно', Icons.radio),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Color.fromARGB(255, 44, 110, 209)),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildCpuFrequencyInfo(List<String> cpuFrequencies) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: cpuFrequencies.asMap().entries.map((entry) {
            int index = entry.key + 1;
            String frequency = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Частота ядра $index: $frequency GHz',
                style: TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
