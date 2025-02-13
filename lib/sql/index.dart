import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class Accounts {
  final int id;
  final String name; // 名称
  final int active; // 激活态
  final String createTime; // 创建时间
  final String updateTime; // 更新时间

  Accounts({
    required this.id,
    required this.name,
    required this.active,
    required this.createTime,
    required this.updateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "active": active,
      "createTime": createTime,
      "updateTime": updateTime,
    };
  }

  factory Accounts.fromMap(Map<String, dynamic> map) {
    return Accounts(
      id: map["id"],
      name: map["name"],
      active: map["active"],
      createTime: map["createTime"],
      updateTime: map["updateTime"],
    );
  }
}

class AccountsParams {
  final String? name;
  final int? active;

  AccountsParams({
    this.name,
    this.active,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name;
    if (active != null) map['active'] = active;
    return map;
  }
}

class AccountItems {
  final int id; // 主键
  final int account; // 账本 -> ACCOUNTS.id
  final String type; // 收入/支出
  final String notes; // 备注
  final String dateTime; // 日期
  final String price; // 数据
  final String subtype; // 类型
  final String createTime; // 创建时间
  final String updateTime; // 修改时间

  AccountItems({
    required this.id,
    required this.account,
    required this.type,
    required this.notes,
    required this.dateTime,
    required this.price,
    required this.subtype,
    required this.createTime,
    required this.updateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "account": account,
      "type": type,
      "notes": notes,
      "dateTime": dateTime,
      "price": price,
      "subtype": subtype,
      "createTime": createTime,
      "updateTime": updateTime,
    };
  }

  factory AccountItems.fromMap(Map<String, dynamic> map) {
    return AccountItems(
      id: map["id"],
      account: map["account"],
      type: map["type"],
      notes: map["notes"],
      dateTime: map["dateTime"],
      price: map["price"],
      subtype: map["subtype"],
      createTime: map["createTime"],
      updateTime: map["updateTime"],
    );
  }
}

class AccountItemsParams {
  final String? type;
  final String? notes;
  final String? dateTime;
  final String? price;
  final String? subtype;

