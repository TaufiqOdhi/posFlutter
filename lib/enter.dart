import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos/produk.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EntryForm extends StatefulWidget {
  final Produk produk;

  EntryForm(this.produk);

  @override
  EntryFormState createState() => EntryFormState(this.produk);
}

class EntryFormState extends State<EntryForm> {
  Produk produk;
  bool _error = false;
  bool _errorKode = false;
  bool _errorNama = false;
  bool _errorGambar = false;
  bool _errorHargaJual = false;
  bool _errorHargaBeli = false;
  bool _errorStok = false;
  bool _errorStokKritis = false;
  EntryFormState(this.produk);
  File image;
  File imageUpdate;

  TextEditingController kodeProdukController = TextEditingController();
  TextEditingController namaProdukController = TextEditingController();
  TextEditingController hargaBeliProdukController = TextEditingController();
  TextEditingController hargaJualController = TextEditingController();
  TextEditingController stokKritisProdukController = TextEditingController();
  TextEditingController stokProdukController = TextEditingController();

  Future _barcScan() async {
    var result = await BarcodeScanner.scan();
    kodeProdukController.text = result.rawContent;
  }

  imagePick(ImageSource sumber) async {
    final img = await ImagePicker().getImage(source: sumber);

    if (img != null) {
      if(image != null){//untuk menghapus file lama ketika file gambar diganti
        image.delete();
      }
      if(imageUpdate != null){//untuk menghapus file lama ketika file gambar diganti
        imageUpdate.delete();
      }
      if(produk == null){
        image = File(img.path);
      } else{
        imageUpdate = File(img.path);
      }
      if (sumber == ImageSource.gallery) {
        Directory saveDir = await getExternalStorageDirectory();
        if(produk == null){
          final File img2 = await image.copy(saveDir.path + '/Pictures/posFlutter-' + DateTime.now().toString() + '.jpg');
          image = img2;
        } else{
          final File img2 = await imageUpdate.copy(saveDir.path + '/Pictures/posFlutter-' + DateTime.now().toString() + '.jpg');
          imageUpdate = img2;
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (produk != null) {
      kodeProdukController.text = produk.kodeProduk;
      namaProdukController.text = produk.namaProduk;
      if(produk.gambarProduk != 'tidak ada'){
        image = File(produk.gambarProduk);
      }
      hargaBeliProdukController.text = produk.hargaBeliProduk.toString();
      hargaJualController.text = produk.hargaJualProduk.toString();
      stokKritisProdukController.text = produk.stokKritisProduk.toString();
      stokProdukController.text = produk.stokProduk.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: produk == null ? Text('Tambah') : Text('Rubah'),
        leading: new IconButton(
          icon: new Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.of(context).pop(produk);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(children: <Widget>[
          Padding(
            //kode produk
            padding: EdgeInsets.only(top: 20.0),
            child: TextField(
              controller: kodeProdukController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'kode Produk',
                errorText: _errorKode ? 'Tidak boleh kosong !' : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      'Scan Barcode',
                      textScaleFactor: 1.0,
                    ),
                    onPressed: () {
                      _barcScan();
                    }),
              ),
            ],
          ),
          Padding(
            //nama produk
            padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: TextField(
              controller: namaProdukController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Nama Produk',
                errorText: _errorNama ? 'Tidak boleh kosong !' : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          Padding(
            //gambar produk
            padding: EdgeInsets.only(top: 20.0),
            child: Container(
              child: image == null
                  ? Center(
                      child: Text('No Image Showing'),
                    )
                  : imageUpdate == null
                    ? Image.file(image)
                    : Image.file(imageUpdate),
              height: 200,
              width: 200,
            ),
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      'Pilih Gambar',
                      textScaleFactor: 1.0,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => new AlertDialog(
                                title: new Text(
                                  'Pilih',
                                ),
                                actions: <Widget>[
                                  new GestureDetector(
                                    onTap: () {
                                      imagePick(ImageSource.camera);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Camera",
                                      textScaleFactor: 1.25,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                    ),
                                  ),
                                  new GestureDetector(
                                    onTap: () {
                                      imagePick(ImageSource.gallery);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Gallery",
                                      textScaleFactor: 1.25,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                    ),
                                  ),
                                ],
                              ));
                    }),
              ),
            ],
          ),
          Padding(
            //harga beli produk
            padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: TextField(
              controller: hargaBeliProdukController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Harga Beli Produk',
                errorText: _errorHargaBeli
                    ? 'Tidak boleh kosong dan harus angka !'
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          Padding(
            //harga jual produk
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: TextField(
              controller: hargaJualController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Harga Jual Produk',
                errorText: _errorHargaJual
                    ? 'Tidak boleh kosong dan harus angka !'
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          Padding(
            //stok produk
            padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: TextField(
              controller: stokProdukController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'stok Produk',
                errorText:
                    _errorStok ? 'Tidak boleh kosong dan harus angka !' : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          Padding(
            //stok kritis produk
            padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: TextField(
              controller: stokKritisProdukController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Stok Kritis Produk',
                errorText: _errorStokKritis
                    ? 'Tidak boleh kosong dan harus angka !'
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      'Cancel',
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  width: 5.0,
                ),
                Expanded(
                  child: RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      'Save',
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      setState(() {
                        kodeProdukController.text.isEmpty
                            ? _errorKode = true
                            : _errorKode = false;
                        namaProdukController.text.isEmpty
                            ? _errorNama = true
                            : _errorNama = false;
                        int.tryParse(hargaBeliProdukController.text) == null
                            ? _errorHargaBeli = true
                            : _errorHargaBeli = false;
                        int.tryParse(hargaJualController.text) == null
                            ? _errorHargaJual = true
                            : _errorHargaJual = false;
                        int.tryParse(stokProdukController.text) == null
                            ? _errorStok = true
                            : _errorStok = false;
                        int.tryParse(stokKritisProdukController.text) == null
                            ? _errorStokKritis = true
                            : _errorStokKritis = false;

                        !_errorKode
                            ? !_errorNama
                                ? !_errorGambar
                                    ? !_errorHargaBeli
                                        ? !_errorHargaJual
                                            ? !_errorStok
                                                ? !_errorStokKritis
                                                    ? _error = false
                                                    : _error = true
                                                : _error = true
                                            : _error = true
                                        : _error = true
                                    : _error = true
                                : _error = true
                            : _error = true;
                      });
                      if (!_error) {
                        if (produk == null) {
                          produk = Produk(
                              kodeProdukController.text,
                              namaProdukController.text,
                              image == null ? 'tidak ada':image.path,
                              int.parse(hargaBeliProdukController.text),
                              int.parse(hargaJualController.text),
                              int.parse(stokKritisProdukController.text),
                              int.parse(stokProdukController.text));
                        } else {
                          produk.kodeProduk = kodeProdukController.text;
                          if(imageUpdate == null){
                            image == null ? produk.gambarProduk = 'tidak ada' : produk.gambarProduk = image.path;
                          }else{
                            produk.gambarProduk = imageUpdate.path;
                          }
                          produk.namaProduk = namaProdukController.text;
                          produk.hargaBeliProduk =
                              int.parse(hargaBeliProdukController.text);
                          produk.hargaJualProduk =
                              int.parse(hargaJualController.text);
                          produk.stokKritisProduk =
                              int.parse(stokKritisProdukController.text);
                          produk.stokProduk =
                              int.parse(stokProdukController.text);
                        }
                        Navigator.pop(context, produk);
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => new AlertDialog(
                                  title: new Text(
                                    'Tidak bisa disimpan !',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: new Text(
                                      'Coba cek kembali form yang diisi.'),
                                  actions: <Widget>[
                                    new GestureDetector(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: Text(
                                        "Kembali",
                                        textScaleFactor: 1.25,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                      ),
                                    ),
                                  ],
                                ));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
