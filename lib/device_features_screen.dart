import 'package:flutter/material.dart'; // Импортируем пакет Flutter для работы с материалами (UI-компоненты).
import 'package:device_info_plus/device_info_plus.dart'; // Импортируем пакет для получения информации об устройстве.

class DeviceFeaturesScreen extends StatelessWidget { // Определяем StatelessWidget для экрана функций устройства.
  @override
  Widget build(BuildContext context) { // Метод, который строит виджет.
    return Scaffold( // Создаем Scaffold для основной структуры страницы.
      appBar: AppBar( // Создаем верхнюю панель приложения.
        title: Text('Функции устройства'), // Заголовок панели.
      ),
      body: SingleChildScrollView( // Позволяем прокручивать содержимое.
        child: Padding( // Отступы вокруг содержимого.
          padding: const EdgeInsets.all(16.0),
          child: Column( // Столбец для размещения информации.
            crossAxisAlignment: CrossAxisAlignment.start, // Выравнивание по левому краю.
            children: [
              _buildSectionTitle('Поддерживаемые функции', Icons.info), // Заголовок секции с иконкой.
              Divider(), // Разделительная линия.
              _buildFeaturesSection(), // Раздел для отображения поддерживаемых функций устройства.
            ],
          ),
        ),
      ),
    );
  }

  // Метод для создания заголовка секции с иконкой.
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row( // Строка для размещения иконки и текста.
      children: [
        Icon(icon, size: 28, color: Color.fromARGB(255, 44, 110, 209)), // Иконка секции.
        SizedBox(width: 10), // Отступ между иконкой и текстом.
        Text(
          title, // Заголовок секции.
          style: TextStyle(
            fontSize: 20, // Размер шрифта.
            fontWeight: FontWeight.bold, // Жирный шрифт.
          ),
        ),
      ],
    );
  }

  // Раздел для отображения поддерживаемых функций устройства.
  Widget _buildFeaturesSection() {
    return FutureBuilder<List<String>>( // Используем FutureBuilder для асинхронной загрузки функций устройства.
      future: _getDeviceFeatures(), // Асинхронная функция для получения функций устройства.
      builder: (context, snapshot) { // Строим виджет в зависимости от состояния загрузки.
        if (snapshot.connectionState == ConnectionState.waiting) { // Если данные все еще загружаются.
          return Center(child: CircularProgressIndicator()); // Показываем индикатор загрузки.
        } else if (snapshot.hasError) { // Если произошла ошибка при загрузке.
          return Center(child: Text('Ошибка: ${snapshot.error}')); // Показываем сообщение об ошибке.
        } else {
          List<String> features = snapshot.data ?? []; // Получаем список поддерживаемых функций или пустой список.
          return ListView.builder( // Создаем список поддерживаемых функций.
            shrinkWrap: true, // Уменьшаем размер списка до необходимого.
            physics: NeverScrollableScrollPhysics(), // Отключаем прокрутку списка.
            itemCount: features.length, // Количество элементов в списке.
            itemBuilder: (context, index) { // Метод для создания элементов списка.
              final feature = features[index]; // Получаем функцию по индексу.
              return Card( // Карточка для отображения функции.
                margin: const EdgeInsets.symmetric(vertical: 8), // Отступы по вертикали.
                shape: RoundedRectangleBorder( // Оформление карточки.
                  borderRadius: BorderRadius.circular(10), // Скругленные углы.
                ),
                child: ListTile( // Элемент списка.
                  leading: Icon(Icons.check, color: Color.fromARGB(255, 44, 110, 209)), // Иконка проверки.
                  title: Text(feature), // Название функции.
                ),
              );
            },
          );
        }
      },
    );
  }

  // Получаем список поддерживаемых функций устройства.
  Future<List<String>> _getDeviceFeatures() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin(); // Создаем экземпляр DeviceInfoPlugin.
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo; // Получаем информацию об устройстве Android.

    // Возвращаем список поддерживаемых функций устройства.
    return androidInfo.systemFeatures; // Возвращаем список функций.
  }
}
