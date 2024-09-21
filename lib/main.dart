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
      theme: ThemeData(
        brightness: Brightness.light
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
      statusBarIconBrightness: Brightness.light,
    ),
  );
}
