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
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    updateListView('');
  }

  void updateListView(String filter) {
    setState(() {
      future = dbHelper.getProdukList(filter);
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
      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 5.0),
            child:  TextField(
            decoration: InputDecoration(labelText: "Search something"),
            controller: searchController,
            onChanged: (value) {
              updateListView(value);
            },
            ),
          ),
          FutureBuilder<List<Produk>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                    children:
                        snapshot.data.map((todo) => cardo(todo)).toList());
              } else {
                return SizedBox();
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Tambah Data',
        onPressed: () async {
          var produk = await navigateToEntryForm(context, null);
          if (produk != null) {
            int result = await dbHelper.insert(produk);
            if (result > 0) {
              updateListView('');
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
        onTap: () async {
          var contact2 = await navigateToEntryForm(context, produk);
          if (contact2 != null) {
            int result = await dbHelper.update(contact2);
            if (result > 0) {
              updateListView('');
            }
          }
        },
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.people),
        ),
        title: Text(produk.namaProduk),
        subtitle: Text('Harga: Rp. ' +
            produk.hargaJualProduk.toString() +
            '\nStok: ' +
            produk.stokProduk.toString()),
        trailing: GestureDetector(
          child: Icon(Icons.delete),
          onTap: () async {
            showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                      title: new Text('Apakah anda yakin ?'),
                      content: new Text('Menghapus produk'),
                      actions: <Widget>[
                        new GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Text(
                            "Tidak",
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark),
                          ),
                        ),
                        SizedBox(height: 16),
                        new GestureDetector(
                          onTap: () => deleteProduk(produk),
                          child: Text(
                            "Ya",
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark),
                          ),
                        )
                      ],
                    ));
          },
        ),
      ),
    );
  }

  void deleteProduk(Produk produk) async {
    int result = await dbHelper.delete(produk);
    if (result > 0) {
      updateListView('');
    }
    Navigator.of(context).pop();
  }
}
