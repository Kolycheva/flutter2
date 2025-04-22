// lib/home_screen.dart

import 'package:flutter/material.dart'; // Импортируем пакет Flutter для работы с материалами (UI-компоненты).
import 'package:my_first_app/pixels_screen.dart';
import 'package:my_first_app/vibration_page.dart';
import 'processor_info_screen.dart'; // Импортируем экран информации о процессоре.
import 'package:intl/intl.dart'; // Импортируем пакет для работы с форматированием даты и времени.
import 'system_info_screen.dart'; // Импортируем экран системной информации.
import 'battery_info_screen.dart'; // Импортируем экран информации о батарее.
import 'login_page.dart'; // Импортируем страницу входа.
import 'package:device_info_plus/device_info_plus.dart'; // Импортируем пакет для получения информации об устройстве.
import 'package:device_apps/device_apps.dart'; // Импортируем пакет для работы с установленными приложениями.
import 'dart:io'; // Импортируем библиотеку для работы с файловой системой.
import 'dart:typed_data'; // Импортируем для использования Uint8List.
import 'testing_screen.dart'; // Импортируем экран тестирования.
import 'about_screen.dart'; // Импортируем экран "О приложении".
import 'device_features_screen.dart'; // Импортируем экран устройства.
import 'sensors_screen.dart'; // Импортируем экран датчиков.
import 'reports_screen.dart'; // Импортируем экран отчетов.
import 'register_screen.dart'; // Импортируем экран реестра.
import 'MultiTouch_screen.dart'; // Импортируем экран мультитача


class HomeScreen extends StatefulWidget { // Определяем StatefulWidget для главного экрана.
  @override
  _HomeScreenState createState() => _HomeScreenState(); // Создаем состояние для HomeScreen.
}

class _HomeScreenState extends State<HomeScreen> { // Определяем состояние для главного экрана.
  List<Map<String, dynamic>> _appsWithSizeAndIcon = []; // Список приложений с размером и иконкой.
  String _deviceInfo = ''; // Переменная для хранения информации об устройстве.
  String _sortCriterion = 'name'; // Критерий сортировки.

  @override
  void initState() { // Метод, вызываемый при инициализации состояния.
    super.initState(); // Вызываем метод родительского класса.
    _loadInstalledAppsWithSizeAndIcon(); // Загружаем установленные приложения с размером и иконкой.
    _getDeviceInfo(); // Получаем информацию об устройстве.
  }

  Future<void> _loadInstalledAppsWithSizeAndIcon() async { // Асинхронный метод для загрузки установленных приложений.
    List<Application> apps = await DeviceApps.getInstalledApplications( // Получаем список установленных приложений.
      includeSystemApps: true, // Включаем системные приложения.
      includeAppIcons: true, // Включаем иконки приложений.
    );
    List<Map<String, dynamic>> appsWithSizeAndIcon = []; // Список для хранения приложений с размером и иконкой.

    for (var app in apps) { // Проходим по каждому приложению.
      File apkFile = File(app.apkFilePath); // Получаем путь к APK-файлу.
      double sizeInMB = apkFile.existsSync() ? apkFile.lengthSync() / (1024 * 1024) : 0.0; // Вычисляем размер приложения в МБ.

      appsWithSizeAndIcon.add({ // Добавляем приложение в список.
        'app': app, // Само приложение.
        'size': sizeInMB > 0 ? '${sizeInMB.toStringAsFixed(2)} MB' : 'N/A', // Размер приложения или 'N/A'.
        'sizeValue': sizeInMB, // Добавлено для сортировки по размеру.
        'icon': app is ApplicationWithIcon ? app.icon : null, // Иконка приложения.
      });
    }

    _sortApps(appsWithSizeAndIcon); // Сортируем приложения перед отображением.

    setState(() { // Обновляем состояние.
      _appsWithSizeAndIcon = appsWithSizeAndIcon; // Обновляем список приложений.
    });
  }

  void _sortApps(List<Map<String, dynamic>> apps) { // Метод для сортировки приложений.
    if (_sortCriterion == 'name') { // Если критерий сортировки - по имени.
      apps.sort((a, b) => a['app'].appName.compareTo(b['app'].appName)); // Сортируем по имени приложения.
    } else if (_sortCriterion == 'size') { // Если критерий сортировки - по размеру.
      apps.sort((a, b) => (a['sizeValue'] as double).compareTo(b['sizeValue'] as double)); // Сортируем по размеру.
    }
  }

