// lib/register_screen.dart

import 'package:flutter/material.dart'; // Импортируем пакет Flutter для работы с материалами (UI-компоненты).
import 'package:device_info_plus/device_info_plus.dart'; // Импортируем пакет для получения информации об устройстве.
import 'package:device_apps/device_apps.dart'; // Импортируем пакет для получения информации о установленных приложениях.
import 'dart:io'; // Импортируем для работы с файловой системой.
import 'app_details_screen.dart'; // Импортируем экран с подробностями об приложении.

class RegisterScreen extends StatefulWidget { // Определяем StatefulWidget для экрана регистрации системы.
  @override
  _RegisterScreenState createState() => _RegisterScreenState(); // Создаем состояние для RegisterScreen.
}

class _RegisterScreenState extends State<RegisterScreen> { // Определяем состояние для экрана регистрации системы.
  String _deviceInfo = ''; // Переменная для хранения информации об устройстве.
  List<Map<String, dynamic>> _installedApps = []; // Список установленных приложений.

  @override
  void initState() { // Метод, вызываемый при инициализации состояния.
    super.initState(); // Вызываем метод родительского класса.
    _loadDeviceInfo(); // Загружаем информацию об устройстве.
    _loadInstalledApps(); // Загружаем список установленных приложений.
  }

  Future<void> _loadDeviceInfo() async { // Асинхронный метод для загрузки информации об устройстве.
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin(); // Создаем экземпляр DeviceInfoPlugin.
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo; // Получаем информацию об устройстве Android.

    setState(() { // Обновляем состояние виджета.
      _deviceInfo = ''' // Формируем строку с информацией об устройстве.
      Model: ${androidInfo.model}
      Android Version: ${androidInfo.version.release}
      Manufacturer: ${androidInfo.manufacturer}
      Brand: ${androidInfo.brand}
      Hardware: ${androidInfo.hardware}
      ''';
    });
  }

  Future<void> _loadInstalledApps() async { // Асинхронный метод для загрузки установленных приложений.
    List<Application> apps = await DeviceApps.getInstalledApplications( // Получаем список установленных приложений.
      includeSystemApps: true, // Включить системные приложения.
      onlyAppsWithLaunchIntent: true, // Только приложения, которые можно запустить.
    );

    List<Map<String, dynamic>> appsList = []; // Список для хранения информации об установленных приложениях.

    for (var app in apps) { // Проходим по всем установленным приложениям.
      File apkFile = File(app.apkFilePath); // Создаем объект File для APK файла приложения.
      double sizeInMB = apkFile.existsSync() ? apkFile.lengthSync() / (1024 * 1024) : 0.0; // Получаем размер приложения в МБ.

      appsList.add({ // Добавляем информацию о приложении в список.
        'appName': app.appName, // Название приложения.
        'packageName': app.packageName, // Название пакета приложения.
        'size': sizeInMB > 0 ? '${sizeInMB.toStringAsFixed(2)} MB' : 'N/A', // Размер приложения.
      });
    }

    setState(() { // Обновляем состояние виджета с информацией о приложениях.
      _installedApps = appsList; // Устанавливаем список установленных приложений.
    });
  }

  @override
  Widget build(BuildContext context) { // Метод, который строит виджет.
    return Scaffold( // Создаем Scaffold для основной структуры страницы.
      appBar: AppBar( // Создаем верхнюю панель приложения.
        title: Text( // Заголовок панели.
          'Реестр системы',
          style: TextStyle(color: Colors.white), // Цвет текста заголовка.
        ),
        backgroundColor: Color.fromARGB(255, 44, 110, 209), // Цвет фона панели.
      ),
      body: Padding( // Отступы вокруг содержимого.
        padding: const EdgeInsets.all(16.0),
        child: Column( // Столбец для размещения информации.
          crossAxisAlignment: CrossAxisAlignment.start, // Выравнивание по левому краю.
          children: [
            Text( // Заголовок для информации об устройстве.
              'Информация об устройстве',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Стиль текста заголовка.
            ),
            SizedBox(height: 10), // Отступ после заголовка.
            Text( // Отображаем информацию об устройстве.
              _deviceInfo,
              style: TextStyle(color: Colors.white), // Цвет текста.
            ),
            SizedBox(height: 20), // Отступ перед списком приложений.
            Text( // Заголовок для списка установленных приложений.
              'Установленные приложения',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Стиль текста заголовка.
            ),
            SizedBox(height: 10), // Отступ после заголовка.
            Expanded( // Расширяем область для списка приложений.
              child: _installedApps.isEmpty // Проверяем, есть ли установленные приложения.
                  ? Center(child: CircularProgressIndicator()) // Показываем индикатор загрузки, если список пуст.
                  : ListView.builder( // Создаем список установленных приложений.
                      itemCount: _installedApps.length, // Количество элементов в списке.
                      itemBuilder: (context, index) { // Метод для создания элементов списка.
                        var app = _installedApps[index]; // Получаем информацию о приложении по индексу.
                        return Container( // Контейнер для отображения информации о приложении.
                          margin: EdgeInsets.symmetric(vertical: 8.0), // Отступы по вертикали.
                          padding: EdgeInsets.all(16.0), // Внутренние отступы.
                          decoration: BoxDecoration( // Оформление контейнера.
                            color: Colors.blueGrey[900], // Цвет фона контейнера.
                            borderRadius: BorderRadius.circular(10), // Скругленные углы.
                            boxShadow: [ // Тень для контейнера.
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2), // Цвет тени.
                                spreadRadius: 2, // Радиус распространения тени.
                                blurRadius: 5, // Размытие тени.
                              ),
                            ],
                          ),
                          child: ListTile( // Элемент списка для приложения.
                            title: Text( // Название приложения.
                              app['appName'],
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Стиль текста.
                            ),
                            subtitle: Text( // Подзаголовок с информацией о пакете и размере.
                              'Package: ${app['packageName']}\nSize: ${app['size']}',
                              style: TextStyle(color: Colors.white70), // Цвет текста.
                            ),
                            trailing: IconButton( // Кнопка с иконкой информации.
                              icon: Icon(Icons.info, color: Color.fromARGB(255, 44, 110, 209)), // Иконка информации.
                              onPressed: () {
                                // Переход на страницу с подробностями об приложении.
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AppDetailsScreen(
                                      appName: app['appName'], // Передаем название приложения.
                                      packageName: app['packageName'], // Передаем название пакета.
                                      size: app['size'], // Передаем размер приложения.
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black87, // Цвет фона экрана.
    );
  }
}
