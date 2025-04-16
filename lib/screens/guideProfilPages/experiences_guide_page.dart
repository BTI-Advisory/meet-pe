import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../models/experience_data_response.dart';
import '../../models/guide_reservation_response.dart';
import '../../resources/app_theme.dart';
import '../../resources/resources.dart';
import '../../services/app_service.dart';
import '../../widgets/_widgets.dart';
import '../onBoardingPages/guide/create_experience/create_exp_step1.dart';
import 'experiencePages/edit_experience_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExperiencesGuidePage extends StatefulWidget {
  const ExperiencesGuidePage({super.key});

  @override
  State<ExperiencesGuidePage> createState() => _ExperiencesGuidePageState();
}

class _ExperiencesGuidePageState extends State<ExperiencesGuidePage> {
  bool isRequest = false; // Track if it's currently "Request" or "Experience"
  //List<GuideReservationResponse> reservationList = [];
  late Map<String, GuideReservationGroup> reservationList = {};
  late Map<String, List<GuideReservationResponse>> groupedReservations;
  List<ExperienceDataResponse> experiencesList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    groupedReservations = {};
    fetchGuideReservationData();
    fetchGuideExperiencesData();
  }

  void toggleRole() {
    setState(() {
      isRequest = !isRequest;
    });
  }

  Future<void> fetchGuideReservationData() async {
    try {
      final response = await AppService.api.getGuideReservationList();
      print("🌍 Raw API Response: $response"); // Debugging

      if (response.isEmpty) {
        print("⚠️ API returned an empty response, setting empty map.");
        setState(() {
          reservationList = {};
          groupedReservations = {};
        });
        return;
      }

      setState(() {
        reservationList = response;
        groupedReservations = reservationList.map((date, group) => MapEntry(date, group.reservations));
      });

      print("✅ Successfully fetched reservations: $reservationList");
    } catch (e) {
      print("❌ Error fetching reservation list: $e");
    }
  }

  Future<void> fetchGuideExperiencesData() async {
    try {
      final response = await AppService.api.getGuideExperiencesList();
      setState(() {
        experiencesList = response;
      });
    } catch (e) {
      // Handle error
      print('Error fetching experiences list: $e');
    }
  }

  Future<void> _updateReservation() async {
    await fetchGuideReservationData(); // Refresh the data list
  }

  Future<void> _updateReservationStatus(
      int reservationId, String status) async {
    setState(() {
      isLoading = true;
    });

    try {
      final bool result =
          await AppService.api.updateReservationStatus(reservationId, status);
      if (result) {
        await fetchGuideReservationData(); // Refresh the data list after a successful update
        Navigator.pop(context, true);
      } else {
        print('Update failed');
        Navigator.pop(context, false);
      }
    } catch (e) {
      print('Error updating reservation status: $e');
      Navigator.pop(context, false);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: buildAppTheme(),
      home: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            if (isRequest) {
              await fetchGuideReservationData();
            } else {
              await fetchGuideExperiencesData();
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.calculateWidth(28, context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 73),
                      Text(
                        AppLocalizations.of(context)!.my_experiences_text,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.no_experiences_text,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppResources.colorGray30),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                buildToggleButtons(),
                const SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.calculateWidth(13, context)),
                  child: isRequest
                      ? Column(
                    children: reservationList.isEmpty
                        ? [
                      SizedBox(
                        height: ResponsiveSize.calculateHeight(
                            150, context),
                      ),
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!.no_reservations_text,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                              color: AppResources.colorGray100),
                        ),
                      ),
                    ]
                        : reservationList.entries.map((entry) {
                      GuideReservationGroup group = entry.value; // Extract the group

                      return ExpansionTile(
                        title: Text(
                          requestFrenchFormat(entry.key), // Date as the title
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        subtitle: Text(
                          group.isPrivateGroup
                              ? 'Groupe privée'
                              : '${group.acceptedReservationsCount}/${group.reservations.isNotEmpty ? group.reservations.first.experience.nombreDesVoyageur : 0}',
                          style: TextStyle(color: Colors.grey),
                        ),
                        children: group.reservations.map((reservation) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialog(context, reservation),
                              ).then((value) {
                                fetchGuideReservationData();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: RequestCard(
                                guideReservationResponse: reservation,
                                onUpdateStatus: _updateReservation,
                                parentContext: context,
                                isGroup: group.isPrivateGroup,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  )
                      : Column(
                    children: experiencesList.isEmpty
                        ? [
                      SizedBox(
                        height: ResponsiveSize.calculateHeight(
                            150, context),
                      ),
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!.noo_experiences_text,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                              color: AppResources.colorGray100),
                        ),
                      ),
                    ]
                        : List.generate(
                      experiencesList.length,
                          (index) => GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (_) => EditExperiencePage(
                                  experienceData: experiencesList[index]),
                            ),
                          ).then((_) async {
                            // Introduce a short delay before refreshing
                            await Future.delayed(const Duration(milliseconds: 1000));

                            // Refresh the experience list after a successful deletion
                            await fetchGuideExperiencesData();
                            setState(() {});
                          });
                        },
                        child: MyCardExperience(
                          guideExperiencesResponse: experiencesList[index],
                          parentContext: context,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Visibility(
          visible: !isRequest,
          child: SizedBox(
            width: 116.0,
            height: 48.0,
            child: FloatingActionButton(
              onPressed: () {
                // Add your action here
                print('Floating Action Button pressed');
                navigateTo(context, (_) => const CreateExpStep1());
              },
              backgroundColor: AppResources.colorVitamine,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    40.0), // Half of width or height to make it circular
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, color: AppResources.colorWhite),
                  Text(
                    AppLocalizations.of(context)!.create_exp_text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                        color: AppResources.colorWhite),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget buildToggleButtons() {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth / 2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (!isRequest) toggleRole();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(AppLocalizations.of(context)!.request_text,
                    style: isRequest
                        ? Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: AppResources.colorVitamine)
                        : Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppResources.colorDark)),
              ),
              const SizedBox(height: 4),
              (isRequest)
                ? Container(
                  width: buttonWidth,
                  height: 4,
                  decoration: const ShapeDecoration(
                    color: AppResources.colorVitamine,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                      ),
                    ),
                  ),
                )
              : Column(
                children: [
                  const SizedBox(height: 3,),
                  Container(
                    width: buttonWidth,
                    height: 1,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: AppResources.colorImputStroke
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            if (isRequest) toggleRole();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(AppLocalizations.of(context)!.my_experiences_text,
                    style: isRequest
                        ? Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppResources.colorDark)
                        : Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: AppResources.colorVitamine)),
              ),
              const SizedBox(height: 4),
              (!isRequest)
                ? Container(
                  width: buttonWidth,
                  height: 4,
                  decoration: const ShapeDecoration(
                    color: AppResources.colorVitamine,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                      ),
                    ),
                  ),
                ) : Column(
                  children: [
                    const SizedBox(height: 3,),
                    Container(
                    width: buttonWidth,
                    height: 1,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: AppResources.colorImputStroke
                        ),
                      ),
                    ),
                                  ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopupDialog(
      BuildContext context, GuideReservationResponse reservation) {
    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(horizontal: 0),
        backgroundColor: AppResources.colorWhite,
        content: SizedBox(
            width: 329,
            height: 420,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 21),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipOval(
                                  child: Image.network(
                                      reservation.voyageur.profilePath,
                                      width: 75,
                                      height: 75,
                                      fit: BoxFit.cover)),
                              SizedBox(
                                  width: ResponsiveSize.calculateWidth(
                                      19, context)),
                              Text(reservation.voyageur.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: AppResources.colorDark)),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close,
                                size: 20, color: AppResources.colorGray30),
                          )
                        ],
                      ),
                      const SizedBox(height: 21),
                      Row(
                        children: [
                          Visibility(
                            visible: reservation.voyageur.isVerified,
                            child: Container(
                              height:
                                  ResponsiveSize.calculateHeight(28, context),
                              padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveSize.calculateWidth(
                                      12, context)),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(
                                    ResponsiveSize.calculateCornerRadius(
                                        20, context))),
                                border:
                                    Border.all(color: AppResources.colorDark),
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    SvgPicture.asset('images/icon_verified.svg', color: AppResources.colorDark),
                                    SizedBox(
                                        width: ResponsiveSize.calculateWidth(
                                            4, context)),
                                    Text(
                                      AppLocalizations.of(context)!.verified_text,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: AppResources.colorDark,
                                            fontSize: 12,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                              visible: reservation.voyageur.isVerified,
                              child: SizedBox(
                                  width: ResponsiveSize.calculateWidth(
                                      41, context))),
                          Text(
                            AppLocalizations.of(context)!.lived_experience,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppResources.colorDark),
                          ),
                          SizedBox(
                              width: ResponsiveSize.calculateWidth(5, context)),
                          Text(
                            "${reservation.voyageur.livedExperiences}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: AppResources.colorDark),
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '${AppLocalizations.of(context)!.experience_reserved_text} ${yearsFrenchFormat(reservation.createdAt)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppResources.colorDark, fontSize: 12),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        reservation.experience.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                color: AppResources.colorDark, fontSize: 14),
                      ),
                      const SizedBox(height: 23),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.number_traveler_text,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: AppResources.colorDark,
                                    fontSize: 12),
                          ),
                          Text(
                            reservation.nombreDesVoyageurs.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: AppResources.colorDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.reserved_slot_text,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: AppResources.colorDark,
                                    fontSize: 12),
                          ),
                          Text(
                            requestFrenchFormat(reservation.dateTime),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: AppResources.colorDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
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
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Visibility(
                    visible: reservation.status != 'Acceptée',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            PanaraConfirmDialog.showAnimatedGrow(
                              context,
                              title: AppLocalizations.of(context)!.are_you_sure_text,
                              message: AppLocalizations.of(context)!.are_you_sure_desc_acc_text,
                              confirmButtonText: AppLocalizations.of(context)!.confirmation_text,
                              cancelButtonText: AppLocalizations.of(context)!.cancel_text,
                              onTapCancel: () {
                                Navigator.pop(context); // Close dialog without changing state
                              },
                              onTapConfirm: () {
                                Navigator.pop(context); // Close dialog first
                                setState(() async {
                                  await _updateReservationStatus(reservation.id, 'Acceptée');
                                });
                              },
                              panaraDialogType: PanaraDialogType.success,
                            );
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.check,
                                size: 24,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppLocalizations.of(context)!.accept_text,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: AppResources.colorDark),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 19),
                        GestureDetector(
                          onTap: () async {
                            PanaraConfirmDialog.showAnimatedGrow(
                              context,
                              title: AppLocalizations.of(context)!.are_you_sure_text,
                              message: AppLocalizations.of(context)!.are_you_sure_desc_ref_text,
                              confirmButtonText: AppLocalizations.of(context)!.confirmation_text,
                              cancelButtonText: AppLocalizations.of(context)!.cancel_text,
                              onTapCancel: () {
                                Navigator.pop(context); // Close dialog without changing state
                              },
                              onTapConfirm: () {
                                Navigator.pop(context); // Close dialog first
                                setState(() async {
                                  await _updateReservationStatus(reservation.id, 'Refusée');
                                });
                              },
                              panaraDialogType: PanaraDialogType.error,
                            );
                          },
                          child: Column(
                            children: [
                              const Icon(
                                Icons.close,
                                size: 24,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppLocalizations.of(context)!.refuse_text,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: AppResources.colorDark),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            )));
  }
}

extension IterableExtensions<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keySelector) {
    final Map<K, List<E>> map = {};
    for (var element in this) {
      final key = keySelector(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }
}
