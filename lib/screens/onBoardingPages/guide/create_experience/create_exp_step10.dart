import 'package:flutter/material.dart';

import '../../../../models/availability_list_response.dart';
import '../../../../models/step_list_response.dart';
import '../../../../resources/resources.dart';
import '../../../../services/app_service.dart';
import '../../../../utils/responsive_size.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/_widgets.dart';
import 'create_exp_step11.dart';

class CreateExpStep10 extends StatefulWidget {
  CreateExpStep10({super.key, required this.sendListMap});
  Map<String, dynamic> sendListMap = {};

  @override
  State<CreateExpStep10> createState() => _CreateExpStep10State();
}

class _CreateExpStep10State extends State<CreateExpStep10> {
  late List<Voyage> myList = [];
  Map<String, Set<Object>> myMap = {};
  List<AvailabilityListResponse> availabilityList = [];

  @override
  void initState() {
    super.initState();
    fetchAvailabilityData();
  }

  Future<void> fetchAvailabilityData() async {
    try {
      final response = await AppService.api.getAvailabilityList();
      setState(() {
        availabilityList = response;
      });
      for (var item in availabilityList) {
        print(item.day);
      }
    } catch (e) {
      // Handle error
      print('Error fetching availability list: $e');
    }
  }

  void _onAvailabilityModified() {
    fetchAvailabilityData();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: deviceSize.height, // Ensure the scrollable area is at least as tall as the device
          ),
          child: IntrinsicHeight(
            child: Container(
              width: deviceSize.width,
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
                            'Étape 9 sur 11',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                              height: ResponsiveSize.calculateHeight(8, context)),
                          Text(
                            'Ça commence quand ?',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          SizedBox(
                              height: ResponsiveSize.calculateHeight(16, context)),
                          Text(
                            'Renseigne les jours de la semaine ainsi que l’horaire de début de l’expérience.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(
                              height: ResponsiveSize.calculateHeight(40, context)),
                          Container(
                            width: double.infinity,
                            child: Column(
                              children: availabilityList.map((item) {
                                return DayAvailable(availabilityList: item, onAvailabilityModified: _onAvailabilityModified,);
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26,),
                    Align(
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
                            onPressed: myMap['categorie'] != null &&
                                myMap['categorie']!.isNotEmpty
                                ? () {
                              navigateTo(context, (_) => CreateExpStep11(sendListMap: widget.sendListMap));
                            }
                                : null,
                            /*onPressed: () {
                              // Convert sets to lists
                              myMap.forEach((key, value) {
                                widget.sendListMap[key] = value.toList();
                              });
                              navigateTo(context, (_) => CreateExpStep11(sendListMap: widget.sendListMap));
                            },*/
                            child: Image.asset('images/arrowLongRight.png'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
