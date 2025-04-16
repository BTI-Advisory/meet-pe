import 'package:flutter/material.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';

import '../../../../models/step_list_response.dart';
import '../../../../resources/resources.dart';
import 'create_exp_step5.dart';
import 'create_exp_step5_multi_days.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateExpStep4 extends StatefulWidget {
  CreateExpStep4({super.key, required this.myMap, required this.name, required this.description, required this.audioPath});

  Map<String, Set<Object>> myMap = {};
  final String name;
  final String description;
  final String audioPath;

  @override
  State<CreateExpStep4> createState() => _CreateExpStep4State();
}

class _CreateExpStep4State extends State<CreateExpStep4> with BlocProvider<CreateExpStep4, CreateExpStep4Bloc> {
  late Future<List<StepListResponse>> _choicesFuture;
  late List<Voyage> myList = [];
  String descriptionChoice = '';

  @override
  initBloc() => CreateExpStep4Bloc(widget.myMap, widget.name, widget.description, widget.audioPath);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _choicesFuture = Future.value([
      StepListResponse(id: 1, choiceTxt: AppLocalizations.of(context)!.schedule_1_text, svg: ''),
      StepListResponse(id: 2, choiceTxt: AppLocalizations.of(context)!.schedule_2_text, svg: ''),
      StepListResponse(id: 3, choiceTxt: AppLocalizations.of(context)!.schedule_3_text, svg: ''),
    ]);
    _loadChoices();
  }

  @override
  void initState() {
    super.initState();
    // You can leave the Future initialization here for other setup tasks.
  }

  Future<void> _loadChoices() async {
    try {
      final choices = await _choicesFuture;
      setState(() {
        myList = choices.map((choice) => Voyage(id: choice.id, title: choice.choiceTxt)).toList();
      });
    } catch (error) {
      // Handle error if fetching data fails
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AsyncForm(
        onValidated: () => bloc.addDurationGuide(context),
        onSuccess: () async {
          await bloc.addDurationGuide(context);
        },
        builder: (BuildContext context, void Function() validate) {
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
                    'images/backgroundExp3.png',
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
                          AppLocalizations.of(context)!.step_4_text,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                            height: ResponsiveSize.calculateHeight(8, context)),
                        Text(
                          AppLocalizations.of(context)!.step_4_title_text,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(
                            height: ResponsiveSize.calculateHeight(16, context)),
                        Text(
                          AppLocalizations.of(context)!.step_4_desc_text,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(
                            height: ResponsiveSize.calculateHeight(40, context)),
                        Container(
                          width: ResponsiveSize.calculateWidth(319, context),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: ResponsiveSize.calculateWidth(8, context), // Horizontal spacing between items
                            runSpacing: ResponsiveSize.calculateHeight(12, context), // Vertical spacing between lines
                            children: myList.map((item) {
                              return ItemWidget(
                                id: item.id,
                                text: item.title,
                                isSelected: widget.myMap['duree'] != null
                                    ? widget.myMap['duree']!.contains(item.id)
                                    : false,
                                onTap: () {
                                  setState(() {
                                    if (widget.myMap['duree'] == null) {
                                      widget.myMap['duree'] =
                                          Set<int>(); // Initialize if null
                                    }

                                    if (widget.myMap['duree']!.contains(item.id)) {
                                      // Deselect the current item
                                      widget.myMap['duree']!.remove(item.id);
                                    } else {
                                      // Deselect any other selection and select the current item
                                      widget.myMap['duree']!.clear();
                                      widget.myMap['duree']!.add(item.id);
                                    }
                                    if (item.id == 1) {
                                      descriptionChoice = AppLocalizations.of(context)!.schedule_1_desc_text;
                                    } else if (item.id == 2) {
                                      descriptionChoice = AppLocalizations.of(context)!.schedule_2_desc_text;
                                    } else if (item.id == 3) {
                                      descriptionChoice = AppLocalizations.of(context)!.schedule_3_desc_text;
                                    } else {
                                      descriptionChoice = "";
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                            height: ResponsiveSize.calculateHeight(16, context)),
                        Text(
                          descriptionChoice,
                          style: Theme.of(context).textTheme.bodyMedium,
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
                            right: ResponsiveSize.calculateWidth(28, context)),
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
                            /*onPressed: () {
                              bloc.addDurationGuide(context);
                            },*/
                            onPressed: widget.myMap['duree'] != null && widget.myMap['duree']!.isNotEmpty
                                ? () {
                                  bloc.addDurationGuide(context);
                                }
                                : null,
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
      ),
    );
  }
}

class CreateExpStep4Bloc with Disposable {
  String? name;
  String? description;
  String? audioPath;
  Map<String, Set<Object>> myMap;

  // Create a new map with lists instead of sets
  Map<String, dynamic> modifiedMap = {};

  CreateExpStep4Bloc(this.myMap, this.name, this.description, this.audioPath);

  Future<void> addDurationGuide(BuildContext context) async {
    try {
      modifiedMap['nom'] = name!;
      modifiedMap['description'] = description!;

      // Convert sets to lists
      myMap.forEach((key, value) {
        modifiedMap[key] = value.toList();
      });

      // Determine the selected duration and set it in the map
      final selectedChoices = myMap['duree'];
      if (selectedChoices != null && selectedChoices.isNotEmpty) {
        final selectedId = selectedChoices.first as int;

        // Update the duration
        switch (selectedId) {
          case 1:
            modifiedMap['duree'] = "1d";
            navigateTo(
              context,
                  (_) => CreateExpStep5(
                name: name!,
                description: description!,
                infoMap: modifiedMap,
              ),
            );
            break;
          case 2:
            modifiedMap['duree'] = "2d";
            navigateTo(
              context,
                  (_) => CreateExpStep5MultiDays(
                name: name!,
                description: description!,
                infoMap: modifiedMap,
                duration: 2,
              ),
            );
            break;
          case 3:
            modifiedMap['duree'] = "7d";
            navigateTo(
              context,
                  (_) => CreateExpStep5MultiDays(
                name: name!,
                description: description!,
                infoMap: modifiedMap,
                duration: 7,
              ),
            );
            break;
          default:
            print('No valid duration selected.');
        }
      } else {
        print('No duration selected.');
      }
    } catch (error) {
      print("Error in addDurationGuide: $error");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
