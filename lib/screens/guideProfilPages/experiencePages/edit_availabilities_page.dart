import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/availability_list_response.dart';
import '../../../models/modify_experience_data_model.dart';
import '../../../services/app_service.dart';
import '../../../utils/_utils.dart';
import '../../../resources/resources.dart';
import '../../../widgets/day_available.dart';

class EditAvailabilitiesPage extends StatefulWidget {
  const EditAvailabilitiesPage({super.key, required this.sendListMap});

  final Map<String, dynamic> sendListMap;

  @override
  State<EditAvailabilitiesPage> createState() => _EditAvailabilitiesPageState();
}

class _EditAvailabilitiesPageState extends State<EditAvailabilitiesPage> {
  Map<String, Set<Availability>> myMap = {};
  List<AvailabilityListResponse> availabilityList = [];

  @override
  void initState() {
    super.initState();
    fetchAvailabilityData();
  }

  @override
  void dispose() {
    super.dispose();
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

  // This is the method that handles time selection for each day
  void _onTimeSelected(String day, Availability availability) {
    setState(() {
      // If the day already exists in myMap, add the new availability to the set
      if (myMap.containsKey(day)) {
        myMap[day]?.add(availability);
      } else {
        // If the day does not exist, create a new set for this day and add the availability
        myMap[day] = {availability};
      }

      print('Selected time for $day: ${availability.times.first.from}');
    });
  }

  void _sendAllData() {
    // Prepare the list to hold all the data
    List<Map<String, dynamic>> dataToSend = [];

    // Iterate through the myMap to prepare the data to send
    myMap.forEach((day, availabilities) {
      availabilities.forEach((availability) {
        if (availability.times.length == 1) {
          dataToSend.add({
            'day': day,
            'availableFullDay': availability.isAvailableFullDay,
            'startTime': availability.times.first.from,
            'endTime': availability.times.first.to,
          });
        } else {
          dataToSend.add({
            'day': day,
            'availableFullDay': availability.isAvailableFullDay,
            'startTime': availability.times.first.from,
            'endTime': availability.times.first.to,
            'startSecondTime': availability.times.last.from,
            'endSecondTime': availability.times.last.to,
          });
        }
      });
    });

    print('Prepared Data: $dataToSend');

    // Create a list of AvailabilitiesDataModel based on the dataToSend list
    List<AvailabilitiesDataModel> availabilitiesData = dataToSend.map((data) {
      return AvailabilitiesDataModel(
        day: data['day'],
        availableFullDay: data['availableFullDay'],
        startTime: data['startTime'],
        endTime: data['endTime'],
        startSecondTime: data['startSecondTime'],
        endSecondTime: data['endSecondTime'],
      );
    }).toList();

    // Assuming you have an instance of ModifyExperienceDataModel
    ModifyExperienceDataModel experienceData = ModifyExperienceDataModel(
      availabilitiesData: availabilitiesData,
      // Add other fields as needed
    );

    print('Final Experience Data: ${experienceData.availabilitiesData}');

    /// If `sendListMap['available']` is null, initialize it
    if (widget.sendListMap['available'] == null) {
      widget.sendListMap['available'] = [];
    }

    // Optionally, you can still add the raw data to `sendListMap` if needed
    widget.sendListMap['available'] = dataToSend;
    print('Final Data: ${widget.sendListMap}');

    // Pass the experience data or sendListMap back to the previous screen as needed
    Navigator.pop(context, experienceData);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF3F3F3), Colors.white],
              stops: [0.0, 1.0],
            ),
          ),
          child: Stack(
            children: <Widget>[
              // Main content with scroll capability
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 48),
                      SizedBox(
                        width: ResponsiveSize.calculateWidth(24, context),
                        height: ResponsiveSize.calculateHeight(24, context),
                        child: FloatingActionButton(
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
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      Text(
                        'Ça commence quand ?',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Renseigne les jours de la semaine ainsi que l’horaire de début de l’expérience.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: availabilityList.map((item) {
                            return DayAvailable(
                              availabilityList: item,
                              onTimeSelected: (day, availability) {
                                _onTimeSelected(day, availability);  // Save selected times for each day
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 80),
                      // Additional space to account for button
                    ],
                  ),
                ),
              ),
              // Bottom button
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  // Add some bottom margin for padding
                  child: SizedBox(
                    width: ResponsiveSize.calculateWidth(319, context),
                    height: ResponsiveSize.calculateHeight(44, context),
                    child: TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                horizontal:
                                ResponsiveSize.calculateWidth(24, context),
                                vertical: ResponsiveSize.calculateHeight(
                                    12, context))),
                        backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1, color: AppResources.colorDark),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                      child: Text(
                        'ENREGISTRER',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: AppResources.colorDark),
                      ),
                      onPressed: () {
                        _sendAllData();
                      },
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
