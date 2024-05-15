import 'package:flutter/material.dart';

import '../../../models/absence_list_response.dart';
import '../../../models/availability_list_response.dart';
import '../../../resources/resources.dart';
import '../../../services/app_service.dart';
import '../../../utils/_utils.dart';
import '../../../widgets/_widgets.dart';
import '../../../widgets/modify_exceptional_absences.dart';

class AvailabilitiesPage extends StatefulWidget {
  const AvailabilitiesPage({super.key});

  @override
  State<AvailabilitiesPage> createState() => _AvailabilitiesPageState();
}

class _AvailabilitiesPageState extends State<AvailabilitiesPage> {
  bool isAvailable = false;
  List<AbsenceListResponse> absenceList = [];
  List<AvailabilityListResponse> availabilityList = [];

  @override
  void initState() {
    super.initState();
    _fetchFullAvailable();
    fetchAvailabilityData();
    fetchAbsenceData();
  }

  Future<void> _fetchFullAvailable() async {
    try {
      final fullAvailable = await AppService.api.getFullAvailable();
      setState(() {
        isAvailable = fullAvailable.available;
      });
    } catch (e) {
      // Handle error
      print('Error fetching full available: $e');
    }
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

  Future<void> fetchAbsenceData() async {
    try {
      final entries = await AppService.api.getAbsenceList();
      setState(() {
        absenceList = entries;
      });
    } catch (e) {
      // Handle error
      print('Error fetching absence list: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EpAppBar(
        title: 'Mes disponibilités',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.calculateWidth(31, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rencontre avec les voyageurs',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                            fontSize: 20, color: AppResources.colorDark),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Merci beaucoup de nous donner un coup de main en partageant tes dispos de façon super précise, c’est ultra important pour notre communauté ! Merci d’avance, tu es le meilleur 😎 !',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppResources.colorGray30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isAvailable
                            ? 'Disponible 24h / 7j sur 7'
                            : 'Toujours disponible',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Color(0xff797979)),
                      ),
                      Switch.adaptive(
                        value: isAvailable,
                        activeColor: AppResources.colorVitamine,
                        onChanged: (bool value) {
                          // Update the state immediately without awaiting the async operation
                          setState(() {
                            isAvailable = value;
                          });

                          // Call the asynchronous operation and handle its completion
                          AppService.api.sendFullAvailable(value).then((_) {
                            // Optionally, you can perform additional actions after the operation completes
                          }).catchError((error) {
                            // Handle any errors that occur during the asynchronous operation
                            print('Error: $error');
                          });
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: isAvailable
                        ? ResponsiveSize.calculateHeight(0, context)
                        : ResponsiveSize.calculateHeight(15, context),
                  ),
                  Visibility(
                    visible: !isAvailable,
                    child: Container(
                      width: 321,
                      height: 60,
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.12999999523162842),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: AppResources.colorVitamine),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //Image.asset('images/info_icon.png'),
                            const Icon(Icons.info_outline,
                                size: 24, color: AppResources.colorVitamine),
                            SizedBox(
                                width: ResponsiveSize.calculateWidth(
                                    10, context)),
                            Text(
                              'Tes disponibilités s’appliquent à toutes tes \nexpériences.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: AppResources.colorVitamine),
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(
                      height: ResponsiveSize.calculateHeight(25, context)),
                ],
              ),
            ),
            Visibility(
              visible: !isAvailable,
              child: Column(
                children: availabilityList.map((item) {
                  return DayAvailable(availabilityList: item);
                }).toList(),
              ),
            ),
            SizedBox(
              height: isAvailable
                  ? ResponsiveSize.calculateHeight(0, context)
                  : ResponsiveSize.calculateHeight(23, context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Absences exceptionnelles',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                              fontSize: 20, color: AppResources.colorDark),
                        ),
                        const SizedBox(height: 17),
                        Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et par defaut toutes nos expériences sont disponibles en français',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppResources.colorGray30),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return const ExceptionalAbsences();
                        },
                      );
                    },
                    child: Text(
                      'Ajouter une abscence',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppResources.colorVitamine),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: absenceList.map((absence) {
                if(absence.day == null) {
                  final startDate = absence.dateFrom;
                  final formattedStartDate = yearsFrenchFormat(startDate!);
                  final endDate = absence.dateTo;
                  final formattedEndDate = yearsFrenchFormat(endDate!);
                  return listExceptionalAbsences(formattedStartDate, formattedEndDate, startDate, endDate, absence.from ?? '', absence.to ?? '');
                } else {
                  final startDate = absence.day;
                  final formattedStartDate = yearsFrenchFormat(startDate!);
                  final endDate = absence.day;
                  final formattedEndDate = yearsFrenchFormat(endDate!);
                  return listExceptionalAbsences(formattedStartDate, formattedEndDate, startDate, endDate, absence.from ?? '', absence.to ?? '');
                }
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget listExceptionalAbsences(String startDate, String endDate, String startFormatDate, String endFormatDate, String startHour, String endHour) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return ModifyExceptionalAbsences(firstFormatDate: startFormatDate, lastFormatDate: endFormatDate, startHour: startHour, endHour: endHour,);
          },
        );
      },
      child: Column(
        children: [
          const SizedBox(height: 19),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 31),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Du $startDate au $endDate',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, color: const Color(0xFF797979)),
                ),
                Image.asset('images/chevron_right.png',
                    width: 27, height: 27, fit: BoxFit.fill),
              ],
            ),
          ),
          const SizedBox(height: 19),
          Container(
            width: 390,
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: AppResources.colorImputStroke,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

