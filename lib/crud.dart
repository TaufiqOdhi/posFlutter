import 'dart:io';
import 'package:pos/access_database.dart';
import 'package:pos/produk.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:firebase_database/firebase_database.dart';

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
  static FirebaseDatabase fireDatabase = new FirebaseDatabase();

  Future<int> insert(Produk todo) async {
    Database db = await dbHelper.initDb();
    int count = await db.insert('produk', todo.toMap());
    await fireDatabase.reference().child('produk').child(todo.kodeProduk).set(todo.toJson());
    return count;
  }

  Future<int> update(Produk todo) async {
    Database db = await dbHelper.initDb();
    int count = await db.update('produk', todo.toMap(), where: 'kode_produk=?', whereArgs: [todo.kodeProduk]);
    await fireDatabase.reference().child('produk').child(todo.kodeProduk).set(todo.toJson());
    return count;
  }

  Future<int> delete(Produk todo) async {
    Database db = await dbHelper.initDb();
    int count = await db.delete('produk', where: 'kode_produk=?', whereArgs: [todo.kodeProduk]);
    await fireDatabase.reference().child('produk').child(todo.kodeProduk).remove();
    File(todo.gambarProduk).delete();
    return count;
  }

  Future<List<Produk>> getProdukList(String filter) async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> mapList;
    if(filter.isEmpty){
      mapList = await db.query('produk', orderBy: 'nama_produk');
      DataSnapshot snap = await fireDatabase.reference().child('produk').orderByChild("nama_produk").once();
      print(snap.value);      
    }else{
      mapList = await db.query('produk', orderBy: 'nama_produk', where: "nama_produk LIKE '%$filter%'");
    }
    int count = mapList.length;
    List<Produk> produkList = List<Produk>();
    for(int i=0; i<count; i++){
      produkList.add(Produk.fromMap(mapList[i]));
    }
    return produkList;
  }

  Future<List<Produk>> getProdukKritisList() async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> mapList = await db.query('produk', where: 'stok_produk <= stok_kritis_produk');
    List<Produk> produkKritisList = List<Produk>();
    for(int i=0; i<mapList.length; i++){
      produkKritisList.add(Produk.fromMap(mapList[i]));
    }
    return produkKritisList;
  }
}