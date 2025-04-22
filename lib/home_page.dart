import 'package:flutter/material.dart'; // Импортируем пакет Flutter для работы с материалами (UI-компоненты).
import 'login_page.dart'; // Импортируем файл login_page.dart, который содержит определение страницы входа.
import 'app_localizations.dart'; // Импортируем файл для поддержки локализации приложения.
import 'package:flutter_localizations/flutter_localizations.dart'; // Импортируем пакет для поддержки локализации.

class HomePage extends StatefulWidget { // Определяем StatefulWidget для главной страницы.
  @override
  _HomePageState createState() => _HomePageState(); // Создаем состояние для HomePage.
}

class _HomePageState extends State<HomePage> { // Определяем состояние для HomePage.
  Locale _locale = Locale('ru', 'RU'); // Начальная локализация устанавливается на русский (Россия).

  // Метод для изменения языка
  void _changeLanguage(Locale locale) { // Метод, который принимает новую локализацию.
    setState(() { // Устанавливаем новое состояние.
      _locale = locale; // Обновляем локализацию.
    });
  }

  @override
  Widget build(BuildContext context) { // Метод, который строит виджет.
    return MaterialApp(// Возвращаем MaterialApp, корневой виджет приложения.   
    debugShowCheckedModeBanner: false,
      title: 'ИнфоТел', // Устанавливаем заголовок приложения.
      locale: _locale, // Устанавливаем текущую локализацию приложения.
      localizationsDelegates: [ // Указываем делегаты для локализации.
        GlobalMaterialLocalizations.delegate, // Делегат для локализации материалов.
        GlobalWidgetsLocalizations.delegate, // Делегат для локализации виджетов.
        GlobalCupertinoLocalizations.delegate, // Делегат для локализации стиля Cupertino.
        AppLocalizationsDelegate(), // Делегат для пользовательской локализации приложения.
      ],
      supportedLocales: [ // Поддерживаемые локализации.
        Locale('en', 'US'), // Английский (США).
        Locale('ru', 'RU'), // Русский (Россия).
      ],
      theme: ThemeData( // Устанавливаем тему приложения.
        brightness: Brightness.dark, // Устанавливаем темную тему. // Основной цвет темы - бирюзовый.
        scaffoldBackgroundColor: Colors.black87, // Цвет фона приложения - темный.
        textTheme: TextTheme( // Определяем тему текста.
          headlineLarge: TextStyle(color: Color.fromARGB(255, 44, 110, 209)), // Стиль для заголовков.
          bodyLarge: TextStyle(color: Colors.white), // Стиль для основного текста.
          bodyMedium: TextStyle(color: Colors.grey), // Стиль для среднего текста.
        ),
        inputDecorationTheme: InputDecorationTheme( // Стиль для полей ввода.
          border: OutlineInputBorder( // Граница для полей ввода.
            borderRadius: BorderRadius.circular(12), // Скругленные углы.
            borderSide: BorderSide(color: Color.fromARGB(255, 44, 110, 209)), // Цвет границы - бирюзовый.
          ),
          focusedBorder: OutlineInputBorder( // Граница при фокусе.
            borderRadius: BorderRadius.circular(12), // Скругленные углы.
            borderSide: BorderSide(color: Color.fromARGB(255, 44, 110, 209)), // Цвет границы при фокусе.
          ),
          labelStyle: TextStyle(color: Colors.white), // Цвет текста метки.
          filled: true, // Поля ввода будут заполнены цветом.
          fillColor: Colors.grey[800], // Цвет фона для полей ввода.
        ),
        elevatedButtonTheme: ElevatedButtonThemeData( // Настройки для кнопок.
          style: ElevatedButton.styleFrom( // Стиль кнопок.
            backgroundColor: const Color.fromARGB(255, 44, 110, 209), // Цвет фона кнопки.
            foregroundColor: Colors.white, // Цвет текста кнопки.
            elevation: 8, // Тень для 3D-эффекта.
            textStyle: TextStyle(fontSize: 18), // Размер текста кнопки.
            shape: RoundedRectangleBorder( // Форма кнопки.
              borderRadius: BorderRadius.circular(12), // Скругленные углы.
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Отступы внутри кнопки.
          ),
        ),
      ),
      home: LoginPage(onLocaleChange: _changeLanguage), // Главный экран - страница входа с функцией изменения локализации.
    );
  }
}
