import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/bill_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bill_splitter.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE bills(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            billAmount REAL NOT NULL,
            numberOfPeople INTEGER NOT NULL,
            tipPercentage REAL NOT NULL,
            totalAmount REAL NOT NULL,
            perPersonAmount REAL NOT NULL,
            date TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertBill(BillModel bill) async {
    final db = await database;
    return await db.insert('bills', bill.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<BillModel>> getAllBills() async {
    final db = await database;
    final maps = await db.query('bills', orderBy: 'id DESC');
    return maps.map((map) => BillModel.fromMap(map)).toList();
  }

  Future<int> deleteBill(int id) async {
    final db = await database;
    return await db.delete('bills', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllBills() async {
    final db = await database;
    await db.delete('bills');
  }
}
