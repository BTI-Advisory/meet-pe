import 'package:flutter/material.dart';

import '../../../../models/step_list_response.dart';
import '../../../../resources/resources.dart';
import '../../../../services/app_service.dart';
import '../../../../utils/responsive_size.dart';
import '../../../../utils/utils.dart';
import 'create_exp_step10.dart';

class CreateExpStep9 extends StatefulWidget {
  CreateExpStep9({super.key, required this.sendListMap});
  Map<String, dynamic> sendListMap = {};

  @override
  State<CreateExpStep9> createState() => _CreateExpStep9State();
}

class _CreateExpStep9State extends State<CreateExpStep9> {
  late Future<List<StepListResponse>> _choicesFuture;
  late List<Voyage> myList = [];
  Map<String, Set<Object>> myMap = {};

  @override
  void initState() {
    super.initState();
    _choicesFuture = AppService.api.fetchChoices('et_avec_ça');
    _loadChoices();
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
      // Select the last item by default
      if (myList.isNotEmpty) {
        setState(() {
          if (myMap['et_avec_ça'] == null) {
            myMap['et_avec_ça'] = Set<int>();
          }
          myMap['et_avec_ça']!.add(myList.last.id);
        });
      }
    } catch (error) {
      // Handle error if fetching data fails
      print('Error: $error');
    }
  }

  void _onItemTap(int itemId) {
    setState(() {
      if (myMap['et_avec_ça'] == null) {
        myMap['et_avec_ça'] = {};
      }

      // Check if the tapped item is already selected
      final bool isSelected = myMap['et_avec_ça']!.contains(itemId);

      // If it's the last item and it's already selected, deselect it
      if (itemId == myList.last.id && isSelected) {
        myMap['et_avec_ça']!.remove(itemId);
      } else {
        // If it's the last item, deselect all other items
        if (itemId == myList.last.id) {
          myMap['et_avec_ça'] = {itemId};
        } else {
          // Deselect the last item if it's currently selected
          if (myMap['et_avec_ça']!.contains(myList.last.id)) {
            myMap['et_avec_ça']!.remove(myList.last.id);
          }
          // Toggle selection for the tapped item
          if (isSelected) {
            myMap['et_avec_ça']!.remove(itemId);
          } else {
            myMap['et_avec_ça']!.add(itemId);
          }
        }
      }
    });
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
                      Image.asset(
                        'images/backgroundExp7.png',
                        width: double.infinity,
                        fit: BoxFit.fill,
                        height: ResponsiveSize.calculateHeight(190, context),
                      ),
                      SizedBox(height: ResponsiveSize.calculateHeight(40, context)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Étape 8 sur 11',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                                height: ResponsiveSize.calculateHeight(8, context)),
                            Text(
                              'Et avec ça ?',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            SizedBox(
                                height: ResponsiveSize.calculateHeight(16, context)),
                            Text(
                              'Renseigne ce qui est inclus dans ton expérience.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(
                                height: ResponsiveSize.calculateHeight(40, context)),
                            Container(
                              width: double.infinity,
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: ResponsiveSize.calculateWidth(8, context), // Horizontal spacing between items
                                runSpacing: ResponsiveSize.calculateHeight(12, context), // Vertical spacing between lines
                                children: myList.map((item) {
                                  return Item(
                                    id: item.id,
                                    text: item.title,
                                    image: item.image,
                                    isSelected: myMap['et_avec_ça'] != null
                                        ? myMap['et_avec_ça']!.contains(item.id)
                                        : false,
                                    onTap: () => _onItemTap(item.id),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: ResponsiveSize.calculateHeight(44, context),
                              right: ResponsiveSize.calculateWidth(28, context),
                            ),
                            child: Container(
                              width: ResponsiveSize.calculateWidth(151, context),
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
                                onPressed: () {
                                  // Convert sets to lists
                                  myMap.forEach((key, value) {
                                    widget.sendListMap[key] = value.toList();
                                  });
                                  navigateTo(context, (_) => CreateExpStep10(sendListMap: widget.sendListMap));
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
              );
            }
          }),
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
                if(widget.image != '')
                Image.network(
                  widget.image,
                  width: 16,
                  height: 16,
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
  final String image;

  Voyage({
    required this.id,
    required this.title,
    required this.image,
  });
}
