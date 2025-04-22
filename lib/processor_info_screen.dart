import 'dart:io'; // Импортируем для работы с файловой системой.
import 'package:flutter/material.dart'; // Импортируем пакет Flutter для работы с материалами (UI-компоненты).
import 'package:device_info_plus/device_info_plus.dart'; // Импортируем пакет для получения информации об устройстве.
import 'package:permission_handler/permission_handler.dart'; // Импортируем пакет для работы с разрешениями.
import 'system_folders_screen.dart'; // Импортируем экран информации о системных папках.
import 'codecs_screen.dart'; // Импортируем экран информации о кодеках.

class ProcessorInfoScreen extends StatefulWidget { // Определяем StatefulWidget для экрана информации о процессоре.
  @override
  _ProcessorInfoScreenState createState() => _ProcessorInfoScreenState(); // Создаем состояние для ProcessorInfoScreen.
}

class _ProcessorInfoScreenState extends State<ProcessorInfoScreen> { // Определяем состояние для экрана информации о процессоре.
  @override
  Widget build(BuildContext context) { // Метод, который строит виджет.
    return Scaffold( // Создаем Scaffold для основной структуры страницы.
      appBar: AppBar( // Создаем верхнюю панель приложения.
        title: Text('Информация о процессоре'), // Заголовок панели.
      ),
      body: FutureBuilder<Map<String, dynamic>>( // Используем FutureBuilder для асинхронной загрузки информации о процессоре.
        future: _getDeviceInfo(), // Асинхронная функция для получения информации о устройстве.
        builder: (context, snapshot) { // Строим виджет в зависимости от состояния загрузки.
          if (snapshot.connectionState == ConnectionState.waiting) { // Если данные все еще загружаются.
            return Center(child: CircularProgressIndicator()); // Показываем индикатор загрузки.
          } else if (snapshot.hasError) { // Если произошла ошибка при загрузке.
            return Center(child: Text('Ошибка: ${snapshot.error}')); // Показываем сообщение об ошибке.
          } else {
            // Извлекаем данные о процессоре.
            String processor = snapshot.data?['processor'] ?? 'Неизвестно';
            String processorModel = snapshot.data?['processorModel'] ?? 'Неизвестно';
            String cpuCores = snapshot.data?['cpuCores'] ?? 'Неизвестно';
            List<String>? cpuFrequencies = snapshot.data?['cpuFrequencies'];
            String? androidId = snapshot.data?['androidId'] ?? 'Неизвестно';
            String? host = snapshot.data?['host'] ?? 'Неизвестно';
            String? bootloader = snapshot.data?['bootloader'] ?? 'Неизвестно';
            String? basebandVersion = snapshot.data?['basebandVersion'] ?? 'Неизвестно';

            return Padding(
              padding: const EdgeInsets.all(16.0), // Отступы вокруг содержимого.
              child: SingleChildScrollView( // Позволяем прокручивать содержимое.
                child: Column( // Столбец для размещения информации о процессоре.
                  crossAxisAlignment: CrossAxisAlignment.start, // Выравнивание по левому краю.
                  children: [
                    _buildInfoCard('Процессор', processor, Icons.memory), // Карточка для информации о процессоре.
                    _buildInfoCard('Модель процессора', processorModel, Icons.developer_board), // Карточка для модели процессора.
                    _buildInfoCard('Количество ядер', cpuCores, Icons.settings_applications), // Карточка для количества ядер.
                    if (cpuFrequencies != null) _buildCpuFrequencyInfo(cpuFrequencies), // Отображаем частоты процессора, если они есть.
                    _buildInfoCard('Идентификатор устройства', androidId ?? 'Неизвестно', Icons.perm_device_info), // Карточка для идентификатора устройства.
                    _buildInfoCard('Хост', host ?? 'Неизвестно', Icons.router), // Карточка для хоста.
                    _buildInfoCard('Загрузчик', bootloader ?? 'Неизвестно', Icons.system_security_update), // Карточка для загрузчика.
                    _buildInfoCard('Версия базовой полосы', basebandVersion ?? 'Неизвестно', Icons.radio), // Карточка для версии базовой полосы.

                    // Кнопки для навигации.
                    SizedBox(height: 20), // Отступ перед кнопками.
                    ElevatedButton.icon( // Кнопка для информации о системных папках.
                      icon: Icon(Icons.folder),
                      onPressed: () {
                        Navigator.push( // Переход на экран системных папок.
                          context,
                          MaterialPageRoute(builder: (context) => SystemFoldersScreen()),
                        );
                      },
                      label: Text('Информация о системных папках'), // Текст на кнопке.
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15), // Отступы внутри кнопки.
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Скругленные углы кнопки.
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Отступ между кнопками.
                    ElevatedButton.icon( // Кнопка для информации о кодеках.
                      icon: Icon(Icons.audiotrack),
                      onPressed: () {
                        Navigator.push( // Переход на экран информации о кодеках.
                          context,
                          MaterialPageRoute(builder: (context) => CodecsScreen()),
                        );
                      },
                      label: Text('Информация о кодеках'), // Текст на кнопке.
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15), // Отступы внутри кнопки.
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Скругленные углы кнопки.
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // Метод для создания карточек с информацией.
  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card( // Карточка для отображения информации.
      margin: const EdgeInsets.symmetric(vertical: 10), // Отступы по вертикали.
      shape: RoundedRectangleBorder( // Оформление карточки.
        borderRadius: BorderRadius.circular(10), // Скругленные углы карточки.
      ),
      child: ListTile( // Элемент списка для карточки.
        leading: Icon(icon, size: 40, color: Color.fromARGB(255, 44, 110, 209)), // Иконка для карточки.
        title: Text( // Заголовок карточки.
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Стиль заголовка.
        ),
        subtitle: Text( // Подзаголовок карточки.
          value,
          style: TextStyle(fontSize: 16), // Стиль текста подзаголовка.
        ),
      ),
    );
  }

  // Метод для создания карточки с информацией о частотах процессора.
  Widget _buildCpuFrequencyInfo(List<String> cpuFrequencies) {
    return Card( // Карточка для отображения информации о частотах.
      margin: const EdgeInsets.symmetric(vertical: 10), // Отступы по вертикали.
      shape: RoundedRectangleBorder( // Оформление карточки.
        borderRadius: BorderRadius.circular(10), // Скругленные углы карточки.
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Внутренние отступы карточки.
        child: Column( // Столбец для размещения информации о частотах.
          crossAxisAlignment: CrossAxisAlignment.start, // Выравнивание по левому краю.
          children: cpuFrequencies.asMap().entries.map((entry) { // Создаем список частот.
            int index = entry.key + 1; // Индекс частоты (начиная с 1).
            String frequency = entry.value; // Значение частоты.
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8), // Отступы по вертикали для каждой частоты.
              child: Text( // Отображаем текст с частотой.
                'Частота ядра $index: $frequency GHz', // Форматированный текст.
                style: TextStyle(fontSize: 16), // Стиль текста.
              ),
            );
          }).toList(), // Преобразуем в список.
        ),
      ),
    );
  }

  // Метод для получения информации о устройстве.
  Future<Map<String, dynamic>> _getDeviceInfo() async {
    await _requestPermissions(); // Запрашиваем необходимые разрешения.

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin(); // Создаем экземпляр DeviceInfoPlugin.
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo; // Получаем информацию о устройстве Android.

    String? processorModel; // Переменная для модели процессора.
    if (androidInfo.supportedAbis.isNotEmpty) { // Проверяем, есть ли поддерживаемые ABI.
      processorModel = androidInfo.supportedAbis.first; // Получаем первую поддерживаемую модель.
    }

    int cpuCores = _getCpuCoreCount(); // Получаем количество ядер процессора.
    List<String> cpuFrequencies = await _getCpuFrequencies(); // Получаем частоты процессора.
    String? basebandVersion = await _getBasebandVersion(); // Получаем версию базовой полосы.

    return { // Возвращаем собранные данные о процессоре.
      'processor': androidInfo.hardware, // Аппаратное обеспечение.
      'processorModel': processorModel ?? 'Неизвестно', // Модель процессора.
      'cpuCores': cpuCores.toString(), // Количество ядер.
      'cpuFrequencies': cpuFrequencies, // Частоты процессора.
      'androidId': androidInfo.id, // Идентификатор Android.
      'host': androidInfo.host, // Хост.
      'bootloader': androidInfo.bootloader, // Загрузчик.
      'basebandVersion': basebandVersion ?? 'Неизвестно', // Версия базовой полосы.
    };
  }

  // Метод для запроса разрешений.
  Future<void> _requestPermissions() async {
    if (await Permission.manageExternalStorage.request().isDenied) { // Запрашиваем разрешение на управление внешним хранилищем.
      ScaffoldMessenger.of(context).showSnackBar( // Показываем SnackBar с сообщением.
        SnackBar(content: Text('Необходимо разрешение для чтения системных файлов')),
      );
    }
  }

  // Метод для получения количества ядер процессора.
  int _getCpuCoreCount() {
    return Platform.numberOfProcessors; // Возвращаем количество процессоров.
  }

  // Метод для получения частот процессора.
  Future<List<String>> _getCpuFrequencies() async {
    List<String> frequencies = []; // Список для хранения частот.
    int coreIndex = 0; // Индекс ядра.
    while (true) { // Бесконечный цикл для получения частот.
      try {
        final frequency = await _readFileAsString( // Читаем частоту из файла.
            '/sys/devices/system/cpu/cpu$coreIndex/cpufreq/cpuinfo_max_freq');
        if (frequency == null) break; // Если частота не найдена, выходим из цикла.
        final frequencyInGHz = (int.parse(frequency) / 1e6).toStringAsFixed(2); // Преобразуем частоту в ГГц.
        frequencies.add(frequencyInGHz); // Добавляем частоту в список.
        coreIndex++; // Увеличиваем индекс ядра.
      } catch (e) {
        break; // Если произошла ошибка, выходим из цикла.
      }
    }
    return frequencies.isEmpty ? ['Неверные данные'] : frequencies; // Возвращаем частоты или сообщение об ошибке.
  }

  // Метод для получения версии базовой полосы.
  Future<String?> _getBasebandVersion() async {
    try {
      ProcessResult result = await Process.run('getprop', ['gsm.version.baseband']); // Получаем версию базовой полосы.
      return result.stdout.trim(); // Возвращаем результат.
    } catch (e) {
      return 'Неизвестно'; // Возвращаем сообщение об ошибке.
    }
  }

  // Метод для чтения файла как строки.
  Future<String?> _readFileAsString(String path) async {
    try {
      final file = File(path); // Создаем объект File для указанного пути.
      if (await file.exists()) { // Проверяем, существует ли файл.
        return await file.readAsString(); // Читаем содержимое файла.
      }
    } catch (e) {
      return null; // Возвращаем null в случае ошибки.
    }
    return null; // Возвращаем null, если файл не существует.
  }
}
