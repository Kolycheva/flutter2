// lib/app_localizations.dart

import 'package:flutter/material.dart'; // Импортируем пакет Flutter для работы с материалами (UI-компоненты).
import 'package:flutter/services.dart'; // Импортируем пакет для доступа к ресурсам приложения (например, к файлам).
import 'dart:convert'; // Импортируем пакет для работы с JSON.

class AppLocalizations {
  final Locale locale; // Храним текущую локализацию.
  late Map<String, String> _localizedStrings; // Храним переведенные строки.

  AppLocalizations(this.locale); // Конструктор, принимающий локализацию.

  static AppLocalizations? of(BuildContext context) { // Статический метод для получения экземпляра AppLocalizations из контекста.
    return Localizations.of<AppLocalizations>(context, AppLocalizations); // Возвращаем локализации для текущего контекста.
  }

  Future<bool> load() async { // Асинхронный метод для загрузки локализаций.
    String jsonString = // Загружаем JSON-файл локализаций для текущей локализации.
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString); // Декодируем JSON-строку в карту.

    _localizedStrings = jsonMap.map((key, value) { // Преобразуем карту JSON в карту строк.
      return MapEntry(key, value.toString()); // Создаем записи для локализованных строк.
    });

    return true; // Возвращаем успешный результат загрузки.
  }

  String translate(String key) { // Метод для получения перевода по ключу.
    return _localizedStrings[key] ?? key; // Возвращаем переведенную строку или ключ, если перевод не найден.
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate(); // Конструктор делегата локализаций.

  @override
  bool isSupported(Locale locale) { // Проверка, поддерживается ли локализация.
    return ['en', 'ru'].contains(locale.languageCode); // Поддерживаем только английский и русский.
  }

  @override
  Future<AppLocalizations> load(Locale locale) async { // Метод загрузки локализаций.
    AppLocalizations localizations = AppLocalizations(locale); // Создаем экземпляр AppLocalizations.
    await localizations.load(); // Загружаем локализации.
    return localizations; // Возвращаем экземпляр с загруженными локализациями.
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false; // Указываем, что делегат не нужно перезагружать.
}
