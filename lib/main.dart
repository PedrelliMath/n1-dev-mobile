import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pac_iv/repository/water_repository.dart';
import 'package:pac_iv/widgets/water_flow.dart';
import 'package:pac_iv/widgets/water_history.dart';

List<WaterDrink> getRandomWaterList({required int listLength}){
  
  List<WaterDrink> waterDrinkList = [];

  for(var i = 0; i < listLength; i++){
    var day = Random().nextInt(29) + 1;
    var mounth = Random().nextInt(7) + 1;
    var quantidade = Random().nextDouble() * 250;
    var waterDrink = WaterDrink(quantidade: quantidade, createdAt: DateTime(2024, mounth, day));
    waterDrinkList.add(waterDrink);
  }
  return waterDrinkList;
}

void main(){
   
  WaterDrinkRepository waterRepo = WaterDrinkRepository();
  waterRepo.setDrinkList(getRandomWaterList(listLength: 500));

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme(
        brightness: Brightness.light,
        error: Color(0xFFfb6f24),
        onError: Color(0xFFfb6f24),
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFF5191c1),
        primary: Color(0xFF5191c1),
        onPrimary: Color(0xFF0a4b75),
        secondary: Color(0xFF1e6495),
        onSecondary: Color(0xFF1e6495),
        tertiary: Color(0xFF0a4b75)),
      ),
      title: "WaterC",
      initialRoute: '/',
      routes: {
      '/':(contex) => WaterFlow(waterRepository: waterRepo),
      '/history':(context) => WaterHistory(waterRepository: waterRepo)
    },
    ),
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}
