import 'package:flutter/material.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/screens/onBoardingPages/step7Page.dart';
import '../../utils/utils.dart';

class Step6Page extends StatefulWidget {
  final int totalSteps;
  final int currentStep;
  Map<String, Set<String>> myMap = {};

  Step6Page({
    Key? key,
    required this.totalSteps,
    required this.currentStep,
    required this.myMap,
  }) : super(key: key);

  @override
  State<Step6Page> createState() => _Step6PageState();
}

class _Step6PageState extends State<Step6Page> {
  late List<Voyage> myList = [
    Voyage(id: 1, title: "Français"),
    Voyage(id: 2, title: "Anglais"),
    Voyage(id: 3, title: "Chinois (mandarin)"),
    Voyage(id: 4, title: "Japonais"),
    Voyage(id: 5, title: "Espagnol"),
    Voyage(id: 6, title: "Portugais"),
    Voyage(id: 7, title: "Italien"),
    Voyage(id: 8, title: "Grec"),
    Voyage(id: 9, title: "Russe"),
    Voyage(id: 10, title: "Allemand")
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
              const SizedBox(height: 8,),
              Text(
                'Tu parles...',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppResources.colorGray100),
              ),
              const SizedBox(height: 56,),
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
                      isSelected: widget.myMap['step6'] != null ? widget.myMap['step6']!.contains(item.title) : false,
                      onTap: () {
                        setState(() {
                          if (widget.myMap['step6'] == null) {
                            widget.myMap['step6'] = Set<String>(); // Initialize if null
                          }

                          if (widget.myMap['step6']!.contains(item.title)) {
                            widget.myMap['step6']!.remove(item.title);
                          } else {
                            widget.myMap['step6']!.add(item.title);
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
                          padding:
                          MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 10)),
                          backgroundColor: MaterialStateProperty.all(
                              AppResources.colorVitamine),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                        onPressed: () {
                          navigateTo(context, (_) => Step7Page(myMap: widget.myMap, totalSteps: 7, currentStep: 7,));
                        },
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
