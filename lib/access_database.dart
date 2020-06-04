import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AccesDatabase{
  Future<Database> initDb() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'produk.db';
    var todoDatabase = openDatabase(path, version: 2, onCreate: _createDb);
    return todoDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute('''CREATE TABLE "produk"
      ( `kode_produk` varchar ( 13 ) NOT NULL, 
      `nama_produk` varchar ( 25 ) NOT NULL, 
      `harga_jual_produk` int ( 9 ) NOT NULL,
      `harga_beli_produk` int ( 9 ) NOT NULL,
      `gambar_produk` varchar ( 150 ) NOT NULL,
      `stok_produk` int ( 3 ) NOT NULL,
      `stok_kritis_produk` int ( 3 ) NOT NULL,
      PRIMARY KEY(`kode_produk`) )
    ''');
  }
}