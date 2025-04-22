// register_page.dart

import 'package:flutter/material.dart'; // Импортируем пакет Flutter для работы с материалами (UI-компоненты).
import 'database_helper.dart'; // Импортируем файл для работы с базой данных.
import 'app_localizations.dart'; // Импортируем файл для локализации приложения.

class RegisterPage extends StatefulWidget { // Определяем StatefulWidget для страницы регистрации.
  final Function(Locale) onLocaleChange; // Функция для изменения локализации.
  RegisterPage({required this.onLocaleChange}); // Конструктор, принимающий функцию изменения локализации.

  @override
  _RegisterPageState createState() => _RegisterPageState(); // Создаем состояние для RegisterPage.
}

class _RegisterPageState extends State<RegisterPage> { // Определяем состояние для страницы регистрации.
  final TextEditingController emailController = TextEditingController(); // Контроллер для поля ввода email.
  final TextEditingController passwordController = TextEditingController(); // Контроллер для поля ввода пароля.
  final dbHelper = DatabaseHelper(); // Создаем экземпляр DatabaseHelper для работы с базой данных.

  @override
  Widget build(BuildContext context) { // Метод, который строит виджет.
    var localization = AppLocalizations.of(context); // Получаем локализацию для текущего контекста.

    return Scaffold( // Создаем Scaffold для основной структуры страницы.
      appBar: AppBar( // Создаем верхнюю панель приложения.
        centerTitle: true, // Центрируем заголовок.
        title: Text(localization!.translate('register')), // Заголовок с переводом.
      ),
      body: Padding( // Отступы вокруг содержимого.
        padding: const EdgeInsets.all(16.0),
        child: Column( // Столбец для вертикального размещения элементов.
          mainAxisAlignment: MainAxisAlignment.center, // Центрируем содержимое по вертикали.
          children: <Widget>[ // Дочерние виджеты.
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
            SizedBox(height: 24), // Отступ перед кнопкой.
            ElevatedButton( // Кнопка для регистрации.
              onPressed: () async { // Действие при нажатии на кнопку.
                String username = emailController.text.trim(); // Получаем введенный email и убираем пробелы.
                String password = passwordController.text.trim(); // Получаем введенный пароль и убираем пробелы.

                if (username.isEmpty || password.isEmpty) { // Проверяем, что поля не пустые.
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar( // Показываем сообщение об ошибке.
                    content: Text('Имя пользователя и пароль не могут быть пустыми'), // Текст сообщения.
                    backgroundColor: Colors.redAccent, // Цвет фона сообщения.
                  ));
                  return; // Выходим из функции, если поля пустые.
                }

                try {
                  await dbHelper.registerUser(username, password); // Регистрация пользователя в базе данных.
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar( // Показываем сообщение об успешной регистрации.
                    content: Text(localization.translate('register_success')), // Текст сообщения с переводом.
                    backgroundColor: Color.fromARGB(255, 44, 110, 209), // Цвет фона сообщения.
                  ));
                  Navigator.pop(context); // Закрываем страницу регистрации и возвращаемся назад.
                } catch (e) { // Обрабатываем ошибки при регистрации.
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar( // Показываем сообщение об ошибке.
                    content: Text('Ошибка: Пользователь уже существует'), // Текст сообщения.
                    backgroundColor: Colors.redAccent, // Цвет фона сообщения.
                  ));
                }
              },
              child: Text(localization.translate('register_button')), // Текст на кнопке с переводом.
            ),
          ],
        ),
      ),
    );
  }
}
