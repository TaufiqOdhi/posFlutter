import 'package:flutter/material.dart';
import 'package:pos/halamanStokKritis.dart';
import 'package:pos/home.dart';

class SlideHalaman extends StatefulWidget {
  @override
  _SlideHalamanState createState() => _SlideHalamanState();
}

class _SlideHalamanState extends State<SlideHalaman>{
  PageController _controller = PageController(
    initialPage: 0,
    //viewportFraction: 0.8,
  );

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return PageView(
      controller: _controller,
      children: <Widget>[
        Home(),
        HalamanStokKritis(),
      ],
    );
  }
}