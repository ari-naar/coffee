import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'base_service.dart';

class StorageService extends BaseService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late Database _db;

  Future<void> initialize() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'coffee_app.db');

      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          // Create coffee shops table
          await db.execute('''
            CREATE TABLE coffee_shops (
              id TEXT PRIMARY KEY,
              name TEXT NOT NULL,
              address TEXT NOT NULL,
              latitude REAL NOT NULL,
              longitude REAL NOT NULL,
              rating REAL NOT NULL,
              reviewCount INTEGER NOT NULL,
              imageUrl TEXT,
              isOpen INTEGER NOT NULL,
              highlights TEXT
            )
          ''');

          // Create reviews table
          await db.execute('''
            CREATE TABLE reviews (
              id TEXT PRIMARY KEY,
              userId TEXT NOT NULL,
              shopId TEXT NOT NULL,
              coffeeType TEXT NOT NULL,
              rating REAL NOT NULL,
              review TEXT NOT NULL,
              flavorNotes TEXT NOT NULL,
              createdAt INTEGER NOT NULL,
              imageUrl TEXT
            )
          ''');
        },
      );

      logInfo('Storage service initialized');
    } catch (e) {
      logError('Failed to initialize storage service', e);
      rethrow;
    }
  }

  Database get db => _db;
}
