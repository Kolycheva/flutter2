// lib/login_page.dart

import 'package:flutter/material.dart'; // Импортируем пакет Flutter для работы с материалами (UI-компоненты).
import 'database_helper.dart'; // Импортируем файл для работы с базой данных.
import 'register_page.dart'; // Импортируем файл для страницы регистрации.
import 'app_localizations.dart'; // Импортируем файл для локализации приложения.
import 'dart:async'; // Импортируем пакет для работы с асинхронным кодом и таймерами.
import 'package:intl/intl.dart'; // Импортируем пакет для работы с форматированием даты и времени.
import 'home_screen.dart';  // Импортируем HomeScreen.  

class LoginPage extends StatefulWidget { // Определяем StatefulWidget для страницы входа.
  final Function(Locale) onLocaleChange; // Функция для изменения локализации.
  LoginPage({required this.onLocaleChange}); // Конструктор, принимающий функцию изменения локализации.

  @override
  _LoginPageState createState() => _LoginPageState(); // Создаем состояние для LoginPage.
}

class _LoginPageState extends State<LoginPage> { // Определяем состояние для LoginPage.
  final TextEditingController emailController = TextEditingController(); // Контроллер для поля ввода email.
  final TextEditingController passwordController = TextEditingController(); // Контроллер для поля ввода пароля.
  final dbHelper = DatabaseHelper(); // Создаем экземпляр DatabaseHelper для работы с базой данных.
  String _currentTime = ''; // Переменная для хранения текущего времени.

  @override
  void initState() { // Метод, который вызывается при инициализации состояния.
    super.initState(); // Вызываем метод родительского класса.
    _startClock(); // Запускаем таймер для обновления времени.
  }

  void _startClock() { // Метод для запуска таймера.
    Timer.periodic(Duration(seconds: 1), (timer) { // Таймер, обновляющий каждую секунду.
      setState(() { // Обновляем состояние.
        _currentTime = DateFormat('dd MMMM yyyy, HH:mm:ss', Localizations.localeOf(context).toString()).format(DateTime.now()); // Обновляем текущее время в нужном формате.
      });
    });
  }

  @override
  Widget build(BuildContext context) { // Метод, который строит виджет.
    var localization = AppLocalizations.of(context); // Получаем локализацию для текущего контекста.

    return Scaffold( // Создаем Scaffold для основной структуры страницы.
      appBar: AppBar( // Создаем верхнюю панель приложения.
        centerTitle: true, // Центрируем заголовок.
        title: Text(localization!.translate('title')), // Заголовок с переводом.
        actions: [ // Кнопки в верхней панели.
          IconButton(
            icon: Icon(Icons.language), // Кнопка для смены языка.
            onPressed: () { // Действие при нажатии на кнопку.
              widget.onLocaleChange(Localizations.localeOf(context).languageCode == 'en' // Проверяем текущий язык и переключаем на противоположный.
                ? Locale('ru', 'RU')
                : Locale('en', 'US'));
            },
          )
        ],
      ),
      body: SingleChildScrollView( // Позволяем прокручивать содержимое страницы.
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Отступы вокруг содержимого.
          child: Column( // Столбец для вертикального размещения элементов.
            mainAxisAlignment: MainAxisAlignment.center, // Центрируем содержимое по вертикали.
            children: <Widget>[ // Дочерние виджеты.
              FlutterLogo(size: 100),  // Логотип Flutter.
              SizedBox(height: 20),   // Отступ после логотипа.
              Text( // Текст для отображения текущего времени.
                _currentTime,
                style: TextStyle(
                  fontSize: 18, // Размер шрифта.
                  fontWeight: FontWeight.bold, // Жирное начертание.
                  color: Colors.white, // Цвет текста - белый.
                ),
              ),
              SizedBox(height: 20), // Отступ после времени.
              TextField( // Поле ввода для email.
                controller: emailController, // Привязываем контроллер.
                decoration: InputDecoration(
                  labelText: localization.translate('username'), // Метка с переводом.
                ),
              ),
              SizedBox(height: 16), // Отступ между полями ввода.
              TextField( // Поле ввода для пароля.
                controller: passwordController, // Привязываем контроллер.
                decoration: InputDecoration(
                  labelText: localization.translate('password'), // Метка с переводом.
                ),
                obscureText: true, // Скрываем вводимые символы.
              ),
              SizedBox(height: 24), // Отступ перед кнопками.
              Row( // Строка для размещения кнопок.
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Располагаем кнопки на одной строке с равными промежутками.
                children: <Widget>[ // Дочерние виджеты.
                  Expanded( // Расширяем кнопку, чтобы занять доступное пространство.
                    child: ElevatedButton( // Кнопка для входа.
                      onPressed: () async { // Действие при нажатии на кнопку.
                        String username = emailController.text; // Получаем введенный email.
                        String password = passwordController.text; // Получаем введенный пароль.

                        bool isAuthenticated = await dbHelper.authenticateUser(username, password); // Проверяем аутентификацию пользователя.

                        if (isAuthenticated) { // Если аутентификация успешна.
                          Navigator.pushReplacement( // Переходим на главную страницу.
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen()),
                          );
                        } else { // Если аутентификация не удалась.
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar( // Показываем сообщение об ошибке.
                            content: Text(localization.translate('login_failure')), // Текст сообщения с переводом.
                            backgroundColor: Colors.redAccent, // Цвет фона сообщения.
                          ));
                        }
                      },
                      child: Text(localization.translate('login')), // Текст на кнопке с переводом.
                    ),
                  ),
                  SizedBox(width: 16), // Отступ между кнопками.
                  Expanded( // Расширяем кнопку для регистрации.
                    child: ElevatedButton( // Кнопка для перехода на страницу регистрации.
                      onPressed: () {
                        Navigator.push( // Переходим на страницу регистрации.
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage(onLocaleChange: widget.onLocaleChange)),
                        );
                      },
                      child: Text(localization.translate('register')), // Текст на кнопке с переводом.
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
