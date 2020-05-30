import 'package:pos/access_database.dart';
import 'package:pos/produk.dart';
import 'package:sqflite/sqlite_api.dart';

class CRUD{
  static const todoTable = 'produk';
  static const kodeProduk = 'kode_produk';
  static const namaProduk  = 'naam_produk';
  static const gambarProduk = 'gambar_produk';
  static const hargaJualProduk = 'harga_jual_produk';
  static const hargaBeliProduk = 'harga_beli_produk';
  static const stokProduk = 'stok_produk';
  static const stokKritisProduk = 'stok_kritis_produk';
  AccesDatabase dbHelper = new AccesDatabase();

  Future<int> insert(Produk todo) async {
    Database db = await dbHelper.initDb();
    int count = await db.insert('produk', todo.toMap());
    return count;
  }

  Future<int> update(Produk todo) async {
    Database db = await dbHelper.initDb();
    int count = await db.update('produk', todo.toMap(), where: 'kode_produk=?', whereArgs: [todo.kodeProduk]);
    return count;
  }

  Future<int> delete(Produk todo) async {
    Database db = await dbHelper.initDb();
    int count = await db.delete('produk', where: 'kode_produk=?', whereArgs: [todo.kodeProduk]);
    return count;
  }

  Future<List<Produk>> getProdukList() async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> mapList = await db.query('produk', orderBy: 'nama_produk');
    int count = mapList.length;
    List<Produk> produkList = List<Produk>();
    for(int i=0; i<count; i++){
      produkList.add(Produk.fromMap(mapList[i]));
    }
    return produkList;
  }
}