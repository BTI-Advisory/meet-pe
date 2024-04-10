import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/step_list_response.dart';
import '../../../../resources/resources.dart';
import '../../../../services/app_service.dart';
import '../../../../utils/responsive_size.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/popup_view.dart';
import 'create_exp_step11.dart';

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

  @override
  void initState() {
    super.initState();
    _choicesFuture = AppService.api.fetchChoices('reservation_de_dernier_minute');
    _loadChoices();
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
                          'images/backgroundExp7.png',
                          width: double.infinity,
                          fit: BoxFit.fill,
                          height: ResponsiveSize.calculateHeight(190, context),
                        ),
                        Positioned(
                          top: 48,
                          left: 28,
                          child: Container(
                            width: ResponsiveSize.calculateWidth(32, context),
                            height: ResponsiveSize.calculateHeight(32, context),
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
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Étape 8 sur 9',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                                ),
                                const PopupView(contentTitle: "Tips Meet People : plus tu encourageras de « l’instant Booking » en réduisant ce timing plus tu auras l’occasion de remplir ton expérience 💪🏼", iconData: Icons.help_outline,)
                              ],
                            ),
                            SizedBox(
                                height: ResponsiveSize.calculateHeight(8, context)),
                            Text(
                              'Réservation de dernière minute',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            SizedBox(
                                height: ResponsiveSize.calculateHeight(16, context)),
                            Text(
                              'Combien de temps avant le début de l’expérience le voyageur peut-il réserver?',
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
                                    isSelected: myMap['dernier_minute_reservation'] != null
                                        ? myMap['dernier_minute_reservation']!.contains(item.id)
                                        : false,
                                    onTap: () {
                                      setState(() {
                                        if (myMap['dernier_minute_reservation'] == null) {
                                          myMap['dernier_minute_reservation'] =
                                              Set<int>(); // Initialize if null
                                        }

                                        if (myMap['dernier_minute_reservation']!.contains(item.id)) {
                                          myMap['dernier_minute_reservation']!.remove(item.id);
                                        } else {
                                          myMap['dernier_minute_reservation']!.add(item.id);
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
                                  navigateTo(context, (_) => CreateExpStep11(sendListMap: widget.sendListMap));
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
