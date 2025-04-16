import 'package:flutter/material.dart';

import '../../../../models/step_list_response.dart';
import '../../../../resources/resources.dart';
import '../../../../services/app_service.dart';
import '../../../../utils/_utils.dart';
import '../../../../widgets/_widgets.dart';
import 'create_exp_step12.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateExpStep11 extends StatefulWidget {
  CreateExpStep11({super.key, required this.sendListMap});
  Map<String, dynamic> sendListMap = {};

  @override
  State<CreateExpStep11> createState() => _CreateExpStep11State();
}

class _CreateExpStep11State extends State<CreateExpStep11> {
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
      // Select the last item by default
      if (myList.isNotEmpty) {
        setState(() {
          if (myMap['dernier_minute_reservation'] == null) {
            myMap['dernier_minute_reservation'] = Set<int>();
          }
          myMap['dernier_minute_reservation']!.add(myList.last.id);
        });
      }
    } catch (error) {
      // Handle error if fetching data fails
      print('Error: $error');
    }
  }

  void _onItemTap(int itemId) {
    setState(() {
      myMap['dernier_minute_reservation'] = {itemId};
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.step_10_text,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                                ),
                                PopupView(contentTitle: AppLocalizations.of(context)!.pop_view_last_minute_text)
                              ],
                            ),
                            SizedBox(
                                height: ResponsiveSize.calculateHeight(8, context)),
                            Text(
                              AppLocalizations.of(context)!.step_10_title_text,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            SizedBox(
                                height: ResponsiveSize.calculateHeight(16, context)),
                            Text(
                              AppLocalizations.of(context)!.step_10_desc_text,
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
                                  return ItemWidget(
                                    id: item.id,
                                    text: item.title,
                                    isSelected: myMap['dernier_minute_reservation'] != null
                                        ? myMap['dernier_minute_reservation']!.contains(item.id)
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
                                  navigateTo(context, (_) => CreateExpStep12(sendListMap: widget.sendListMap));
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
