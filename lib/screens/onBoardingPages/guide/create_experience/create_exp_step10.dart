import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_pe/screens/onBoardingPages/guide/create_experience/created_experience.dart';

import '../../../../models/step_list_response.dart';
import '../../../../resources/resources.dart';
import '../../../../services/app_service.dart';
import '../../../../utils/responsive_size.dart';
import '../../../../utils/utils.dart';

class CreateExpStep10 extends StatefulWidget {
  CreateExpStep10({super.key, required this.sendListMap});
  Map<String, dynamic> sendListMap = {};

  @override
  State<CreateExpStep10> createState() => _CreateExpStep10State();
}

class _CreateExpStep10State extends State<CreateExpStep10> {
  late Future<List<StepListResponse>> _choicesFuture;
  late List<Voyage> myList = [];
  Map<String, Set<Object>> myMap = {};
  int _counter = 3;

  @override
  void initState() {
    super.initState();
    _choicesFuture = AppService.api.fetchChoices('guide_personnes_peuves_participer');
    _loadChoices();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  Future<void> _loadChoices() async {
    try {
      final choices = await _choicesFuture;
      for (var choice in choices) {
        var newVoyage = Voyage(id: choice.id, title: choice.choiceTxt);
        if (!myList.contains(newVoyage)) {
          setState(() {
            myList.add(newVoyage);
          });
        }
      }
    } catch (error) {
      // Handle error if fetching data fails
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<StepListResponse>>(
          future: _choicesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final choices = snapshot.data!;
              // Display your choices here
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppResources.colorGray5, AppResources.colorWhite],
                  ),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(children: [
                        Image.asset(
                          'images/backgroundExp8.png',
                          width: double.infinity,
                          fit: BoxFit.fill,
                          height: ResponsiveSize.calculateHeight(190, context),
                        ),
                        Positioned(
                          top: 48,
                          left: 28,
                          child: Container(
                            width: ResponsiveSize.calculateWidth(24, context),
                            height: ResponsiveSize.calculateHeight(24, context),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    ResponsiveSize.calculateCornerRadius(40, context)),
                              ),
                            ),
                            child: FloatingActionButton(
                                heroTag: "btn1",
                                backgroundColor: AppResources.colorWhite,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  String.fromCharCode(CupertinoIcons.back.codePoint),
                                  style: TextStyle(
                                    inherit: false,
                                    color: AppResources.colorVitamine,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: CupertinoIcons
                                        .exclamationmark_circle.fontFamily,
                                    package: CupertinoIcons
                                        .exclamationmark_circle.fontPackage,
                                  ),
                                )),
                          ),
                        ),
                      ]),
                      SizedBox(height: ResponsiveSize.calculateHeight(40, context)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(28.0, context)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Étape 8 sur 8',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                                height: ResponsiveSize.calculateHeight(8, context)),
                            Text(
                              'Et avec qui ?',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            SizedBox(
                                height: ResponsiveSize.calculateHeight(16, context)),
                            Text(
                              'A 2, à 3, à 4 ou plus ? Dis-nous combien de voyageurs peuvent venir vivre ton expérience',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(
                                height: ResponsiveSize.calculateHeight(40, context)),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppResources.colorGray45,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: _decrementCounter,
                                    icon: Icon(Icons.remove, color: AppResources.colorGray75),
                                  ),
                                ),
                                SizedBox(
                                    width: ResponsiveSize.calculateWidth(18, context)),
                                Text(
                                  '$_counter',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16),
                                ),
                                SizedBox(
                                    width: ResponsiveSize.calculateWidth(18, context)),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppResources.colorGray45,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: _incrementCounter,
                                    icon: Icon(Icons.add, color: AppResources.colorGray75),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: ResponsiveSize.calculateHeight(56, context)),
                            Text(
                              'Sélectionne les personnes qui peuvent participer à ton expérience : ',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(
                                height: ResponsiveSize.calculateHeight(20, context)),
                            Container(
                              width: double.infinity,
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                spacing: ResponsiveSize.calculateWidth(8, context), // Horizontal spacing between items
                                runSpacing: ResponsiveSize.calculateHeight(12, context), // Vertical spacing between lines
                                children: myList.map((item) {
                                  return Item(
                                    id: item.id,
                                    text: item.title,
                                    isSelected: myMap['guide_personnes_peuves_participer'] != null
                                        ? myMap['guide_personnes_peuves_participer']!.contains(item.id)
                                        : false,
                                    onTap: () {
                                      setState(() {
                                        if (myMap['guide_personnes_peuves_participer'] == null) {
                                          myMap['guide_personnes_peuves_participer'] =
                                              Set<int>(); // Initialize if null
                                        }

                                        if (myMap['guide_personnes_peuves_participer']!.contains(item.id)) {
                                          myMap['guide_personnes_peuves_participer']!.remove(item.id);
                                        } else {
                                          myMap['guide_personnes_peuves_participer']!.add(item.id);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: ResponsiveSize.calculateHeight(44, context),
                            ),
                            child: Container(
                              width: ResponsiveSize.calculateWidth(319, context),
                              height: ResponsiveSize.calculateHeight(44, context),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                      EdgeInsets.symmetric(
                                          horizontal: ResponsiveSize.calculateHeight(
                                              24, context),
                                          vertical: ResponsiveSize.calculateHeight(
                                              10, context))),
                                  backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.disabled)) {
                                        return AppResources
                                            .colorGray15; // Change to your desired grey color
                                      }
                                      return AppResources
                                          .colorVitamine; // Your enabled color
                                    },
                                  ),
                                  shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  widget.sendListMap['nombre_des_voyageur'] = _counter;
                                  // Convert sets to lists
                                  myMap.forEach((key, value) {
                                    widget.sendListMap[key] = value.toList();
                                  });
                                  final response = await AppService.api.makeExperienceGuide2(widget.sendListMap);
                                  if(response.experience.id != null) {
                                    navigateTo(context, (_) => CreatedExperience());
                                  }
                                },
                                child: Text(
                                  'POSTER MON EXPÉRIENCE',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorWhite)
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}

class Item extends StatefulWidget {
  final int id;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const Item({
    required this.id,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: IntrinsicWidth(
        child: Container(
          height: ResponsiveSize.calculateHeight(40, context),
          padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.calculateWidth(16, context),
              vertical: ResponsiveSize.calculateHeight(10, context) - 3),
          decoration: BoxDecoration(
            color: widget.isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(
                ResponsiveSize.calculateCornerRadius(24, context))),
            border: Border.all(color: AppResources.colorGray100),
          ),
          child: Center(
            child: Row(
              children: [
                Icon(
                  Icons.ac_unit,
                  size: 10,
                  color: widget.isSelected
                      ? Colors.white
                      : AppResources.colorGray100,
                ),
                SizedBox(width: ResponsiveSize.calculateWidth(4, context)),
                Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: widget.isSelected
                        ? Colors.white
                        : AppResources.colorGray100,
                    fontWeight:
                    widget.isSelected ? FontWeight.w500 : FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Voyage {
  final int id;
  final String title;

  Voyage({
    required this.id,
    required this.title,
  });
}
