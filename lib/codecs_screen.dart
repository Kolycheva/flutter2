import 'dart:io'; // Импортируем для работы с файловой системой.
import 'package:flutter/material.dart'; // Импортируем пакет Flutter для работы с материалами (UI-компоненты).
import 'package:fluttertoast/fluttertoast.dart'; // Импортируем пакет для уведомлений Toast.

class CodecsScreen extends StatelessWidget { // Определяем StatelessWidget для экрана кодеков.
  @override
  Widget build(BuildContext context) { // Метод, который строит виджет.
    return Scaffold( // Создаем Scaffold для основной структуры страницы.
      appBar: AppBar( // Создаем верхнюю панель приложения.
        title: Text('Информация о кодеках'), // Заголовок панели.
        actions: [
          // Добавляем иконку оповещения для демонстрации диалогового окна.
          IconButton(
            icon: Icon(Icons.notifications), // Иконка уведомлений.
            onPressed: () { // Действие при нажатии на иконку.
              _showDialog(context); // Показываем диалоговое окно.
            },
          ),
        ],
      ),
      body: FutureBuilder<List<String>>( // Используем FutureBuilder для асинхронной загрузки данных.
        future: _getCodecs(), // Асинхронная функция для получения кодеков.
        builder: (context, snapshot) { // Строим виджет в зависимости от состояния загрузки.
          if (snapshot.connectionState == ConnectionState.waiting) { // Если данные все еще загружаются.
            return Center(child: CircularProgressIndicator()); // Показываем индикатор загрузки.
          } else if (snapshot.hasError) { // Если произошла ошибка при загрузке.
            return Center(child: Text('Ошибка: ${snapshot.error}')); // Показываем сообщение об ошибке.
          } else {
            List<String> codecs = snapshot.data ?? []; // Получаем список кодеков или пустой список.
            return Padding(
              padding: const EdgeInsets.all (16.0), // Отступы вокруг содержимого.
              child: Column( // Столбец для размещения информации о кодеках.
                crossAxisAlignment: CrossAxisAlignment.start, // Выравнивание по левому краю.
                children: [
                  Text(
                    'Поддерживаемые кодеки', // Заголовок списка кодеков.
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Стиль текста.
                  ),
                  SizedBox(height: 10), // Отступ после заголовка.
                  Text(
                    'Ниже представлен список кодеков, поддерживаемых вашим устройством:', // Подпись к списку кодеков.
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]), // Стиль текста.
                  ),
                  SizedBox(height: 20), // Отступ перед кнопками.
                  ElevatedButton(
                    onPressed: () {
                      // Отображаем SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Вы нажали на кнопку оповещения!'), // Сообщение в SnackBar.
                          duration: Duration(seconds: 3), // Продолжительность отображения.
                        ),
                      );
                    },
                    child: Text('Показать SnackBar'), // Текст на кнопке.
                  ),
                  SizedBox(height: 20), // Отступ между кнопками.
                  ElevatedButton(
                    onPressed: () {
                      // Показываем Toast-уведомление.
                      _showToast('Это уведомление Toast!'); // Вызов функции для отображения Toast.
                    },
                    child: Text('Показать Toast'), // Текст на кнопке.
                  ),
                  SizedBox(height: 20), // Отступ перед списком кодеков.
                  Expanded(
                    child: ListView.builder( // Создаем список кодеков.
                      itemCount: codecs.length, // Количество элементов в списке.
                      itemBuilder: (context, index) { // Метод для создания элементов списка.
                        return Card( // Карточка для отображения кодека.
                          elevation: 4.0, // Эффект тени.
                          margin: EdgeInsets.symmetric(vertical: 8.0), // Отступы по вертикали.
                          child: ListTile( // Элемент списка.
                            leading: Icon(Icons.audiotrack, color: Color.fromARGB(255, 44, 110, 209)), // Иконка кодека.
                            title: Text(
                              codecs[index], // Название кодека.
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500), // Стиль текста.
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Отображаем диалоговое окно.
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Оповещение'), // Заголовок диалогового окна.
          content: Text('Это диалоговое окно для демонстрации оповещения.'), // Текст в диалоговом окне.
          actions: [ // Действия в диалоговом окне.
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог.
              },
              child: Text('Закрыть'), // Текст на кнопке.
            ),
          ],
        );
      },
    );
  }

  // Отображаем Toast-уведомление.
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message, // Сообщение для отображения.
      toastLength: Toast.LENGTH_SHORT, // Длительность отображения.
      gravity: ToastGravity.BOTTOM, // Позиция Toast на экране.
      backgroundColor: Colors.black, // Цвет фона Toast.
      textColor: Colors.white, // Цвет текста Toast.
    );
  }

  // Получаем список кодеков из манифеста.
  Future<List<String>> _getCodecs() async {
    List<String> codecs = []; // Список кодеков.

    // Проверяем системные папки для наличия файлов media_codecs.xml.
    List<String> codecFiles = [
      '/etc/media_codecs.xml',
      '/system/etc/media_codecs.xml',
      '/vendor/etc/media_codecs.xml',
    ];

    for (String filePath in codecFiles) { // Проходим по каждому пути к файлу.
      try {
        final file = File(filePath); // Создаем объект File для указанного пути.
        if (await file.exists()) { // Проверяем, существует ли файл.
          // Читаем содержимое файла и парсим кодеки.
          final content = await file.readAsString(); // Читаем содержимое файла.
          codecs.addAll(_parseCodecs(content)); // Добавляем кодеки в список.
        }
      } catch (e) {
        // Игнорируем ошибки чтения файлов.
      }
    }

    return codecs.isNotEmpty ? codecs : ['Кодеки не найдены']; // Возвращаем список кодеков или сообщение о том, что кодеков нет.
  }

  // Парсим содержимое файла media_codecs.xml.
  List<String> _parseCodecs(String content) {
    List<String> codecs = []; // Список для хранения кодеков.

    // Ищем строки, которые содержат информацию о кодеках.
    RegExp regExp = RegExp(r'<MediaCodec name="([^"]+)"'); // Регулярное выражение для поиска кодеков.
    Iterable<RegExpMatch> matches = regExp.allMatches(content); // Находим все совпадения.

    for (RegExpMatch match in matches) { // Проходим по всем совпадениям.
      if (match.groupCount > 0) {
        codecs.add(match.group(1)!); // Добавляем найденный кодек в список.
      }
    }

    return codecs; // Возвращаем список кодеков.
  }
}