  AccountItemsParams({
    this.type,
    this.notes,
    this.dateTime,
    this.price,
    this.subtype,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (type != null) map["type"] = type;
    if (notes != null) map["notes"] = notes;
    if (dateTime != null) map["dateTime"] = dateTime;
    if (price != null) map["price"] = price;
    if (subtype != null) map["subtype"] = subtype;
    return map;
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    _database ??= await _initDB("myDatabase.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    print('database path: $path');
    // try {
    //   // 删除数据库
    //   await deleteDatabase(path);
    //   print('数据库删除成功');
    // } catch (e) {
    //   print('删除数据库时出错: $e');
    // }
    try {
      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
      );
    } catch (e) {
      print('$e');
      rethrow;
    }
  }

  // database path: /var/mobile/Containers/Data/Application/09E77211-5108-4AF2-9D91-78F2227C0482/Documents/myDatabase.db

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        active INTEGER NOT NULL DEFAULT 0,
        createTime TEXT NOT NULL,
        updateTime TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE AccountItems (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        account INTEGER,
        type TEXT NOT NULL,
        notes TEXT NOT NULL,
        dateTime TEXT NOT NULL,
        price TEXT NOT NULL,
        subtype TEXT NOT NULL,
        createTime TEXT NOT NULL,
        updateTime TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertAccounts(AccountsParams account) async {
    final db = await instance.database;
    var accountData = account.toMap();
    accountData["createTime"] = DateFormat('yyyy/MM/dd').format(DateTime.now());
    accountData["updateTime"] = DateFormat('yyyy/MM/dd').format(DateTime.now());
    return await db.insert('Accounts', accountData);
  }

  Future<int> updateAccounts(int id, AccountsParams updateData) async {
    final db = await instance.database;
    var updateDataMap = updateData.toMap();
    updateDataMap["updateTime"] =
        DateFormat('yyyy/MM/dd').format(DateTime.now());
    return await db.update(
      'Accounts',
      updateDataMap,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Accounts>> getAccounts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('Accounts');
    return List.generate(maps.length, (i) => Accounts.fromMap(maps[i]));
  }

  Future<Accounts> getAccount() async {
    final db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'Accounts',
      where: "active = ?",
      whereArgs: [1],
    );
    // 初始化失败后，可能没有默认数据
    if (maps.isEmpty) {
      await insertAccounts(AccountsParams(name: '默认', active: 1));
      maps = await db.query(
        'Accounts',
        where: "active = ?",
        whereArgs: [1],
      );
    }
    print('maps:====== $maps');
    return List.generate(maps.length, (i) => Accounts.fromMap(maps[i]))[0];
  }

  Future<int> deleteAccounts(int id) async {
    final db = await instance.database;
    return await db.delete(
      'Accounts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertAccountItem(AccountItemsParams accountItem) async {
    final db = await instance.database;
    var accountItemData = accountItem.toMap();
    accountItemData["account"] = (await getAccount()).id;
    accountItemData["createTime"] =
        DateFormat('yyyy/MM/dd').format(DateTime.now());
    accountItemData["updateTime"] =
        DateFormat('yyyy/MM/dd').format(DateTime.now());
    return db.insert('AccountItems', accountItemData);
  }

  Future<int> updateAccountItem(int id, AccountItemsParams updateData) async {
    final db = await instance.database;
    var updateDataMap = updateData.toMap();
    updateDataMap["updateTime"] =
        DateFormat('yyyy/MM/dd').format(DateTime.now());
    return await db.update(
      "AccountItems",
      updateDataMap,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> activeAccount(int id) async {
    final db = await instance.database;
    await db.update(
      "account",
      {
        "active": 0,
        "updateTime": DateFormat('yyyy/MM/dd').format(DateTime.now())
      },
      where: "active = ?",
      whereArgs: [1],
    );
    return await db.update(
      "account",
      {
        "active": 1,
        "updateTime": DateFormat('yyyy/MM/dd').format(DateTime.now())
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<List<AccountItems>> getAccountItems() async {
    var activeAccount = await getAccount();
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'AccountItems',
      where: "account = ? AND SUBSTR(datetime, 1, 7) = ?",
      whereArgs: [activeAccount.id],
    );
    return List.generate(maps.length, (i) => AccountItems.fromMap(maps[i]));
  }

  Future<int> deleteAccountItem(int id) async {
    final db = await instance.database;
    return await db.delete("AccountItems", where: "id = ?", whereArgs: [id]);
  }
}

class DataBaseProvider extends ChangeNotifier {
  static final DataBaseProvider _instance = DataBaseProvider._internal();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  late Accounts _account;
  List<AccountItems> _accountItems = [];

  Accounts get account => _account;
  List<AccountItems> get accountItems => _accountItems;

  factory DataBaseProvider() {
    return _instance;
  }

  DataBaseProvider._internal();

  Future<void> initDatabase() async {
    _account = await _databaseHelper.getAccount();
    _accountItems = await _databaseHelper.getAccountItems();
  }

  Future<void> loadAccount() async {
    _account = await _databaseHelper.getAccount();
    notifyListeners();
  }

  Future<void> addAccount(AccountsParams account) async {
    await _databaseHelper.insertAccounts(account);
    await loadAccount();
  }

  Future<void> updateAccount(int id, AccountsParams updateData) async {
    await _databaseHelper.updateAccounts(id, updateData);
    await loadAccount();
  }

  Future<void> deleteAccount(int id) async {
    await _databaseHelper.deleteAccounts(id);
    await loadAccount();
  }

  Future<void> activeAccount(int id) async {
    await _databaseHelper.activeAccount(id);
  }

  Future<void> loadAccountItems() async {
    _accountItems = await _databaseHelper.getAccountItems();
    notifyListeners();
  }

  Future<void> addAccountItem(AccountItemsParams accountItem) async {
    await _databaseHelper.insertAccountItem(accountItem);
    await loadAccountItems();
  }

  Future<void> updateAccountItem(int id, AccountItemsParams updateData) async {
    await _databaseHelper.updateAccountItem(id, updateData);
    await loadAccountItems();
  }

  Future<void> deleteAccountItem(int id) async {
    await _databaseHelper.deleteAccountItem(id);
    await loadAccountItems();
  }
}
