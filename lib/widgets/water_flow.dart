import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:pac_iv/repository/water_repository.dart';

class MyPainter extends CustomPainter {
  final double heightFactor;
  final double firstValue;
  final double secondValue;
  final double thirdValue;
  final double fourthValue;

  MyPainter(
    this.heightFactor,
    this.firstValue,
    this.secondValue,
    this.thirdValue,
    this.fourthValue,
  );
  
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xFF0A4B75).withOpacity(.8)
      ..style = PaintingStyle.fill;

    var path = Path()
      ..moveTo(0, (size.height / firstValue) * heightFactor)
      ..cubicTo(
        size.width * .9,
        (size.height / secondValue) * heightFactor,
        size.width * 1.5,
        (size.height / thirdValue) * heightFactor,
        size.width,
        (size.height / fourthValue) * heightFactor,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }
 
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class WaterFlow extends StatefulWidget {
  final WaterDrinkRepository waterRepository;
  const WaterFlow({super.key, required this.waterRepository});

  @override
  State<WaterFlow> createState() => _WaterFlowState();
}

class _WaterFlowState extends State<WaterFlow> 
  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  
  late double waterCount;
  late double waterLevel;
  double meta = 2000.0;

  late AnimationController firstController;
  late Animation<double> firstAnimation;

  late AnimationController secondController;
  late Animation<double> secondAnimation;

  late AnimationController thirdController;
  late Animation<double> thirdAnimation;

  late AnimationController fourthController;
  late Animation<double> fourthAnimation;
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    waterCount = widget.waterRepository.getTodayWaterCount();
    waterLevel = screenFactor(waterCount);
    firstController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    firstAnimation = Tween<double>(begin: 1.9, end: 2.1).animate(
        CurvedAnimation(parent: firstController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          firstController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          firstController.forward();
        }
      });

    secondController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    secondAnimation = Tween<double>(begin: 1.8, end: 2.4).animate(
        CurvedAnimation(parent: secondController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          secondController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          secondController.forward();
        }
      });

    thirdController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    thirdAnimation = Tween<double>(begin: 1.8, end: 2.4).animate(
        CurvedAnimation(parent: thirdController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          thirdController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          thirdController.forward();
        }
      });

    fourthController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    fourthAnimation = Tween<double>(begin: 1.9, end: 2.1).animate(
        CurvedAnimation(parent: fourthController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          fourthController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          fourthController.forward();
        }
      });

    Timer(const Duration(seconds: 2), () {
      firstController.forward();
    });

    Timer(const Duration(milliseconds: 1600), () {
      secondController.forward();
    });

    Timer(const Duration(milliseconds: 800), () {
      thirdController.forward();
    });

    fourthController.forward();

  }

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    fourthController.dispose();
    super.dispose();
  }

  void _addWaterToList(String value, double meta){
    setState(() {
    WaterDrink newWaterDrink = WaterDrink(quantidade: double.tryParse(value) ?? 0.0);
    widget.waterRepository.addDrink(newWaterDrink);
    waterCount = widget.waterRepository.getTodayWaterCount();
    waterLevel = screenFactor(waterCount);
    });
  }

  double getMeta(){
    return meta;
  }

  double screenFactor(double waterAmount) {
    double minFactor = 0.01;
    double maxFactor = 2.0;
    double maxWater = getMeta();
    waterAmount = waterAmount.clamp(0.01, maxWater);
    double normalizedWaterAmount = waterAmount / maxWater;
    double factor = minFactor + (maxFactor - minFactor) * (1.0 - normalizedWaterAmount);
    
    return factor;
  }

  void deleteTodayWaterCount(){
    setState(() {
          widget.waterRepository.deleteSpecifDayWaterItems(DateTime.now());
          waterCount = widget.waterRepository.getTodayWaterCount();
          waterLevel = screenFactor(waterCount);
        });
  }
 
  void _showMenuDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      double tempMeta = meta;
      return AlertDialog(
        title: const Text('Configurar meta'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Slider(
                    label: tempMeta.toString(),
                    min: 0,
                    max: 3500.0,
                    value: tempMeta,
                    onChanged: (double value) {
                      setState(() {
                        tempMeta = value;
                      });
                    },
                  ),
                  Text('Meta diária: ${tempMeta.toStringAsFixed(0)}'),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: deleteTodayWaterCount, child: const Text('Zerar')),
          TextButton(
            onPressed: () {
              setState(() {
                meta = tempMeta; // Atualiza o valor real de meta ao confirmar
              });
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void _showInputDialog() {
    String input = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicione água'),
          content: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(hintText: 'Quantidade de água ml'),
            onChanged: (value) {
              input = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha a caixa de diálogo
              },
                child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _addWaterToList(input, meta); // Adiciona o valor à lista
                Navigator.of(context).pop(); // Fecha a caixa de diálogo
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
  super.build(context);
  Size size = MediaQuery.of(context).size;
    return Scaffold(
          appBar: AppBar(title: Text('Meta: ${getMeta().toStringAsFixed(0)}'), leading:  IconButton(icon: Icon(Icons.arrow_right),
              onPressed: (){Navigator.pushNamed(context, '/history');}
            ),
            actions: [
              IconButton(icon: Icon(Icons.menu), onPressed: _showMenuDialog)
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xFFFB6F24),
            child: Icon(Icons.add),
            onPressed: _showInputDialog,
          ),
          body: Stack(
            children: [
              Center(
                child: Text(
                  '${waterCount}ml',
                  style: TextStyle(
                  fontWeight: FontWeight.w600,
                  wordSpacing: 1,
                  color: Color(0XFF0a4b75),
                ),
                textScaleFactor: 3,
              ),
            ),
            CustomPaint(
              painter: MyPainter(
                waterLevel,
                firstAnimation.value,
                secondAnimation.value,
                thirdAnimation.value,
                fourthAnimation.value,
            ),
            child: SizedBox(
              height: size.height,
              width: size.width,
              ),
            ),
          ]
          )
        );
    }
}
