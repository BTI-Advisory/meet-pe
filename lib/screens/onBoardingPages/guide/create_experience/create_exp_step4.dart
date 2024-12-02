import 'package:flutter/material.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';

import '../../../../models/step_list_response.dart';
import '../../../../resources/resources.dart';
import '../../../../services/app_service.dart';
import 'create_exp_step5.dart';
import 'create_exp_step5_multi_days.dart';

class CreateExpStep4 extends StatefulWidget {
  CreateExpStep4({super.key, required this.myMap, required this.name, required this.description, required this.about, required this.audioPath});

  Map<String, Set<Object>> myMap = {};
  final String name;
  final String description;
  final String about;
  final String audioPath;

  @override
  State<CreateExpStep4> createState() => _CreateExpStep4State();
}

class _CreateExpStep4State extends State<CreateExpStep4> with BlocProvider<CreateExpStep4, CreateExpStep4Bloc> {
  final idExperience = 0;
  late Future<List<StepListResponse>> _choicesFuture;
  late List<Voyage> myList = [];

  @override
  initBloc() => CreateExpStep4Bloc(widget.myMap, widget.name, widget.description, widget.about, widget.audioPath, idExperience);

  @override
  void initState() {
    super.initState();
    //_choicesFuture = AppService.api.fetchChoices('languages_fr');
    _choicesFuture = Future.value([
      StepListResponse(id: 1, choiceTxt: "Horaire personalisé", svg: ''),
      StepListResponse(id: 2, choiceTxt: "48 heures", svg: ''),
      StepListResponse(id: 3, choiceTxt: "7 jours", svg: ''),
    ]);
    _loadChoices();
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
        onValidated: bloc.makeExperienceGuide,
        onSuccess: () {
          return navigateTo(context, (_) => CreateExpStep5(name: widget.name, description: widget.description, infoMap: bloc.modifiedMap,));
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
                          'Étape 4 sur 11',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                            height: ResponsiveSize.calculateHeight(8, context)),
                        Text(
                          'Durée de l’expérience',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(
                            height: ResponsiveSize.calculateHeight(16, context)),
                        Text(
                          'Donnes-nous une estimation pour que tes hôtes soient prêts !',
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
                                isSelected: widget.myMap['duration'] != null
                                    ? widget.myMap['duration']!.contains(item.id)
                                    : false,
                                onTap: () {
                                  setState(() {
                                    if (widget.myMap['duration'] == null) {
                                      widget.myMap['duration'] =
                                          Set<int>(); // Initialize if null
                                    }

                                    if (widget.myMap['duration']!.contains(item.id)) {
                                      // Deselect the current item
                                      widget.myMap['duration']!.remove(item.id);
                                    } else {
                                      // Deselect any other selection and select the current item
                                      widget.myMap['duration']!.clear();
                                      widget.myMap['duration']!.add(item.id);
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
                            /*onPressed: (){
                              setState(() {
                                // Proceed to the next step
                                //navigateTo(context, (_) => CreateExpStep5(myMap: widget.myMap,));
                                validate();
                              });
                            },*/
                            onPressed: () {
                              setState(() {
                                // Check the current selection in widget.myMap['duration']
                                final selectedChoices = widget.myMap['duration'];

                                if (selectedChoices != null && selectedChoices.contains(1)) {
                                  // No choice selected -> Redirect to PageState1
                                  navigateTo(context, (_) => CreateExpStep5(name: widget.name, description: widget.description, infoMap: bloc.modifiedMap,));
                                } else if (selectedChoices != null && selectedChoices.contains(2)) {
                                  // "1 week-end" selected -> Redirect to PageState2
                                  navigateTo(context, (_) => CreateExpStep5MultiDays(name: widget.name, description: widget.description, infoMap: bloc.modifiedMap, duration: 2,));
                                } else if (selectedChoices != null && selectedChoices.contains(3)) {
                                  // "1 semaine" selected -> Redirect to PageState3
                                  navigateTo(context, (_) => CreateExpStep5MultiDays(name: widget.name, description: widget.description, infoMap: bloc.modifiedMap, duration: 7,));
                                }
                              });
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
      ),
    );
  }
}

class CreateExpStep4Bloc with Disposable {
  String? name;
  String? description;
  String? about;
  String? audioPath;
  int? idExperience;
  Map<String, Set<Object>> myMap;

  // Create a new map with lists instead of sets
  Map<String, dynamic> modifiedMap = {};

  CreateExpStep4Bloc(this.myMap, this.name, this.description, this.about, this.audioPath, this.idExperience);

  Future<void> makeExperienceGuide() async {
    try {
      modifiedMap['nom'] = name!;
      modifiedMap['description'] = description!;
      modifiedMap['about_guide'] = about!;

      // Convert sets to lists
      myMap.forEach((key, value) {
        modifiedMap[key] = value.toList();
      });
      print('ZRFIJIZZZZIZIZIZIZI $modifiedMap');

      // Perform the API call
      //final response = await AppService.api.makeExperienceGuide1(modifiedMap, audioFilePath: audioPath);

    } catch (error) {
      // Handle the error appropriately
      print("Error in make Experience Guide: $error");
    }
  }

  @override
  void dispose() {
    // Dispose of any resources if needed
    super.dispose();
  }
}
