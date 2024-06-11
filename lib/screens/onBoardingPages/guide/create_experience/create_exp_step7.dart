import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/step_list_response.dart';
import '../../../../resources/resources.dart';
import '../../../../services/app_service.dart';
import '../../../../utils/responsive_size.dart';
import '../../../../utils/utils.dart';
import 'create_exp_step8.dart';

class CreateExpStep7 extends StatefulWidget {
  const CreateExpStep7(
      {super.key,
      required this.photo,
      required this.imageArray,
      required this.idExperience});

  final String photo;
  final List<dynamic> imageArray;
  final int idExperience;

  @override
  State<CreateExpStep7> createState() => _CreateExpStep7State();
}

class _CreateExpStep7State extends State<CreateExpStep7> {
  Map<String, dynamic> sendListMap = {};
  late Future<List<StepListResponse>> _choicesFuture;
  late List<Voyage> myList = [];
  Map<String, Set<Object>> myMap = {};
  int _counter = 3;

  @override
  void initState() {
    super.initState();
    _choicesFuture =
        AppService.api.fetchChoices('guide_personnes_peuves_participer');
    _loadChoices();
  }

  void _incrementCounter() {
    setState(() {
      if (_counter < 10) {
        _counter++;
      }
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 1) {
        _counter--;
      }
    });
  }

  Future<void> _loadChoices() async {
    try {
      final choices = await _choicesFuture;
      for (var choice in choices) {
        var newVoyage = Voyage(id: choice.id, title: choice.choiceTxt, image: choice.svg);
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
      body: SingleChildScrollView(
        child: FutureBuilder<List<StepListResponse>>(
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
                        Image.asset(
                          'images/backgroundExp5.png',
                          width: double.infinity,
                          fit: BoxFit.fill,
                          height: ResponsiveSize.calculateHeight(190, context),
                        ),
                        SizedBox(
                            height: ResponsiveSize.calculateHeight(40, context)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  ResponsiveSize.calculateWidth(28.0, context)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Étape 5 sur 9',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                  height:
                                      ResponsiveSize.calculateHeight(8, context)),
                              Text(
                                'Et avec qui ?',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              SizedBox(
                                  height: ResponsiveSize.calculateHeight(
                                      16, context)),
                              Text(
                                'A 2, à 3, à 4 ou plus ? Dis-nous combien de voyageurs peuvent venir vivre ton expérience',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(
                                  height: ResponsiveSize.calculateHeight(
                                      40, context)),
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
                                      icon: Icon(Icons.remove,
                                          color: AppResources.colorGray75),
                                    ),
                                  ),
                                  SizedBox(
                                      width: ResponsiveSize.calculateWidth(
                                          18, context)),
                                  Text(
                                    '$_counter',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontSize: 16),
                                  ),
                                  SizedBox(
                                      width: ResponsiveSize.calculateWidth(
                                          18, context)),
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
                                      icon: Icon(Icons.add,
                                          color: AppResources.colorGray75),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: ResponsiveSize.calculateHeight(
                                      56, context)),
                              Text(
                                'Sélectionne les personnes qui peuvent participer à ton expérience : ',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(
                                  height: ResponsiveSize.calculateHeight(
                                      20, context)),
                              Container(
                                width: double.infinity,
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  spacing:
                                      ResponsiveSize.calculateWidth(8, context),
                                  // Horizontal spacing between items
                                  runSpacing:
                                      ResponsiveSize.calculateHeight(12, context),
                                  // Vertical spacing between lines
                                  children: myList.map((item) {
                                    return Item(
                                      id: item.id,
                                      text: item.title,
                                      image: item.image,
                                      isSelected: myMap[
                                                  'guide_personnes_peuves_participer'] !=
                                              null
                                          ? myMap['guide_personnes_peuves_participer']!
                                              .contains(item.id)
                                          : false,
                                      onTap: () {
                                        setState(() {
                                          if (myMap[
                                                  'guide_personnes_peuves_participer'] ==
                                              null) {
                                            myMap['guide_personnes_peuves_participer'] =
                                                Set<int>(); // Initialize if null
                                          }

                                          if (myMap[
                                                  'guide_personnes_peuves_participer']!
                                              .contains(item.id)) {
                                            myMap['guide_personnes_peuves_participer']!
                                                .remove(item.id);
                                          } else {
                                            myMap['guide_personnes_peuves_participer']!
                                                .add(item.id);
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
                        const SizedBox(height: 60),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  ResponsiveSize.calculateHeight(44, context),
                              right: ResponsiveSize.calculateWidth(28, context),
                            ),
                            child: Container(
                              width:
                                  ResponsiveSize.calculateWidth(151, context),
                              height:
                                  ResponsiveSize.calculateHeight(44, context),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                          EdgeInsets>(
                                      EdgeInsets.symmetric(
                                          horizontal:
                                              ResponsiveSize.calculateHeight(
                                                  24, context),
                                          vertical:
                                              ResponsiveSize.calculateHeight(
                                                  10, context))),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.disabled)) {
                                        return AppResources
                                            .colorGray15; // Change to your desired grey color
                                      }
                                      return AppResources
                                          .colorVitamine; // Your enabled color
                                    },
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  sendListMap['nombre_des_voyageur'] = _counter;
                                  // Convert sets to lists
                                  myMap.forEach((key, value) {
                                    sendListMap[key] = value.toList();
                                  });
                                  sendListMap['image_principale'] =
                                      widget.photo;
                                  sendListMap['images'] = widget.imageArray;
                                  sendListMap['experience_id'] =
                                      widget.idExperience;
                                  navigateTo(
                                      context,
                                      (_) => CreateExpStep8(
                                          sendListMap: sendListMap));
                                },
                                child: Image.asset('images/arrowLongRight.png'),
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
      ),
    );
  }
}

class Item extends StatefulWidget {
  final int id;
  final String text;
  final String image;
  final bool isSelected;
  final VoidCallback onTap;

  const Item({
    required this.id,
    required this.text,
    required this.image,
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
                Image.network(
                  widget.image,
                  //'https://rec1-meetpe.neway-esoft.com/svgs/${widget.image}.png',
                  width: 10,
                  height: 10,
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
                        fontWeight: widget.isSelected
                            ? FontWeight.w500
                            : FontWeight.w300,
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
  final String image;

  Voyage({
    required this.id,
    required this.title,
    required this.image,
  });
}
