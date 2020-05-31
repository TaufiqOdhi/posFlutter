import 'package:flutter/material.dart';
import 'package:pos/produk.dart';

class EntryForm extends StatefulWidget{
  final Produk produk;

  EntryForm(this.produk);

  @override
  EntryFormState createState() => EntryFormState(this.produk);
}

class EntryFormState extends State<EntryForm>{
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

  TextEditingController kodeProdukController = TextEditingController();
  TextEditingController namaProdukController = TextEditingController();
  TextEditingController gambarProdukController = TextEditingController();
  TextEditingController hargaBeliProdukController = TextEditingController();
  TextEditingController hargaJualController = TextEditingController();
  TextEditingController stokKritisProdukController = TextEditingController();
  TextEditingController stokProdukController = TextEditingController();

  @override
  Widget build(BuildContext context){
    if(produk != null){
      kodeProdukController.text = produk.kodeProduk;
      namaProdukController.text = produk.namaProduk;
      gambarProdukController.text = produk.gambarProduk;
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
        padding: EdgeInsets.only(top: 15.0, left:10.0, right:10.0),
        child: ListView(
          children: <Widget> [
            Padding(//kode produk
              padding: EdgeInsets.only(top:20.0, bottom:10.0),
              child: TextField(
                controller: kodeProdukController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'kode Produk',
                  errorText: _errorKode ? 'Kode Tidak boleh kosong !' : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(//nama produk
              padding: EdgeInsets.only(top:20.0, bottom:10.0),
              child: TextField(
                controller: namaProdukController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  errorText: _errorNama ? 'Nama Tidak boleh kosong !' : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(//gambar produk
              padding: EdgeInsets.only(top:20.0, bottom:10.0),
              child: TextField(
                controller: gambarProdukController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Gambar Produk',
                  errorText: _errorGambar ? 'Gambar Tidak boleh kosong !' : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(//harga beli produk
              padding: EdgeInsets.only(top:20.0, bottom:10.0),
              child: TextField(
                controller: hargaBeliProdukController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga Beli Produk',
                  errorText: _errorHargaBeli ? 'Beli Tidak boleh kosong !' : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(//harga jual produk
              padding: EdgeInsets.only(top:20.0, bottom:20.0),
              child: TextField(
                controller: hargaJualController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga Jual Produk',
                  errorText: _errorHargaJual ? 'Jual Tidak boleh kosong !' : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(//stok produk
              padding: EdgeInsets.only(top:20.0, bottom:10.0),
              child: TextField(
                controller: stokProdukController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'stok Produk',
                  errorText: _errorStok ? 'Stok Tidak boleh kosong !' : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(//stok kritis produk
              padding: EdgeInsets.only(top:20.0, bottom:10.0),
              child: TextField(
                controller: stokKritisProdukController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stok Kritis Produk',
                  errorText: _errorStokKritis ? 'Kritis Tidak boleh kosong !' : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top:20.0, bottom:20.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Save',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: (){
                        setState(() {
                          kodeProdukController.text.isEmpty ? _errorKode = true : _errorKode = false;
                          namaProdukController.text.isEmpty ? _errorNama = true : _errorNama = false;
                          gambarProdukController.text.isEmpty ? _errorGambar = true : _errorGambar = false;
                          hargaBeliProdukController.text.isEmpty ? _errorHargaBeli = true : _errorHargaBeli = false;
                          hargaJualController.text.isEmpty ? _errorHargaJual = true : _errorHargaJual = false;
                          stokProdukController.text.isEmpty ? _errorStok = true : _errorStok = false;
                          stokKritisProdukController.text.isEmpty ? _errorStokKritis = true : _errorStokKritis = false;
                          
                          !_errorKode ? !_errorNama ? !_errorGambar ? !_errorHargaBeli ? !_errorHargaJual ? !_errorStok ? 
                          !_errorStokKritis ? _error = false : _error = true
                          : _error = true: _error = true: _error = true: _error = true: _error = true: _error = true;
                        });
                        if(!_error){
                          if(produk == null){
                            produk = Produk(
                            kodeProdukController.text,
                            namaProdukController.text,
                            gambarProdukController.text,
                            int.parse(hargaBeliProdukController.text),
                            int.parse(hargaJualController.text),
                            int.parse(stokKritisProdukController.text),
                            int.parse(stokProdukController.text)
                          );
                          }else{
                            produk.kodeProduk = kodeProdukController.text;
                            produk.gambarProduk = gambarProdukController.text;
                            produk.namaProduk = namaProdukController.text;
                            produk.hargaBeliProduk = int.parse(hargaBeliProdukController.text);
                            produk.hargaJualProduk = int.parse(hargaJualController.text);
                            produk.stokKritisProduk = int.parse(stokKritisProdukController.text);
                            produk.stokProduk = int.parse(stokProdukController.text);
                          }
                          Navigator.pop(context, produk);
                        }
                      },
                    ),
                  ),
                  Container(width: 5.0,),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Cancel',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }

}