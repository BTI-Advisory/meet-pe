import 'package:flutter/material.dart';

import '../../../models/absence_list_response.dart';
import '../../../models/availability_list_response.dart';
import '../../../resources/resources.dart';
import '../../../services/app_service.dart';
import '../../../utils/_utils.dart';
import '../../../widgets/_widgets.dart';
import '../../../widgets/modify_exceptional_absences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AvailabilitiesPage extends StatefulWidget {
  const AvailabilitiesPage({super.key});

  @override
  State<AvailabilitiesPage> createState() => _AvailabilitiesPageState();
}

class _AvailabilitiesPageState extends State<AvailabilitiesPage> {
  bool isAvailable = false;
  List<AbsenceListResponse> absenceList = [];
  List<AvailabilityListResponse> availabilityList = [];

  // Initialize the ScrollController
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchAbsenceData();
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

  // Scroll to the end of the page
  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EpAppBar(
        title: AppLocalizations.of(context)!.my_absences_text,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
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
                          AppLocalizations.of(context)!.exceptional_absences_text,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                              fontSize: 20, color: AppResources.colorDark),
                        ),
                        const SizedBox(height: 17),
                        Text(
                          AppLocalizations.of(context)!.exceptional_absences_desc_text,
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
                        _scrollToEnd();
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.add_absence_text,
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

                return _listExceptionalAbsences(absence.id, formattedStartDate, formattedEndDate, startDate, endDate);
              }).toList(),
            ),
            const SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }

  Widget _listExceptionalAbsences(int id, String startDate, String endDate, String startFormatDate, String endFormatDate) {
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
                  '${AppLocalizations.of(context)!.from_text} $startDate ${AppLocalizations.of(context)!.to_text} $endDate',
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

