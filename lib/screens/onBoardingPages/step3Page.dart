import 'package:flutter/material.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/screens/onBoardingPages/step4Page.dart';
import '../../utils/utils.dart';

class Step3Page extends StatefulWidget {
  final int totalSteps;
  final int currentStep;
  Map<String, Set<String>> myMap = {};

  Step3Page({
    Key? key,
    required this.totalSteps,
    required this.currentStep,
    required this.myMap,
  }) : super(key: key);

  @override
  State<Step3Page> createState() => _Step3PageState();
}

class _Step3PageState extends State<Step3Page> {
  late List<Voyage> myList = [
    Voyage(id: 1, title: "A la montagne"),
    Voyage(id: 2, title: "En bord de mer"),
    Voyage(id: 3, title: "Dans un petit village"),
    Voyage(id: 4, title: "En ville"),
    Voyage(id: 5, title: "A la campagne"),
    Voyage(id: 6, title: "Dans un hotel All Inclusive"),
    Voyage(id: 7, title: "à l’aise partout")
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
                'Tu prefères être...',
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
                      isSelected: widget.myMap['step3'] != null ? widget.myMap['step3']!.contains(item.title) : false,
                      onTap: () {
                        setState(() {
                          if (widget.myMap['step3'] == null) {
                            widget.myMap['step3'] = Set<String>(); // Initialize if null
                          }

                          if (widget.myMap['step3']!.contains(item.title)) {
                            widget.myMap['step3']!.remove(item.title);
                          } else {
                            widget.myMap['step3']!.add(item.title);
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
                        onPressed: widget.myMap['step3'] != null &&
                            widget.myMap['step3']!.isNotEmpty
                            ? () {
                          navigateTo(
                            context,
                                (_) => Step4Page(
                              myMap: widget.myMap,
                              totalSteps: 7,
                              currentStep: 4,
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
