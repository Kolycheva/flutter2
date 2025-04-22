// lib/app_details_screen.dart

import 'package:flutter/material.dart'; // Импортируем пакет Flutter для работы с материалами (UI-компоненты).

class AppDetailsScreen extends StatelessWidget { // Определяем StatelessWidget для экрана подробностей приложения.
  final String appName; // Название приложения.
  final String packageName; // Название пакета приложения.
  final String size; // Размер приложения.

  // Конструктор для получения данных
  AppDetailsScreen({
    required this.appName, // Обязательное поле для названия приложения.
    required this.packageName, // Обязательное поле для названия пакета.
    required this.size, // Обязательное поле для размера приложения.
  });

  @override
  Widget build(BuildContext context) { // Метод, который строит виджет.
    return Scaffold( // Создаем Scaffold для основной структуры страницы.
      appBar: AppBar( // Создаем верхнюю панель приложения.
        title: Text( // Заголовок панели.
          'Подробности приложения',
          style: TextStyle(color: Colors.white), // Белый цвет текста заголовка.
        ),
        backgroundColor: Color.fromARGB(255, 44, 110, 209), // Синий фон AppBar.
        actions: [ // Действия в верхней панели.
          IconButton( // Кнопка с иконкой помощи.
            icon: Icon(Icons.help_outline, color: Colors.white), // Иконка помощи.
            onPressed: () { // Действие при нажатии на кнопку.
              // Показ всплывающего диалога с подсказкой.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Подсказка'), // Заголовок диалогового окна.
                    content: Text('Это страница с подробной информацией о приложении.'), // Текст подсказки.
                    actions: [ // Действия в диалоговом окне.
                      TextButton( // Кнопка закрытия.
                        child: Text('Закрыть'), // Текст на кнопке.
                        onPressed: () {
                          Navigator.of(context).pop(); // Закрываем диалог.
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding( // Отступы вокруг содержимого.
        padding: const EdgeInsets.all(16.0),
        child: Container( // Контейнер для размещения информации о приложении.
          decoration: BoxDecoration( // Оформление контейнера.
            color: Colors.black87, // Темный фон.
            borderRadius: BorderRadius.circular(10), // Скругленные углы.
            boxShadow: [ // Тень для контейнера.
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Цвет тени.
                spreadRadius: 2, // Радиус распространения тени.
                blurRadius: 5, // Размытие тени.
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0), // Внутренние отступы контейнера.
          child: Column( // Столбец для размещения информации.
            crossAxisAlignment: CrossAxisAlignment.start, // Выравнивание по левому краю.
            children: [
              Row( // Строка для размещения названия приложения.
                children: [
                  Icon(Icons.apps, color: Color.fromARGB(255, 44, 110, 209), size: 30), // Иконка приложения.
                  SizedBox(width: 10), // Отступ между иконкой и текстом.
                  Expanded( // Расширяем область для текста.
                    child: Text(
                      'Название: $appName', // Название приложения.
                      style: TextStyle(
                        fontSize: 20, // Размер шрифта.
                        fontWeight: FontWeight.bold, // Жирный шрифт.
                        color: Colors.white, // Цвет текста.
                      ),
                      overflow: TextOverflow.ellipsis, // Чтобы текст не выходил за границы.
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20), // Отступ после названия.
              Row( // Строка для размещения названия пакета.
                children: [
                  Icon(Icons.code, color: Color.fromARGB(255, 44, 110, 209), size: 30), // Иконка для пакета.
                  SizedBox(width: 10), // Отступ между иконкой и текстом.
                  Expanded( // Расширяем область для текста.
                    child: Text(
                      'Пакет: $packageName', // Название пакета приложения.
                      style: TextStyle(
                        fontSize: 18, // Размер шрифта.
                        color: Colors.white70, // Немного приглушенный белый текст.
                      ),
                      overflow: TextOverflow.ellipsis, // Чтобы текст не выходил за границы.
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20), // Отступ после названия пакета.
              Row( // Строка для размещения размера приложения.
                children: [
                  Icon(Icons.storage, color: Color.fromARGB(255, 44, 110, 209), size: 30), // Иконка для размера.
                  SizedBox(width: 10), // Отступ между иконкой и текстом.
                  Expanded( // Расширяем область для текста.
                    child: Text(
                      'Размер: $size', // Размер приложения.
                      style: TextStyle(
                        fontSize: 18, // Размер шрифта.
                        color: Colors.white70, // Немного приглушенный белый текст.
                      ),
                      overflow: TextOverflow.ellipsis, // Чтобы текст не выходил за границы.
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black87, // Темный фон экрана.
    );
  }
}
