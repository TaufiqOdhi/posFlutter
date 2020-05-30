class Produk{
  String _kodeProduk;
  String _namaProduk;
  String _gambarProduk;
  int _hargaJualProduk;
  int _hargaBeliProduk;
  int _stokProduk;
  int _stokKritisProduk;

  Produk(
    this._kodeProduk,
    this._namaProduk,
    this._gambarProduk,
    this._hargaBeliProduk,
    this._hargaJualProduk,
    this._stokKritisProduk,
    this._stokProduk
  );

  Produk.fromMap(Map<String, dynamic> map){
    this._kodeProduk = map['kode_produk'];
    this._namaProduk = map['nama_produk'];
    this._gambarProduk = map['gambar_produk'];
    this._hargaBeliProduk = map['harga_beli_produk'];
    this._hargaJualProduk = map['harga_jual_produk'];
    this._stokProduk = map['stok_produk'];
    this._stokKritisProduk = map['stok_kritis_produk'];
  }

  String get kodeProduk => _kodeProduk;
  String get namaProduk => _namaProduk;
  String get gambarProduk => _gambarProduk;
  int get hargaJualProduk => _hargaJualProduk;
  int get hargaBeliProduk => _hargaBeliProduk;
  int get stokProduk => _stokProduk;
  int get stokKritisProduk => _stokKritisProduk;

  set kodeProduk(String value){
    _kodeProduk = value;
  }

  set namaProduk(String value){
    _namaProduk = value;
  }

  set gambarProduk(String value){
    _gambarProduk = value;
  }

  set hargaJualProduk(int value){
    _hargaJualProduk = value;
  }

  set hargaBeliProduk(int value){
    _hargaBeliProduk = value;
  }

  set stokProduk(int value){
    _stokProduk = value;
  }

  set stokKritisProduk(int value){
    _stokKritisProduk = value;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = Map<String, dynamic>();
    map['kode_produk'] = this.kodeProduk;
    map['nama_produk'] = namaProduk;
    map['gambar_produk'] = gambarProduk;
    map['harga_jual_produk'] = hargaJualProduk;
    map['harga_beli_produk'] = hargaBeliProduk;
    map['stok_produk'] = stokProduk;
    map['stok_kritis_produk'] = stokKritisProduk;
    return map;
  }
}