import 'package:flutter/material.dart';
import 'package:meet_pe/resources/_resources.dart';

class Step4Page extends StatefulWidget {
  Step4Page({super.key, required this.myMap});
  Map<String, Set<int>> myMap = Map<String, Set<int>>();

  @override
  State<Step4Page> createState() => _Step4PageState();
}

class _Step4PageState extends State<Step4Page> {
  late List<Voyage> myList = [
    Voyage(id: 1, title: "Extraverti"),
    Voyage(id: 2, title: "Curieux"),
    Voyage(id: 3, title: "Créatif"),
    Voyage(id: 4, title: "Rêveur"),
    Voyage(id: 5, title: "Sportif"),
    Voyage(id: 6, title: "Connecté"),
    Voyage(id: 7, title: "Epicurien"),
    Voyage(id: 8, title: "Posé")
  ];

  @override
  Widget build(BuildContext context) {
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
              Text(
                'Étape 4 sur 9',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 8,),
              Text(
                'On dit de toi que tu es...',
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
                      isSelected: widget.myMap['step4'] != null ? widget.myMap['step4']!.contains(item.id) : false,
                      onTap: () {
                        setState(() {
                          if (widget.myMap['step4'] == null) {
                            widget.myMap['step4'] = Set<int>(); // Initialize if null
                          }

                          if (widget.myMap['step4']!.contains(item.id)) {
                            widget.myMap['step4']!.remove(item.id);
                          } else {
                            widget.myMap['step4']!.add(item.id);
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
                          //navigateTo(context, (_) => Step5Page(myMap: widget.myMap,));
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
