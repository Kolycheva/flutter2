// database_helper.dart

import 'package:sqflite/sqflite.dart'; // Импортируем пакет sqflite для работы с SQLite.
import 'package:path/path.dart'; // Импортируем пакет path для работы с путями к файлам.

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal(); // Создаем экземпляр DatabaseHelper.
  factory DatabaseHelper() => _instance; // Фабричный метод для возврата единственного экземпляра.
  static Database? _database; // Переменная для хранения базы данных.

  DatabaseHelper._internal(); // Приватный конструктор.

  Future<Database> get database async { // Метод для получения базы данных.
    if (_database != null) return _database!; // Если база данных уже инициализирована, возвращаем ее.

    _database = await _initDatabase(); // Инициализируем базу данных.
    return _database!; // Возвращаем инициализированную базу данных.
  }

  Future<Database> _initDatabase() async { // Асинхронный метод для инициализации базы данных.
    return await openDatabase( // Открываем базу данных.
      join(await getDatabasesPath(), 'users.db'), // Определяем путь к базе данных.
      onCreate: (db, version) { // Метод, вызываемый при создании базы данных.
        return db.execute( // Создаем таблицу пользователей.
          'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT UNIQUE, password TEXT)',
        );
      },
      version: 1, // Версия базы данных.
    );
  }

  Future<void> insertAdminUser() async { // Метод для вставки администратора в базу данных.
    final db = await database; // Получаем доступ к базе данных.
    await db.insert( // Вставляем администратора в таблицу пользователей.
      'users',
      {'username': 'admin', 'password': 'admin'}, // Данные администратора.
      conflictAlgorithm: ConflictAlgorithm.ignore, // Игнорируем конфликт, если пользователь уже существует.
    );
  }

  Future<bool> authenticateUser(String username, String password) async { // Метод для аутентификации пользователя.
    final db = await database; // Получаем доступ к базе данных.
    final List<Map<String, dynamic>> users = await db.query( // Выполняем запрос к таблице пользователей.
      'users',
      where: 'username = ? AND password = ?', // Условия для поиска пользователя.
      whereArgs: [username, password], // Аргументы для условий.
    );

    return users.isNotEmpty; // Возвращаем true, если пользователь найден.
  }

  Future<void> registerUser(String username, String password) async { // Метод для регистрации нового пользователя.
    final db = await database; // Получаем доступ к базе данных.
    try {
      await db.insert( // Вставляем нового пользователя в таблицу.
        'users',
        {'username': username, 'password': password}, // Данные нового пользователя.
        conflictAlgorithm: ConflictAlgorithm.fail, // Вызываем ошибку, если пользователь уже существует.
      );
    } catch (e) { // Обрабатываем ошибки при регистрации.
      print("Error registering user: $e"); // Выводим сообщение об ошибке.
      throw Exception("User registration failed: $e"); // Генерируем исключение.
    }
  }
}
