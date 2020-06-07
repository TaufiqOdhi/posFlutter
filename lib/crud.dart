import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pos/access_database.dart';
import 'package:pos/produk.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:firebase_database/firebase_database.dart';

class CRUD {
  static const todoTable = 'produk';
  static const kodeProduk = 'kode_produk';
  static const namaProduk = 'naam_produk';
  static const gambarProduk = 'gambar_produk';
  static const hargaJualProduk = 'harga_jual_produk';
  static const hargaBeliProduk = 'harga_beli_produk';
  static const stokProduk = 'stok_produk';
  static const stokKritisProduk = 'stok_kritis_produk';
  AccesDatabase dbHelper = new AccesDatabase();

  Future<int> insert(Produk todo) async {
    Database db = await dbHelper.initDb();
    int count = await db.insert('produk', todo.toMap());
    await FirebaseDatabase.instance
        .reference()
        .child('produk')
        .child(todo.kodeProduk)
        .set(todo.toJson());
    File fileImage = File(todo.gambarProduk);
    StorageReference storageReference = FirebaseStorage.instance.ref().child('imageProduk');
    StorageUploadTask uploadTask = storageReference.
      child(todo.gambarProduk.split('/storage/emulated/0/Android/data/com.example.pos/files/Pictures/')[1]).putFile(fileImage);
    await uploadTask.onComplete;
    return count;
  }

  Future<int> update(Produk todo, String oldKodeProduk) async {
    Database db = await dbHelper.initDb();
    int count = await db.update('produk', todo.toMap(),
        where: 'kode_produk=?', whereArgs: [oldKodeProduk]);
    if(todo.kodeProduk == oldKodeProduk){
      await FirebaseDatabase.instance
        .reference()
        .child('produk')
        .child(todo.kodeProduk)
        .update(todo.toJson());
    }else{
      await FirebaseDatabase.instance
        .reference()
        .child('produk')
        .child(todo.kodeProduk)
        .update(todo.toJson());
      await FirebaseDatabase.instance
        .reference()
        .child('produk')
        .child(oldKodeProduk)
        .remove();
    }
    File fileImage = File(todo.gambarProduk);
    StorageReference storageReference = FirebaseStorage.instance.ref().child('imageProduk');
    StorageUploadTask uploadTask = storageReference.
      child(todo.gambarProduk.split('/storage/emulated/0/Android/data/com.example.pos/files/Pictures/')[1]).putFile(fileImage);
    await uploadTask.onComplete;
    return count;
  }

  Future<int> delete(Produk todo) async {
    Database db = await dbHelper.initDb();
    int count = await db
        .delete('produk', where: 'kode_produk=?', whereArgs: [todo.kodeProduk]);
    await FirebaseDatabase.instance
        .reference()
        .child('produk')
        .child(todo.kodeProduk)
        .remove();
    File(todo.gambarProduk).delete();
    return count;
  }

  Future<List<Produk>> getProdukList(String filter) async {
    // Database db = await dbHelper.initDb();
    // List<Map<String, dynamic>> mapList;
    List<Produk> produkList = List<Produk>();
    DataSnapshot snap;
    if (filter.isEmpty) {
      //mapList = await db.query('produk', orderBy: 'nama_produk');
      snap = await FirebaseDatabase.instance.reference().child('produk').orderByChild('nama_produk').once();
    } else {
      //mapList = await db.query('produk', orderBy: 'nama_produk', where: "nama_produk LIKE '%$filter%'");
      snap = await FirebaseDatabase.instance
          .reference()
          .child('produk')
          .orderByChild('nama_produk')
          .startAt(filter)
          .endAt(filter + '\uf8ff')
          .once();
    }
    // int count = mapList.length;
    // for(int i=0; i<count; i++){
    //   produkList.add(Produk.fromMap(mapList[i]));
    // }
    Map<dynamic, dynamic> values = snap.value;
    produkList.clear();
    if (values != null) {
      values.forEach((key, value) async {
        Produk produk1 = Produk(
            key,
            value['nama_produk'],
            value['gambar_produk'],
            int.parse(value['harga_beli_produk'].toString()),
            int.parse(value['harga_jual_produk'].toString()),
            int.parse(value['stok_kritis_produk'].toString()),
            int.parse(value['stok_produk'].toString()));
        produkList.add(produk1);

        await File(produk1.gambarProduk).exists().then((value) async {
          if(value == false){
            print('masuk if di getProdukList');
            await downloadImage(produk1);
          }
        });
      });
    }
    return produkList;
  }

  Future<List<Produk>> getProdukKritisList() async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> mapList =
        await db.query('produk', where: 'stok_produk <= stok_kritis_produk');
    List<Produk> produkKritisList = List<Produk>();
    for (int i = 0; i < mapList.length; i++) {
      produkKritisList.add(Produk.fromMap(mapList[i]));
    }
    // DataSnapshot snap = await FirebaseDatabase.instance.reference().child('produk').orderByChild('stok_produk'<='stok_kritis_produk').once();
    // Map<dynamic, dynamic> values = snap.value;
    // produkKritisList.clear();
    // values.forEach((key, value) {

    // });
    return produkKritisList;
  }

  Future<File> downloadImage(Produk produk) async{
    File file = File(produk.gambarProduk);
    //file.writeAsString('');
    StorageReference storageReference = FirebaseStorage.instance.ref().child('imageProduk');
    print('sebelum download');
    StorageFileDownloadTask downloadTask = storageReference
      .child(produk.gambarProduk.split('/storage/emulated/0/Android/data/com.example.pos/files/Pictures/')[1]).writeToFile(file);       
    await downloadTask.future;
    print('selesai download');
    return file;
  }
}
