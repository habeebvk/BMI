import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home()
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SharedPreferences _prefs;
  num _height=0,_weight=0,_bmi = 0;
  List<String> _bmihistory = <String>[];
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        _prefs=value;
        _bmihistory=_prefs!.getStringList("bmi history") ?? [];
        _height=_prefs!.getDouble("last input height")?.toDouble() ?? 0;
        _weight=_prefs!.getDouble("last input weight")?.toDouble() ?? 0;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }
  Widget _buildUI(){
    if (_prefs == null) {
      return Center(child: CircularProgressIndicator(),);
    }else{
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.05,
              child: Center(child: Text("${_bmihistory.lastOrNull ?? 00} BMI",style: GoogleFonts.poppins(fontSize: 20),)),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _heightwidget(),
                SizedBox(width: 20,),
                _weightwidget()
              ],
            ),
            SizedBox(height: 20,),
            _calculateBmiButton(),
            Align(
              alignment: Alignment.topLeft,
              child: Text("BMI List",style: GoogleFonts.poppins(fontSize: 20,letterSpacing: 2),)),
            SizedBox(height: 20,),
            historList()
          ],
        )
    
        );
    }
  }
  Widget _heightwidget(){
    return Column(
      children: [
        Text("Height",style: GoogleFonts.poppins(fontSize: 15),),
        InputQty(
          maxVal: double.infinity,
          minVal: 0,
          steps: 1,
          initVal: _height,
          onQtyChanged: (value) {
            _height=value;
            _prefs!.setDouble("last input height",_height.toDouble());
          },
        ),
      ]
    );
    }
    Widget _weightwidget(){
    return Column(
      children: [
        Text("Weight",style: GoogleFonts.poppins(fontSize: 15),),
        InputQty(
          maxVal: double.infinity,
          minVal: 0,
          steps: 1,
          initVal: _weight,
          onQtyChanged: (value) {
            _weight=value;
            _prefs!.setDouble("last input weight",_weight.toDouble());
          },
        ),
      ]
    );
    }
    Widget  _calculateBmiButton(){
         return Padding(padding: EdgeInsets.symmetric(),
         child: MaterialButton(
          color: Colors.amber,
          onPressed: (){
            setState(() {
               double _bmi = pow(_height, 2)/_weight;
              _bmihistory.add(_bmi.toStringAsFixed(2),);
              _prefs!.setStringList("bmi history",_bmihistory);
            });
         },child: Text("Calculate",style: GoogleFonts.poppins(fontSize: 20),),),
         );
    } 
    Widget historList(){
      return Expanded(
        child:ListView.builder(
          itemCount: _bmihistory.length,
          itemBuilder: (context,index){
          return ListTile(
            leading: Text("${index+1}"),
            title:Text(_bmihistory[index],style: GoogleFonts.poppins(fontSize: 15,color: Colors.black),),
            onLongPress: (){
              setState(() {
                _bmihistory.removeAt(index);
                _prefs!.setStringList("bmi history",_bmihistory);
              });
            },
          );
          }
       )
      );
    }
}