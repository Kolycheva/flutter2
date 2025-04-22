import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart'; // Импортируем нужную библиотеку для получения информации о процессоре
import 'package:permission_handler/permission_handler.dart'; // Импортируем библиотеку для работы с разрешениями
import 'package:flutter/services.dart' show rootBundle; // Импортируем для загрузки шрифтов
import 'dart:async';
import 'processor_info_screen.dart'; // Импортируем экран с информацией о процессоре

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool _reportGenerated = false;
  File? _pdfFile;
  pw.Font? _customFont; // Для хранения шрифта

  @override
  void initState() {
    super.initState();
    _requestPermissions(); // Запрашиваем разрешения на запись
    _loadFont(); // Загружаем шрифт
  }

  // Функция для загрузки шрифта
  Future<void> _loadFont() async {
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);
    setState(() {
      _customFont = ttf;
    });
  }

  // Запрос разрешений на запись
  Future<void> _requestPermissions() async {
    await Permission.storage.request();
  }

  // Функция для генерации PDF отчета
  Future<void> _generateReport() async {
    if (_customFont == null) {
      // Шрифт еще не загружен
      return;
    }

    // Создаем PDF-документ
    final pdf = pw.Document();

    // Получаем информацию с ProcessorInfoScreen
    final processorInfo = await _getProcessorInfo();

    // Добавляем содержимое в PDF с использованием кастомного шрифта
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Отчет о процессоре',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, font: _customFont),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Информация о процессоре:', style: pw.TextStyle(fontSize: 18, font: _customFont)),
                pw.SizedBox(height: 10),
                pw.Text(processorInfo, style: pw.TextStyle(font: _customFont)), // Информация о процессоре
              ],
            ),
          );
        },
      ),
    );

    // Сохранение PDF файла
    final directory = Directory('/storage/emulated/0/DCIM');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true); // Создаем директорию, если её нет
    }
    final path = '${directory.path}/report.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    setState(() {
      _reportGenerated = true; // Отчет сформирован
      _pdfFile = file; // Сохраняем файл в состояние
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Отчет сохранен по пути: $path')),
    );
  }

  // Функция для получения информации о процессоре с ProcessorInfoScreen
  Future<String> _getProcessorInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    int cpuCores = Platform.numberOfProcessors;
    List<String> cpuFrequencies = await _getCpuFrequencies();
    String? basebandVersion = await _getBasebandVersion();

    String processor = androidInfo.hardware ?? 'Неизвестно';
    String processorModel = androidInfo.supportedAbis.isNotEmpty ? androidInfo.supportedAbis.first : 'Неизвестно';
    String cpuCoresText = cpuCores.toString();
    String cpuFrequenciesText = cpuFrequencies.join(', ');
    String androidId = androidInfo.id ?? 'Неизвестно';
    String host = androidInfo.host ?? 'Неизвестно';
    String bootloader = androidInfo.bootloader ?? 'Неизвестно';

    return '''
Процессор: $processor
Модель процессора: $processorModel
Количество ядер: $cpuCoresText
Частоты ядер: $cpuFrequenciesText
Идентификатор устройства: $androidId
Хост: $host
Загрузчик: $bootloader
Версия базовой полосы: ${basebandVersion ?? 'Неизвестно'}
''';
  }

  Future<List<String>> _getCpuFrequencies() async {
    List<String> frequencies = [];
    int coreIndex = 0;
    while (true) {
      try {
        final frequency = await _readFileAsString(
            '/sys/devices/system/cpu/cpu$coreIndex/cpufreq/cpuinfo_max_freq');
        if (frequency == null) break;
        final frequencyInGHz = (int.parse(frequency) / 1e6).toStringAsFixed(2);
        frequencies.add(frequencyInGHz);
        coreIndex++;
      } catch (e) {
        break;
      }
    }
    return frequencies.isEmpty ? ['Неверные данные'] : frequencies;
  }

  Future<String?> _readFileAsString(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<String?> _getBasebandVersion() async {
    try {
      ProcessResult result = await Process.run('getprop', ['gsm.version.baseband']);
      return result.stdout.trim();
    } catch (e) {
      return 'Неизвестно';
    }
  }

  // Функция для загрузки PDF-файла
  Future<void> _downloadReport() async {
    if (_pdfFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Отчет скачан: ${_pdfFile!.path}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Отчеты'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _generateReport,
              child: Text('Формировать отчет'),
            ),
            SizedBox(height: 20),
            if (_reportGenerated)
              ElevatedButton(
                onPressed: _downloadReport,
                child: Text('Скачать отчет'),
              ),
          ],
        ),
      ),
    );
  }
}
