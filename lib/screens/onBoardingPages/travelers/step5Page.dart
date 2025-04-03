import 'package:flutter/material.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/screens/onBoardingPages/travelers/step6Page.dart';
import '../../../models/step_list_response.dart';
import '../../../services/app_service.dart';
import '../../../utils/_utils.dart';
import '../../../widgets/_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Step5Page extends StatefulWidget {
  final int totalSteps;
  final int currentStep;
  Map<String, Set<Object>> myMap = {};

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
  late Future<List<StepListResponse>> _choicesFuture;
  late List<Voyage> myList = [];

  @override
  void initState() {
    super.initState();
    _choicesFuture = AppService.api.fetchChoices('voyageur_experiences');
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

  void _onItemTap(int itemId) {
    setState(() {
      if (widget.myMap['voyageur_experiences'] == null) {
        widget.myMap['voyageur_experiences'] = {};
      }

      // Check if the tapped item is already selected
      final bool isSelected = widget.myMap['voyageur_experiences']!.contains(itemId);

      // If it's the last item and it's already selected, deselect it
      if (itemId == myList.last.id && isSelected) {
        widget.myMap['voyageur_experiences']!.remove(itemId);
      } else {
        // If it's the last item, deselect all other items
        if (itemId == myList.last.id) {
          widget.myMap['voyageur_experiences'] = {itemId};
        } else {
          // Deselect the last item if it's currently selected
          if (widget.myMap['voyageur_experiences']!.contains(myList.last.id)) {
            widget.myMap['voyageur_experiences']!.remove(myList.last.id);
          }
          // Toggle selection for the tapped item
          if (isSelected) {
            widget.myMap['voyageur_experiences']!.remove(itemId);
          } else {
            widget.myMap['voyageur_experiences']!.add(itemId);
          }
        }
      }
    });
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
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppResources.colorGray5, AppResources.colorWhite],
                ),
              ),
              child: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                          minWidth: constraints.maxWidth,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: ResponsiveSize.calculateHeight(60, context)),
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
                              SizedBox(height: ResponsiveSize.calculateHeight(24, context)),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveSize.calculateWidth(28, context)),
                                child: Text(
                                  AppLocalizations.of(context)!.traveler_step_5_title_text,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(color: AppResources.colorGray100),
                                ),
                              ),
                              SizedBox(height: ResponsiveSize.calculateHeight(16, context)),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveSize.calculateWidth(28, context)),
                                child: Text(
                                  AppLocalizations.of(context)!.traveler_step_1_desc_text,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              SizedBox(height: ResponsiveSize.calculateHeight(32, context)),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveSize.calculateWidth(28, context)),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: ResponsiveSize.calculateWidth(8, context),
                                  runSpacing: ResponsiveSize.calculateHeight(12, context),
                                  children: myList.map((item) {
                                    return ItemWidget(
                                      id: item.id,
                                      text: item.title,
                                      isSelected: widget.myMap['voyageur_experiences'] != null
                                          ? widget.myMap['voyageur_experiences']!.contains(item.id)
                                          : false,
                                      onTap: () => _onItemTap(item.id),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: ResponsiveSize.calculateHeight(44, context),
                                ),
                                child: SizedBox(
                                  width: ResponsiveSize.calculateWidth(183, context),
                                  height: ResponsiveSize.calculateHeight(44, context),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<EdgeInsets>(
                                          EdgeInsets.symmetric(
                                              horizontal: ResponsiveSize.calculateWidth(24, context),
                                              vertical: ResponsiveSize.calculateHeight(10, context))),
                                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                          if (states.contains(MaterialState.disabled)) {
                                            return AppResources.colorGray15;
                                          }
                                          return AppResources.colorVitamine;
                                        },
                                      ),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(40),
                                        ),
                                      ),
                                    ),
                                    onPressed: widget.myMap['voyageur_experiences'] != null &&
                                        widget.myMap['voyageur_experiences']!.isNotEmpty
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
                                        : null,
                                    child: Image.asset('images/arrowLongRight.png'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
