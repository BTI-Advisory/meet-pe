import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../models/guide_reservation_response.dart';
import '../resources/resources.dart';
import '../services/app_service.dart';
import '../utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequestCard extends StatefulWidget {
  final GuideReservationResponse guideReservationResponse;
  final Function onUpdateStatus;
  final BuildContext parentContext;
  final bool isGroup;

  RequestCard({
    super.key,
    required this.guideReservationResponse,
    required this.onUpdateStatus,
    required this.parentContext,
    required this.isGroup
  });

  @override
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  bool isLoading = false; // To show loading indicator if needed

  Future<void> _updateStatus(String newStatus) async {
    setState(() {
      isLoading = true;
    });

    try {
      bool result = await AppService.api.updateReservationStatus(widget.guideReservationResponse.id, newStatus);
      if (result) {
        print("Status updated successfully!");
      } else {
        print("Failed to update status.");
      }

      widget.onUpdateStatus();
    } catch (e) {
      print('Error updating reservation status: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: (widget.guideReservationResponse.status == 'En attente') ? AppResources.colorVitamine : AppResources.colorWhite,
                      width: 1,
                    ),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x1E000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          ClipOval(
                            child: Image.network(widget.guideReservationResponse.voyageur.profilePath, width: 38, height: 38, fit: BoxFit.cover),
                          ),
                          const SizedBox(height: 2),
                          SizedBox(
                            width: 60,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                widget.guideReservationResponse.voyageur.name,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontWeight: FontWeight.w500, color: AppResources.colorDark),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 17),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            requestFrenchFormat(widget.guideReservationResponse.dateTime),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontSize: 14, color: AppResources.colorDark),
                          ),
                          SizedBox(
                            width: 140,
                            child: Text(
                              widget.guideReservationResponse.experience.title,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray60),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Text(
                            widget.guideReservationResponse.isGroup == 1 ? "Groupe privée" : "${widget.guideReservationResponse.nombreDesVoyageurs} personnes",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontSize: 14, color: AppResources.colorDark),
                          ),
                        ],
                      ),
                      const SizedBox(width: 23),
                      Visibility(
                        visible: (widget.guideReservationResponse.status != 'Acceptée'),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                PanaraConfirmDialog.showAnimatedGrow(
                                  widget.parentContext,
                                    title: AppLocalizations.of(widget.parentContext)!.are_you_sure_text,
                                    message: AppLocalizations.of(widget.parentContext)!.are_you_sure_desc_acc_text,
                                    confirmButtonText: AppLocalizations.of(widget.parentContext)!.confirmation_text,
                                    cancelButtonText: AppLocalizations.of(widget.parentContext)!.cancel_text,
                                    onTapCancel: () {
                                      Navigator.pop(widget.parentContext); // Close dialog without changing state
                                    },
                                    onTapConfirm: () {
                                      Navigator.pop(widget.parentContext); // Close dialog first
                                      setState(() async {
                                        await _updateStatus('Acceptée'); // Update status asynchronously
                                      });
                                    },
                                    panaraDialogType: PanaraDialogType.success,
                                );
                              },
                              child: Column(
                                children: [
                                  isLoading
                                      ? CircularProgressIndicator() // Show loading indicator
                                      : Icon(Icons.check, size: 24,),
                                  const SizedBox(height: 4),
                                  Text(
                                    AppLocalizations.of(widget.parentContext)!.accept_text,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(color: AppResources.colorDark),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 15),
                            GestureDetector(
                              onTap: () {
                                PanaraConfirmDialog.showAnimatedGrow(
                                  widget.parentContext,
                                  title: AppLocalizations.of(widget.parentContext)!.are_you_sure_text,
                                  message: AppLocalizations.of(widget.parentContext)!.are_you_sure_desc_ref_text,
                                  confirmButtonText: AppLocalizations.of(widget.parentContext)!.confirmation_text,
                                  cancelButtonText: AppLocalizations.of(widget.parentContext)!.cancel_text,
                                  onTapCancel: () {
                                    Navigator.pop(widget.parentContext); // Close dialog without changing state
                                  },
                                  onTapConfirm: () {
                                    Navigator.pop(widget.parentContext); // Close dialog first
                                    setState(() async {
                                      await _updateStatus('Refusée'); // Update status asynchronously
                                    });
                                  },
                                  panaraDialogType: PanaraDialogType.error,
                                );
                              },
                              child: Column(
                                children: [
                                  isLoading
                                      ? CircularProgressIndicator() // Show loading indicator
                                      : Icon(Icons.close, size: 24,),
                                  const SizedBox(height: 4),
                                  Text(
                                    AppLocalizations.of(widget.parentContext)!.refuse_text,
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
                      Visibility(
                        visible: (widget.guideReservationResponse.status == 'Acceptée'),
                        child: Row(
                          children: [
                            const SizedBox(width: 35),
                            const Icon(Icons.check, size: 24, color: Color(0xFF54EE9D),),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(widget.parentContext)!.accepted_text,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: Color(0xFF54EE9D)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 11),
                ],
              ),
            ),
            Visibility(
              visible: (widget.guideReservationResponse.status == 'En attente'),
              child: Positioned(
                  top: -5,
                  left: 63,
                  child: Container(
                    width: 43,
                    height: 18,
                    decoration: ShapeDecoration(
                      color: AppResources.colorVitamine,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Center(
                      child: Text(
                          'New',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 12, color: AppResources.colorWhite)
                      ),
                    ),
                  )
              ),
            )
          ],
        ),
        const SizedBox(height: 19),
      ],
    );
  }
}