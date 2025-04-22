import 'package:flutter/material.dart';
import 'system_info_helper.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class SystemInfoScreen extends StatelessWidget {
  // Метод для копирования текста в буфер обмена
  void _copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Скопировано в буфер обмена')),
    );
  }

  // Метод для генерации и сохранения PDF
  Future<void> _saveAsPdf(Map<String, String> data) async {
    // Проверяем и запрашиваем разрешения
    if (await Permission.storage.request().isGranted) {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: data.entries.map((entry) {
                  return pw.Text('${entry.key}: ${entry.value}');
                }).toList(),
              ),
            );
          },
        ),
      );

      // Получаем путь для сохранения файла
      final output = Directory('/storage/emulated/0/DCIM');
      final file = File('${output.path}/system_info.pdf');
      await file.writeAsBytes(await pdf.save());

      print('Файл сохранен по пути: ${file.path}');
    } else {
      print('Разрешение на запись не предоставлено.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Информация о системе'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, String>>(
        future: Future.wait([getMemoryInfo(), getSystemInfo()]).then((results) {
          return {
            ...results[0],
            ...results[1],
          };
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else {
            Map<String, String> data = snapshot.data ?? {};

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpansionTile(
                      title: Text(
                        'Память',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 44, 110, 209),
                        ),
                      ),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Тип ОЗУ: ${data['ramType']}', style: TextStyle(fontSize: 16, color: Colors.black)),
                              SizedBox(height: 8),
                              Text('Объем ОЗУ: ${data['totalRamGB']}', style: TextStyle(fontSize: 16, color: Colors.black)),
                              SizedBox(height: 8),
                              Text('Свободная ОЗУ: ${data['freeRamGB']}', style: TextStyle(fontSize: 16, color: Colors.black)),
                              SizedBox(height: 8),
                              Text('Свободное хранилище: ${data['freeStorageGB']}', style: TextStyle(fontSize: 16, color: Colors.black)),
                              SizedBox(height: 8),
                              Text('Общее хранилище: ${data['totalStorageGB']}', style: TextStyle(fontSize: 16, color: Colors.black)),
                              SizedBox(height: 8),
                              Text('Технология: ${data['storageTechnology']}', style: TextStyle(fontSize: 16, color: Colors.black)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _copyToClipboard(
                            'Тип ОЗУ: ${data['ramType']}\n'
                            'Объем ОЗУ: ${data['totalRamGB']} ГБ\n'
                            'Свободная ОЗУ: ${data['freeRamGB']} ГБ\n'
                            'Свободное хранилище: ${data['freeStorageGB']} ГБ\n'
                            'Общее хранилище: ${data['totalStorageGB']} ГБ\n'
                            'Технология хранения: ${data['storageTechnology']}',
                            context,
                          ),
                          child: Text('Копировать данные о памяти'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 44, 110, 209),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ExpansionTile(
                      title: Text(
                        'Система',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 44, 110, 209),
                        ),
                      ),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Версия Android: ${data['androidVersion']}', style: TextStyle(fontSize: 16, color: Colors.black)),
                              SizedBox(height: 8),
                              Text('Модель устройства: ${data['deviceModel']}', style: TextStyle(fontSize: 16, color: Colors.black)),
                              SizedBox(height: 8),
                              Text('Производитель: ${data['manufacturer']}', style: TextStyle(fontSize: 16, color: Colors.black)),
                              SizedBox(height: 8),
                              Text('Название устройства: ${data['deviceName']}', style: TextStyle(fontSize: 16, color: Colors.black)),
                              SizedBox(height: 8),
                              Text('Версия SDK: ${data['androidSdkInt']}', style: TextStyle(fontSize: 16, color: Colors.black)),
                              SizedBox(height: 8),
                              Text('Плата: ${data['board']}', style: TextStyle(fontSize: 16, color: Colors.black)),
                              SizedBox(height: 8),
                              Text('Дисплей: ${data['display']}', style: TextStyle(fontSize: 16, color: Colors.black)),
                              SizedBox(height: 8),
                              Text('Разрешение: ${data['resolution']}', style: TextStyle(fontSize: 16, color: Colors.black)),
                              SizedBox(height: 8),
                              Text('Плотность: ${data['density']}', style: TextStyle(fontSize: 16, color: Colors.black)),
                              SizedBox(height: 8),
                              Text('Частота обновления: ${data['refreshRate']}', style: TextStyle(fontSize: 16, color: Colors.black)),
                              SizedBox(height: 8),
                              Text('HDR: ${data['hdr']}', style: TextStyle(fontSize: 16, color: Colors.black)),
                              SizedBox(height: 8),
                              Text('Размер телефона: ${data['phoneSize']}', style: TextStyle(fontSize: 16, color: Colors.black)),
                              SizedBox(height: 8),
                              Text('Вес телефона: ${data['weight']}', style: TextStyle(fontSize: 16, color: Colors.black)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _copyToClipboard(
                            'Версия Android: ${data['androidVersion']}\n'
                            'Модель устройства: ${data['deviceModel']}\n'
                            'Производитель: ${data['manufacturer']}\n'
                            'Название устройства: ${data['deviceName']}\n'
                            'Версия SDK: ${data['androidSdkInt']}\n'
                            'Плата: ${data['board']}\n'
                            'Дисплей: ${data['display']}\n'
                            'Разрешение экрана: ${data['resolution']}\n'
                            'Плотность пикселей: ${data['density']}\n'
                            'Частота обновления: ${data['refreshRate']} Гц\n'
                            'HDR: ${data['hdr']}\n'
                            'Размер телефона: ${data['phoneSize']}\n'
                            'Вес телефона: ${data['weight']} г',
                            context,
                          ),
                          child: Text('Копировать данные о системе'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 44, 110, 209),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _saveAsPdf(data),
                      child: Text('Сохранить данные в PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 44, 110, 209), // Обновленный параметр
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
}