  Future<void> _getDeviceInfo() async { // Асинхронный метод для получения информации об устройстве.
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin(); // Создаем экземпляр DeviceInfoPlugin.
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo; // Получаем информацию об устройстве Android.
    setState(() { // Обновляем состояние.
      _deviceInfo = 'Device: ${androidInfo.model}, Android version: ${androidInfo.version.release}'; // Формируем строку с информацией об устройстве.
    });
  }

  void _onSortSelected(String criterion) { // Метод для обработки выбора критерия сортировки.
    setState(() { // Обновляем состояние.
      _sortCriterion = criterion; // Устанавливаем новый критерий сортировки.
      _sortApps(_appsWithSizeAndIcon); // Пересортируем приложения.
    });
  }

  @override
  Widget build(BuildContext context) { // Метод, который строит виджет.
    return Scaffold( // Создаем Scaffold для основной структуры страницы.
      appBar: AppBar( // Создаем верхнюю панель приложения.
        title: Row( // Заголовок с кнопками.
          children: [
            IconButton( // Кнопка сортировки.
              icon: Icon(Icons.sort),
              onPressed: () { // Действие при нажатии на кнопку.
                showDialog( // Показываем диалоговое окно выбора критерия сортировки.
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Sort by"), // Заголовок диалогового окна.
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile( // Пункт для сортировки по имени.
                            title: Text("Name"),
                            onTap: () {
                              Navigator.of(context).pop(); // Закрываем диалог.
                              _onSortSelected('name'); // Устанавливаем сортировку по имени.
                            },
                          ),
                          ListTile( // Пункт для сортировки по размеру.
                            title: Text("Size"),
                            onTap: () {
                              Navigator.of(context).pop(); // Закрываем диалог.
                              _onSortSelected('size'); // Устанавливаем сортировку по размеру.
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            Expanded( // Расширяем для центрирования текущего времени.
              child: Center(
                child: StreamBuilder( // Создаем StreamBuilder для обновления времени каждую секунду.
                  stream: Stream.periodic(Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    String formattedDateTime = DateFormat('dd.MM.yyyy HH:mm:ss').format(DateTime.now()); // Форматируем текущее время.
                    return Text( // Отображаем текущее время.
                      formattedDateTime,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        actions: [ // Кнопки действий в верхней панели.
          IconButton( // Кнопка выхода.
            icon: Icon(Icons.exit_to_app),
            onPressed: () { // Действие при нажатии на кнопку.
              Navigator.pushReplacement( // Переход на страницу входа.
                context,
                MaterialPageRoute(builder: (context) => LoginPage(onLocaleChange: (locale) {})),
              );
            },
          )
        ],
      ),
      body: Padding( // Отступы вокруг содержимого.
        padding: const EdgeInsets.all(16.0),
        child: Column( // Столбец для вертикального размещения элементов.
          crossAxisAlignment: CrossAxisAlignment.start, // Выравнивание по левому краю.
          children: [
            Text( // Отображаем информацию об устройстве.
              _deviceInfo,
              style: TextStyle(fontSize: 16, color: Colors.white), // Стиль текста.
            ),
            SizedBox(height: 20), // Отступ после текста.
            Row( // Строка с кнопками для перехода на другие экраны.
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Равномерное распределение кнопок.
              children: [
                Expanded( // Расширяем кнопку для информации о процессоре.
                  child: TextButton(
                    onPressed: () { // Действие при нажатии на кнопку.
                      Navigator.push( // Переход на экран информации о процессоре.
                        context,
                        MaterialPageRoute(builder: (context) => ProcessorInfoScreen()),
                      );
                    },
                    style: TextButton.styleFrom( // Стиль кнопки.
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 44, 110, 209),
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 14),
                    ),
                    child: Text('Процессор'), // Текст на кнопке.
                  ),
                ),
                SizedBox(width: 8), // Отступ между кнопками.
                Expanded( // Расширяем кнопку для информации о батарее.
                  child: TextButton(
                    onPressed: () { // Действие при нажатии на кнопку.
                      Navigator.push( // Переход на экран информации о батарее.
                        context,
                        MaterialPageRoute(builder: (context) => BatteryInfoScreen()),
                      );
                    },
                    style: TextButton.styleFrom( // Стиль кнопки.
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 44, 110, 209),
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 14),
                    ),
                    child: Text('Аккумулятор'), // Текст на кнопке.
                  ),
                ),
                SizedBox(width: 8), // Отступ между кнопками.
                Expanded( // Расширяем кнопку для системной информации.
                  child: TextButton(
                    onPressed: () { // Действие при нажатии на кнопку.
                      Navigator.push( // Переход на экран системной информации.
                        context,
                        MaterialPageRoute(builder: (context) => SystemInfoScreen()),
                      );
                    },
                    style: TextButton.styleFrom( // Стиль кнопки.
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 44, 110, 209),
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 14),
                    ),
                    child: Text('Система'), // Текст на кнопке.
                  ),
                ),
              ], 
            ),
            SizedBox(height: 10), // Отступ между строками кнопок.
            Row( // Вторая строка с кнопками.
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Равномерное распределение кнопок.
              children: [
                Expanded( // Расширяем кнопку для тестирования.
                  child: TextButton(
                    onPressed: () { // Действие при нажатии на кнопку.
                      Navigator.push( // Переход на экран тестирования.
                        context,
                        MaterialPageRoute(builder: (context) => TestingScreen()),
                      );
                    },
                    style: TextButton.styleFrom( // Стиль кнопки.
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 44, 110, 209),
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 14),
                    ),
                    child: Text('Тестирование'), // Текст на кнопке.
                  ),
                ),
                SizedBox(width: 8), // Отступ между кнопками.
                Expanded( // Расширяем кнопку для информации о приложении.
                  child: TextButton(
                    onPressed: () { // Действие при нажатии на кнопку.
                      Navigator.push( // Переход на экран "О приложении".
                        context,
                        MaterialPageRoute(builder: (context) => AboutScreen()),
                      );
                    },
                    style: TextButton.styleFrom( // Стиль кнопки.
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 44, 110, 209),
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 14),
                    ),
                    child: Text('О приложении'), // Текст на кнопке.
                  ),
                ),
                SizedBox(width: 8), // Отступ между кнопками.
                Expanded( // Расширяем кнопку для функций устройства.
                  child: TextButton(
                    onPressed: () { // Действие при нажатии на кнопку.
                      Navigator.push( // Переход на экран функций устройства.
                        context,
                        MaterialPageRoute(builder: (context) => DeviceFeaturesScreen()),
                      );
                    },
                    style: TextButton.styleFrom( // Стиль кнопки.
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 44, 110, 209),
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 14),
                    ),
                    child: Text('Устройства'), // Текст на кнопке.
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Отступ перед новой строкой кнопок.
            Row( // Третья строка с кнопками.
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Равномерное распределение кнопок.
              children: [
                Expanded( // Расширяем кнопку для датчиков.
                  child: TextButton(
                    onPressed: () { // Действие при нажатии на кнопку.
                      Navigator.push( // Переход на экран датчиков.
                        context,
                        MaterialPageRoute(builder: (context) => SensorsScreen()),
                      );
                    },
                    style: TextButton.styleFrom( // Стиль кнопки.
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 44, 110, 209),
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 14), 
                    ),
                    child: Text('Датчики'), // Текст на кнопке.
                  ),
                ),
                SizedBox(width: 8), // Отступ между кнопками.
                Expanded( // Расширяем кнопку для отчетов.
                  child: TextButton(
                    onPressed: () { // Действие при нажатии на кнопку.
                      Navigator.push( // Переход на экран отчетов.
                        context,
                        MaterialPageRoute(builder: (context) => ReportsScreen()),
                      );
                    },
                    style: TextButton.styleFrom( // Стиль кнопки.
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 44, 110, 209),
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 14),
                    ),
                    child: Text('Отчеты'), // Текст на кнопке.
                  ),
                ),
                SizedBox(width: 8), // Отступ между кнопками.
                Expanded( // Расширяем кнопку для реестра.
                  child: TextButton(
                    onPressed: () { // Действие при нажатии на кнопку.
                      Navigator.push( // Переход на экран реестра.
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                    style: TextButton.styleFrom( // Стиль кнопки.
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 44, 110, 209),
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 14),
                    ),
                    child: Text('Реестр'), // Текст на кнопке.
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row( // Четвертая строка с кнопками.
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Равномерное распределение кнопок.
              children: [
                SizedBox(width: 8), // Отступ между кнопками.
                Expanded( // Расширяем кнопку для реестра.
                  child: TextButton(
                    onPressed: () { // Действие при нажатии на кнопку.
                      Navigator.push( // Переход на экран реестра.
                        context,
                        MaterialPageRoute(builder: (context) => VibrationTestScreen()),
                      );
                    },
                    style: TextButton.styleFrom( // Стиль кнопки.
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 44, 110, 209),
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 14),
                    ),
                    child: Text('Вибромотор'), // Текст на кнопке.
                  ),
                ),
                SizedBox(width: 8), // Отступ между кнопками.
                Expanded( // Расширяем кнопку для реестра.
                  child: TextButton(
                    onPressed: () { // Действие при нажатии на кнопку.
                      Navigator.push( // Переход на экран реестра.
                        context,
                        MaterialPageRoute(builder: (context) => PixelsTestPage()),
                      );
                    },
                    style: TextButton.styleFrom( // Стиль кнопки.
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 44, 110, 209),
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 14),
                    ),
                    child: Text('тест Сенсора'), // Текст на кнопке.
                  ),
                ),
                SizedBox(width: 8), // Отступ между кнопками.
                Expanded( // Расширяем кнопку для реестра.
                  child: TextButton(
                    onPressed: () { // Действие при нажатии на кнопку.
                      Navigator.push( // Переход на экран реестра.
                        context,
                        MaterialPageRoute(builder: (context) => MultiTouchCounter()),
                      );
                    },
                    style: TextButton.styleFrom( // Стиль кнопки.
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 44, 110, 209),
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 14),
                    ),
                    child: Text('Мультитач'), // Текст на кнопке.
                  ),
                ),
              ],
            ), //строка 4
            SizedBox(height: 20), // Отступ перед списком приложений.
            Expanded( // Расширяем область для отображения списка приложений.
              child: _appsWithSizeAndIcon.isEmpty // Проверяем, есть ли приложения для отображения.
                  ? Center(child: CircularProgressIndicator()) // Показываем индикатор загрузки, если список пуст.
                  : ListView.builder( // Создаем список приложений.
                      itemCount: _appsWithSizeAndIcon.length, // Количество элементов в списке.
                      itemBuilder: (context, index) { // Метод для создания элементов списка.
                        var appWithSizeAndIcon = _appsWithSizeAndIcon[index]; // Получаем данные приложения.
                        Application app = appWithSizeAndIcon['app']; // Получаем объект приложения.
                        String size = appWithSizeAndIcon['size']; // Получаем размер приложения.
                        Uint8List? icon = appWithSizeAndIcon['icon']; // Получаем иконку приложения.

                        return Container( // Создаем контейнер для отображения информации о приложении.
                          margin: EdgeInsets.symmetric(vertical: 8.0), // Отступы по вертикали.
                          padding: EdgeInsets.all(16.0), // Внутренние отступы.
                          decoration: BoxDecoration( // Настройки оформления контейнера.
                            color: Colors.white, // Цвет фона.
                            borderRadius: BorderRadius.circular(12.0), // Скругленные углы.
                            boxShadow: [ // Тень для эффекта.
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                            border: Border.all(color: Color.fromARGB(255, 44, 110, 209), width: 2), // Граница.
                          ),
                          child: Row( // Строка для размещения элементов.
                            crossAxisAlignment: CrossAxisAlignment.center, // Выравнивание по центру.
                            children: [
                              Expanded( // Расширяем область для текста.
                                child: Column( // Столбец для размещения информации о приложении.
                                  crossAxisAlignment: CrossAxisAlignment.start, // Выравнивание текста по левому краю.
                                  children: [
                                    Text( // Название приложения.
                                      app.appName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8.0), // Отступ после названия.
                                    Text( // Название пакета приложения.
                                      'Package: ${app.packageName}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(height: 8.0), // Отступ после названия пакета.
                                    Text( // Размер приложения.
                                      'Size: $size',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10), // Отступ между текстом и иконкой.
                              if (icon != null) // Проверяем, есть ли иконка.
                                Image.memory( // Отображаем иконку приложения.
                                  icon,
                                  width: 40,
                                  height: 40,
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}