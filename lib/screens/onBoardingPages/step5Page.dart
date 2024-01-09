import 'package:flutter/material.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/screens/onBoardingPages/step6Page.dart';
import '../../utils/utils.dart';

class Step5Page extends StatefulWidget {
  final int totalSteps;
  final int currentStep;
  Map<String, Set<String>> myMap = {};

  Step5Page({
    Key? key,
    required this.totalSteps,
    required this.currentStep,
    required this.myMap,
  }) : super(key: key);

  @override
  State<Step5Page> createState() => _Step5PageState();
}

class _Step5PageState extends State<Step5Page> {
  late List<Voyage> myList = [
    Voyage(id: 1, title: "Culture Locale"),
    Voyage(id: 2, title: "Tradition et Savoir-Faire"),
    Voyage(id: 3, title: "Food"),
    Voyage(id: 4, title: "Art"),
    Voyage(id: 5, title: "Patrimoine"),
    Voyage(id: 6, title: "Sport"),
    Voyage(id: 7, title: "Activités Extrêmes"),
    Voyage(id: 8, title: "Musique et Concert"),
    Voyage(id: 9, title: "Outdoor"),
    Voyage(id: 10, title: "Insolites"),
    Voyage(id: 11, title: "Exclusives"),
    Voyage(id: 12, title: "Shopping"),
    Voyage(id: 13, title: "Avec les animaux"),
    Voyage(id: 14, title: "Exploration Urbaine"),
    Voyage(id: 15, title: "Vin & Spiritueux"),
    Voyage(id: 16, title: "Pas d’idée, fais moi découvrir")
  ];

  double calculateProgress() {
    return widget.currentStep / widget.totalSteps;
  }

  @override
  Widget build(BuildContext context) {
    double progress = calculateProgress();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppResources.colorGray5,
              AppResources.colorWhite
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 120,),
              SizedBox(
                width: 108,
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: AppResources.colorImputStroke,
                  color: AppResources.colorVitamine,
                  borderRadius: BorderRadius.circular(3.5),
                ),
              ),
              const SizedBox(height: 33,),
              Text(
                'Tu cherches des expériences...',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppResources.colorGray100),
              ),
              const SizedBox(height: 24,),
              Text(
                'Tu peux modifier ces critères à tous \nmoments depuis ton profil.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 48,),
              Container(
                width: 319,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8, // Horizontal spacing between items
                  runSpacing: 12, // Vertical spacing between lines
                  children: myList.map((item) {
                    return Item(
                      id: item.id,
                      text: item.title,
                      isSelected: widget.myMap['step5'] != null ? widget.myMap['step5']!.contains(item.title) : false,
                      onTap: () {
                        setState(() {
                          if (widget.myMap['step5'] == null) {
                            widget.myMap['step5'] = Set<String>(); // Initialize if null
                          }

                          if (widget.myMap['step5']!.contains(item.title)) {
                            widget.myMap['step5']!.remove(item.title);
                          } else {
                            widget.myMap['step5']!.add(item.title);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 44),
                    child: Container(
                      margin:
                      const EdgeInsets.only(left: 96, right: 96),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 10)),
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
                        onPressed: widget.myMap['step5'] != null &&
                            widget.myMap['step5']!.isNotEmpty
                            ? () {
                          navigateTo(
                            context,
                                (_) => Step6Page(
                              myMap: widget.myMap,
                              totalSteps: 7,
                              currentStep: 6,
                            ),
                          );
                        }
                            : null, // Disable the button if no item is selected
                        child: Image.asset('images/arrowLongRight.png'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(24)),
            border: Border.all(color: AppResources.colorGray100),
          ),
          child: Center(
            child: Text(
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
