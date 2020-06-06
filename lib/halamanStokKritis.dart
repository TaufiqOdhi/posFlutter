import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pos/crud.dart';
import 'package:pos/produk.dart';

class HalamanStokKritis extends StatefulWidget{
  @override
  _HalamanStokKritisState createState() => _HalamanStokKritisState();
}

class _HalamanStokKritisState extends State<HalamanStokKritis>{
  CRUD dbHelper = CRUD();
  Future<List<Produk>> future;

  @override
  void initState() {
    super.initState();
    updateListView();
  }

  void updateListView() {
    setState(() {
      future = dbHelper.getProdukKritisList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Produk Stok Kritis'),
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
    );
  }

  Card cardo(Produk produk) {
    File image;
    if(produk.gambarProduk != 'tidak ada'){
      image = File(produk.gambarProduk);
    }
    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: produk.gambarProduk == 'tidak ada' ? Colors.blue : Colors.transparent,
          child: produk.gambarProduk == 'tidak ada' ? Icon(Icons.image) : Image.file(image),
        ),
        title: Text(produk.namaProduk),
        subtitle: Text('Stok Sisa: '+produk.stokProduk.toString()),
      ),
    );
  }
}