import 'package:flutter/material.dart';
import 'package:meet_pe/screens/onBoardingPages/guide/create_experience/create_exp_step2.dart';
import '../../../../models/step_list_response.dart';
import '../../../../resources/resources.dart';
import '../../../../services/app_service.dart';
import '../../../../utils/responsive_size.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/_widgets.dart';

class CreateExpStep1 extends StatefulWidget {
  const CreateExpStep1({super.key});

  @override
  State<CreateExpStep1> createState() => _CreateExpStep1State();
}

class _CreateExpStep1State extends State<CreateExpStep1> {
  late Future<List<StepListResponse>> _choicesFuture;
  late List<Voyage> myList = [];
  Map<String, Set<Object>> myMap = {};

  @override
  void initState() {
    super.initState();
    //_choicesFuture = AppService.api.fetchChoices('guide_categorie_de_lexperience');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<List<StepListResponse>>(
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
                        'images/backgroundExp.png',
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
                              'Étape 1 sur 11',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: ResponsiveSize.calculateHeight(8, context)),
                            Text(
                              'Catégorie de l’expérience',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            SizedBox(height: ResponsiveSize.calculateHeight(16, context)),
                            Text(
                              'Dis-nous quel type d’expérience, tu proposes',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(height: ResponsiveSize.calculateHeight(40, context)),
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
                                    isSelected: myMap['categorie'] != null
                                        ? myMap['categorie']!.contains(item.id)
                                        : false,
                                    onTap: () {
                                      setState(() {
                                        if (myMap['categorie'] == null) {
                                          myMap['categorie'] =
                                              Set<int>(); // Initialize if null
                                        }

                                        if (myMap['categorie']!.contains(item.id)) {
                                          myMap['categorie']!.remove(item.id);
                                        } else {
                                          myMap['categorie']!.add(item.id);
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
                      const SizedBox(height: 30,),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: ResponsiveSize.calculateHeight(44, context), right: ResponsiveSize.calculateWidth(28, context)),
                          child: Container(
                            width: ResponsiveSize.calculateWidth(151, context),
                            height: ResponsiveSize.calculateHeight(44, context),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.symmetric(
                                        horizontal: ResponsiveSize.calculateHeight(24, context), vertical: ResponsiveSize.calculateHeight(10, context))),
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
                              onPressed: myMap['categorie'] != null &&
                                  myMap['categorie']!.isNotEmpty
                                  ? () {
                                navigateTo(context, (_) => CreateExpStep2(myMap: myMap));
                              }
                                  : null, // Disable the button if no item is selected
                              child: Image.asset('images/arrowLongRight.png'),
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
      ),
    );
  }
}
