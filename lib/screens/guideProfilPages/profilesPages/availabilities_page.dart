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

  void _toggleAvailability(bool value) async {
    setState(() {
      isAvailable = value;
    });

    try {
      await AppService.api.sendFullAvailable(value);
    } catch (e) {
      print('Error updating availability: $e');
      setState(() {
        isAvailable = !value;
      });
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

  void _onAbsenceModified() {
    fetchAbsenceData();
  }

  void _onAvailabilityModified() {
    fetchAvailabilityData();
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
                        onChanged: _toggleAvailability,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: !isAvailable,
              child: Column(
                children: availabilityList.map((item) {
                  return DayAvailable(availabilityList: item, onAvailabilityModified: _onAvailabilityModified,);
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
                          'Tu prends des vacances ? Tu es absent pendant une longue période ? Rensigne ici tes absences exceptionnelles. Durant celles-ci les voyageurs ne pourront pas réserver tes expériences.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppResources.colorGray30),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final result = await showModalBottomSheet<bool>(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return ExceptionalAbsences();
                        },
                      );

                      if (result == true) {
                        fetchAbsenceData();
                      }
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
                final startDate = absence.day ?? absence.dateFrom!;
                final endDate = absence.day ?? absence.dateTo!;
                final formattedStartDate = yearsFrenchFormat(startDate);
                final formattedEndDate = yearsFrenchFormat(endDate);

                return _listExceptionalAbsences(absence.id, formattedStartDate, formattedEndDate, startDate, endDate, absence.from ?? '', absence.to ?? '');
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listExceptionalAbsences(int id, String startDate, String endDate, String startFormatDate, String endFormatDate, String startHour, String endHour) {
    return InkWell(
      onTap: () async {
        bool? modified = await showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return ModifyExceptionalAbsences(
              id: id,
              firstFormatDate: startFormatDate,
              lastFormatDate: endFormatDate,
              startHour: startHour,
              endHour: endHour,
              onAbsenceModified: _onAbsenceModified,
            );
          },
        );

        if (modified == true) {
          fetchAbsenceData();
        }
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
                Icon(Icons.chevron_right, size: 27, color: AppResources.colorVitamine),
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
          ),
        ],
      ),
    );
  }
}

