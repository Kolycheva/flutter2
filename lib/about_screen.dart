import 'package:flutter/material.dart'; // Импортируем пакет Flutter для работы с материалами (UI-компоненты).
import 'package:url_launcher/url_launcher.dart'; // Импортируем пакет для открытия ссылок (например, телефонов и email).
import 'package:webview_flutter/webview_flutter.dart'; // Импортируем пакет для отображения веб-страниц.

class AboutScreen extends StatelessWidget {
  // Определяем StatelessWidget для экрана "О приложении".
  @override
  Widget build(BuildContext context) {
    // Метод, который строит виджет.
    return Scaffold(
      // Создаем Scaffold для основной структуры страницы.
      appBar: AppBar(
        // Создаем верхнюю панель приложения.
        title: Text('О приложении'), // Заголовок панели.
      ),
      body: Padding(
        // Отступы вокруг содержимого.
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Столбец для вертикального размещения элементов.
          crossAxisAlignment:
              CrossAxisAlignment.start, // Выравнивание по левому краю.
          children: [
            // Логотип приложения
            Center(
              // Центрируем логотип.
              child: Image.asset(
                // Отображаем изображение логотипа из ассетов.
                'assets/images/app_logo.png',
                width: 100,
                height: 100,
              ),
            ),
            SizedBox(height: 20), // Отступ после логотипа.
            // Название приложения
            Text(
              'Название приложения: Лучше чем МЭШ', // Текст с названием приложения.
              style: TextStyle(
                fontSize: 20, // Размер шрифта.
                fontWeight: FontWeight.bold, // Жирный шрифт.
                color: Colors.white, // Цвет текста.
              ),
            ),
            SizedBox(height: 20), // Отступ после названия.
            // Описание приложения
            Container(
              padding: EdgeInsets.all(12), // Внутренние отступы контейнера.
              decoration: BoxDecoration(
                // Оформление контейнера.
                border: Border.all(
                  color: Color.fromARGB(255, 44, 110, 209), // Цвет границы.
                  width: 2.0, // Ширина границы.
                ),
                borderRadius: BorderRadius.circular(10.0), // Скругленные углы.
              ),
              child: Text(
                'Это приложение...', // Описание приложения.
                style: TextStyle(
                  fontSize: 16, // Размер шрифта.
                  fontWeight: FontWeight.bold, // Жирный шрифт.
                  color: Colors.white, // Цвет текста.
                ),
              ),
            ),
            SizedBox(height: 20), // Отступ после описания.
            // Версия приложения
            Text(
              'Версия приложения: 14.8.8', // Текст с версией приложения.
              style: TextStyle(
                fontSize: 16, // Размер шрифта.
                fontWeight: FontWeight.bold, // Жирный шрифт.
                color: Colors.white, // Цвет текста.
              ),
            ),
            SizedBox(height: 20), // Отступ после версии.
            // Разработчик
            Row(
              // Строка для размещения информации о разработчике.
              children: [
                Icon(
                  // Иконка информации.
                  Icons.info,
                  color: Color.fromARGB(255, 44, 110, 209),
                ),
                SizedBox(width: 8), // Отступ между иконкой и текстом.
                Expanded(
                  // Расширяем область для текста.
                  child: Text(
                    'Разработчик: Александр Бочаров', // Текст с информацией о разработчике.
                    style: TextStyle(
                      fontSize: 16, // Размер шрифта.
                      fontWeight: FontWeight.bold, // Жирный шрифт.
                      color: Colors.white, // Цвет текста.
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Отступ после информации о разработчике.
            // Ссылка на телефон
            GestureDetector(
              // Позволяет обрабатывать нажатия на область.
              onTap: () {
                // Действие при нажатии.
                _makePhoneCall(
                    'телефон: +7 918 016 32 06 '); // Вызываем функцию для телефонного звонка.
              },
              child: Row(
                // Строка для размещения информации о звонке.
                children: [
                  Icon(
                    // Иконка телефона.
                    Icons.phone,
                    color: Color.fromARGB(255, 44, 110, 209),
                  ),
                  SizedBox(width: 8), // Отступ между иконкой и текстом.
                  Expanded(
                    // Расширяем область для текста.
                    child: Text(
                      'Свяжитесь с нами: +7 918 016 32 06', // Текст с номером телефона.
                      style: TextStyle(
                        fontSize: 16, // Размер шрифта.
                        color: Color.fromARGB(255, 44, 110, 209), // Цвет текста.
                        fontWeight: FontWeight.bold, // Жирный шрифт.
                        decoration:
                            TextDecoration.underline, // Подчеркивание текста.
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Отступ после телефонной информации.
            // Ссылка на email
            GestureDetector(
              // Позволяет обрабатывать нажатия на область.
              onTap: () {
                // Действие при нажатии.
                _sendEmail(
                    'Почта: bocharov.aa2310@gmail.com'); // Вызываем функцию для отправки email.
              },
              child: Row(
                // Строка для размещения информации об email.
                children: [
                  Icon(
                    // Иконка email.
                    Icons.email,
                    color: Color.fromARGB(255, 44, 110, 209),
                  ),
                  SizedBox(width: 8), // Отступ между иконкой и текстом.
                  Expanded(
                    // Расширяем область для текста.
                    child: Text(
                      'Написать нам: bocharov.aa2310@gmail.com', // Текст с адресом email.
                      style: TextStyle(
                        fontSize: 16, // Размер шрифта.
                        color: Color.fromARGB(255, 44, 110, 209), // Цвет текста.
                        fontWeight: FontWeight.bold, // Жирный шрифт.
                        decoration:
                            TextDecoration.underline, // Подчеркивание текста.
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Отступ после email информации.
            // Кнопка для открытия сайта
            ElevatedButton(
              onPressed: () {
                // Действие при нажатии на кнопку.
                Navigator.push(
                  // Переход на экран с веб-страницей.
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewScreen(),
                  ),
                );
              },
              child: Text('Наш сайт'), // Текст на кнопке.
            ),
          ],
        ),
      ),
    );
  }

  // Функция для вызова номера телефона
  Future<void> _makePhoneCall(String url) async {
    // Асинхронный метод для телефонного звонка.
    final Uri launchUri = Uri(
        scheme: 'Телефон',
        path: '+7 918 016 32 06'); // Создаем URI для телефонного звонка.
    if (await canLaunchUrl(launchUri)) {
      // Проверяем, можно ли открыть URL.
      await launchUrl(launchUri); // Открываем телефонное приложение.
    } else {
      throw 'Не удалось открыть $url'; // Выбрасываем ошибку, если не удалось открыть.
    }
  }

  // Функция для отправки email
  Future<void> _sendEmail(String email) async {
    // Асинхронный метод для отправки email.
    final Uri emailUri = Uri(
        scheme: 'Почта',
        path: 'bocharov.aa2310@gmail.com'); // Создаем URI для email.
    if (await canLaunchUrl(emailUri)) {
      // Проверяем, можно ли открыть URL.
      await launchUrl(emailUri); // Открываем почтовое приложение.
    } else {
      throw 'Не удалось открыть $email'; // Выбрасываем ошибку, если не удалось открыть.
    }
  }
}

// Экран для отображения сайта в WebView
class WebViewScreen extends StatelessWidget {
  // Определяем StatelessWidget для экрана WebView.
  final WebViewController controller =
      WebViewController() // Создаем контроллер WebView.
        ..setJavaScriptMode(
            JavaScriptMode.unrestricted) // Разрешаем выполнение JavaScript.
        ..setBackgroundColor(
            const Color(0x00000000)) // Устанавливаем прозрачный фон.
        ..setNavigationDelegate(
          // Устанавливаем делегат для обработки навигации.
          NavigationDelegate(
            onProgress: (int progress) {
              // Отслеживаем прогресс загрузки.
            },
            onPageStarted: (String url) {
              // Действие при начале загрузки страницы.
              print("Page started loading: $url");
            },
            onPageFinished: (String url) {
              // Действие при завершении загрузки страницы.
              print("Page finished loading: $url");
            },
            onHttpError: (HttpResponseError error) {
              // Обработка HTTP ошибок.
              print("HTTP error: ${error.toString()}");
            },
            onWebResourceError: (WebResourceError error) {
              // Обработка ошибок веб-ресурсов.
              print("Web resource error: ${error.toString()}");
            },
            onNavigationRequest: (NavigationRequest request) {
              // Обработка запросов навигации.
              return NavigationDecision.navigate; // Разрешаем навигацию.
            },
          ),
        )
        ..loadRequest(Uri.parse('https://pub.dev')); // Загружаем веб-страницу.

  @override
  Widget build(BuildContext context) {
    // Метод, который строит виджет.
    return Scaffold(
      // Создаем Scaffold для основного экрана.
      appBar: AppBar(
        title: const Text('Наш сайт'), // Заголовок панели.
      ),
      body: WebViewWidget(
          controller:
              controller), // Отображаем WebView с указанным контроллером.
    );
  }
}
