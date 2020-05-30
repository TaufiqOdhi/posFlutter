import 'package:flutter/material.dart';
import 'package:pos/produk.dart';
import 'package:pos/crud.dart';
import 'dart:async';
import 'enter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CRUD dbHelper = CRUD();
  Future<List<Produk>> future;

  @override
  void initState() {
    super.initState();
    updateListView();
  }

  void updateListView() {
    setState(() {
      future = dbHelper.getProdukList();
    });
  }

  Future<Produk> navigateToEntryForm(
      BuildContext context, Produk produk) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryForm(produk);
    }));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Produk'),
      ),
      body: FutureBuilder<List<Produk>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
                children: snapshot.data.map((todo) => cardo(todo)).toList());
          } else {
            return SizedBox();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Tambah Data',
        onPressed: () async {
          var produk = await navigateToEntryForm(context, null);
          if (produk != null) {
            int result = await dbHelper.insert(produk);
            if (result > 0) {
              updateListView();
            }
          }
        },
      ),
    );
  }

  Card cardo(Produk produk) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: ListTile(
        onTap: () async{
          var contact2 = await navigateToEntryForm(context, produk);
          if (contact2 != null){
            int result = await dbHelper.update(contact2);
            if (result > 0){
              updateListView();
            }
          }
        },
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.people),
        ),
        title: Text(produk.namaProduk),
        subtitle: Text('Harga: '+produk.hargaJualProduk.toString()),
        trailing: GestureDetector(
          child: Icon(Icons.delete),
          onTap: () async {
            int result = await dbHelper.delete(produk);
            if (result > 0) {
              updateListView();
            }
          },
        ),
      ),
    );
  }
}