import 'package:flutter/material.dart';
import 'package:pac_iv/repository/water_repository.dart';
import 'package:pac_iv/widgets/date_picker.dart';


class WaterListItem extends StatelessWidget {
  DateTime date;
  double quantidade;
  WaterListItem({super.key, required this.date, required this.quantidade});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text("${quantidade.toStringAsFixed(2)}ml ${date.day}/${date.month}/${date.year}"),
      )
    );
  }
}

class WaterHistory extends StatefulWidget {
  final WaterDrinkRepository waterRepository;
  WaterHistory({super.key, required this.waterRepository});

  @override
  State<WaterHistory> createState() => _WaterHistory();
}

class _WaterHistory extends State<WaterHistory> {
  
  late List<WaterListItem> waterListItemWidgetList;

  List<WaterListItem> getWaterListItemWidget(List<WaterDrink> waterList) {
    return waterList.reversed.map((water) {
      return WaterListItem(
        date: water.createdAt,
        quantidade: water.quantidade,
      );
    }).toList();
  }
 
  @override
    void initState() {
      waterListItemWidgetList = getWaterListItemWidget(widget.waterRepository.getDrinkList());
      super.initState();
    }
    
  bool isSameDate(DateTime date1, DateTime date2){
    return date1.day == date2.day &&
          date1.month == date2.month &&
          date1.year == date2.year;
  }

  void filterWaterList(DateTime dateFilter){
    setState(() {
          waterListItemWidgetList = waterListItemWidgetList.where((i) => isSameDate(i.date, dateFilter)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF1E6495),
              title: const Text('Histórico'),
            ),
            body: Column(
              children:[
                Padding(padding: EdgeInsets.all(10.0), child: DatePickerExample(getDateCallback: filterWaterList)), 
                Expanded(child:ListView(children: waterListItemWidgetList))
              ]
            )
          );
  }
}
