class WaterDrink {
  final double quantidade;
  final DateTime createdAt;

  WaterDrink({required this.quantidade, DateTime? createdAt})
    : createdAt = createdAt ?? DateTime.now();
}

bool isSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
         date1.month == date2.month &&
         date1.day == date2.day;
}

class WaterDrinkRepository{
  List<WaterDrink> drinkList = [];
  
  void setDrinkList(List<WaterDrink> waterList){
    drinkList = waterList;
  }

  void addDrink(WaterDrink water){
    drinkList.add(water);
  }

  List<WaterDrink> getDrinkList(){
    return List.from(drinkList);
  }

  List<WaterDrink> getSortedListByDate(DateTime dateFilter){
    return getDrinkList().where((item) => isSameDate(item.createdAt, dateFilter)).toList();
  }

  double getTotalWaterCount(){
    double waterCount = 0;
    for(WaterDrink water in drinkList){
      waterCount += water.quantidade;
    }
    return waterCount;
  }

  double getTodayWaterCount(){
    if(drinkList.isEmpty){
      return 0;
    }

    DateTime today = DateTime.now();
    double waterCount = 0;
    for(WaterDrink water in drinkList){
      if(isSameDate(today, water.createdAt)){
        waterCount += water.quantidade;
      }
    }
    return waterCount;
  }

  double getSpecificDayWaterCount(DateTime date){
    if(drinkList.isEmpty){
      return 0;
    }

    double waterCount = 0;
    for(WaterDrink water in drinkList){
      if(isSameDate(date, water.createdAt)){
        waterCount += water.quantidade;
      }
    }
    return waterCount;
  }
  
  void deleteSpecifDayWaterItems(DateTime date){
    for(WaterDrink water in drinkList){
      if(isSameDate(water.createdAt, date)){
        drinkList.remove(water);
      }
    }
  }

}
