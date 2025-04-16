import 'package:flutter/material.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/screens/onBoardingPages/guide/step2GuidePage.dart';
import '../../../models/step_list_response.dart';
import '../../../services/app_service.dart';
import '../../../utils/_utils.dart';
import '../../../widgets/_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Step1GuidePage extends StatefulWidget {
  final int totalSteps;
  final int currentStep;

  const Step1GuidePage({
    Key? key,
    required this.totalSteps,
    required this.currentStep,
  }) : super(key: key);

  @override
  State<Step1GuidePage> createState() => _Step1GuidePageState();
}

class _Step1GuidePageState extends State<Step1GuidePage> {
  late Future<List<StepListResponse>> _choicesFuture;
  late List<Voyage> myList = [];
  Map<String, Set<Object>> myMap = {};

  @override
  void initState() {
    super.initState();
    _choicesFuture = AppService.api.fetchChoices('guide_truc_de_toi_fr');
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

  double calculateProgress() {
    return widget.currentStep / widget.totalSteps;
  }

  @override
  Widget build(BuildContext context) {
    double progress = calculateProgress();

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: ResponsiveSize.calculateHeight(100, context)),
                    SizedBox(
                      width: ResponsiveSize.calculateWidth(108, context),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: AppResources.colorImputStroke,
                        color: AppResources.colorVitamine,
                        borderRadius: BorderRadius.circular(3.5),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.calculateHeight(33, context)),
                    Text(
                      AppLocalizations.of(context)!.your_truc_text,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: AppResources.colorGray100),
                    ),
                    SizedBox(height: ResponsiveSize.calculateHeight(48, context)),
                    Container(
                      width: 319,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: ResponsiveSize.calculateWidth(8, context), // Horizontal spacing between items
                        runSpacing: ResponsiveSize.calculateHeight(12, context), // Vertical spacing between lines
                        children: myList.map((item) {
                          return ItemWidget(
                            id: item.id,
                            text: item.title,
                            isSelected: myMap['guide_truc_de_toi_fr'] != null
                                ? myMap['guide_truc_de_toi_fr']!.contains(item.id)
                                : false,
                            onTap: () {
                              setState(() {
                                if (myMap['guide_truc_de_toi_fr'] == null) {
                                  myMap['guide_truc_de_toi_fr'] =
                                      Set<int>(); // Initialize if null
                                }

                                if (myMap['guide_truc_de_toi_fr']!.contains(item.id)) {
                                  myMap['guide_truc_de_toi_fr']!.remove(item.id);
                                } else {
                                  myMap['guide_truc_de_toi_fr']!.add(item.id);
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
                          padding: EdgeInsets.only(bottom: ResponsiveSize.calculateHeight(44, context)),
                          child: Container(
                            width: ResponsiveSize.calculateWidth(183, context),
                            height: ResponsiveSize.calculateHeight(44, context),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.symmetric(
                                        horizontal: ResponsiveSize.calculateWidth(24, context), vertical: ResponsiveSize.calculateHeight(10, context))),
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
                              onPressed: myMap['guide_truc_de_toi_fr'] != null &&
                                  myMap['guide_truc_de_toi_fr']!.isNotEmpty
                                  ? () {
                                navigateTo(
                                  context,
                                      (_) => Step2GuidePage(
                                    myMap: myMap,
                                    totalSteps: 4,
                                    currentStep: 2,
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
            );
          }
        },
      ),
    );
  }
}
