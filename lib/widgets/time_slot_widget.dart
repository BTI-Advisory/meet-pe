import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeSlotWidget extends StatefulWidget {
  final List<Map<String, TimeOfDay?>> initialTimeSlots;
  final Function(List<Map<String, TimeOfDay?>>) onTimeSlotsChanged;
  final bool active;
  final bool validateTimes;

  const TimeSlotWidget({
    Key? key,
    required this.initialTimeSlots,
    required this.onTimeSlotsChanged,
    required this.active,
    this.validateTimes = true
  }) : super(key: key);

  @override
  State<TimeSlotWidget> createState() => _TimeSlotWidgetState();
}

class _TimeSlotWidgetState extends State<TimeSlotWidget> {
  late List<Map<String, TimeOfDay?>> timeSlots;

  @override
  void initState() {
    super.initState();
    timeSlots = List.from(widget.initialTimeSlots);
  }

  bool _isEndTimeAfterStartTime(TimeOfDay start, TimeOfDay end) {
    final int startMinutes = start.hour * 60 + start.minute;
    final int endMinutes = end.hour * 60 + end.minute;

    return endMinutes > startMinutes;
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartTime, int index) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // Adjust time to the nearest 15-minute interval
      int roundedMinutes = (pickedTime.minute / 15).round() * 15;
      if (roundedMinutes == 60) {
        roundedMinutes = 0;
      }
      final adjustedTime = TimeOfDay(hour: pickedTime.hour, minute: roundedMinutes);

      setState(() {
        if (isStartTime) {
          timeSlots[index]["start"] = adjustedTime;

          if (widget.validateTimes && timeSlots[index]["end"] != null &&
              !_isEndTimeAfterStartTime(timeSlots[index]["start"]!, timeSlots[index]["end"]!)) {
            timeSlots[index]["end"] = null;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.hour_condition_text),
              ),
            );
          }
        } else {
          if (widget.validateTimes && timeSlots[index]["start"] != null &&
              !_isEndTimeAfterStartTime(timeSlots[index]["start"]!, adjustedTime)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.hour_condition_2_text),
              ),
            );
          } else {
            timeSlots[index]["end"] = adjustedTime;
          }
        }
        widget.onTimeSlotsChanged(timeSlots);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < timeSlots.length; i++)
          Column(
            children: [
              Row(
                children: [
                  /// Start Time
                  _buildTimePicker(context, i, isStartTime: true),
                  const SizedBox(width: 8),
                  /// End Time
                  _buildTimePicker(context, i, isStartTime: false),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        /// Add/Delete Time Slot Button
        Visibility(
          visible: widget.active,
          child: TextButton(
            onPressed: () {
              setState(() {
                if (timeSlots.length == 1) {
                  timeSlots.add({"start": null, "end": null});
                } else {
                  timeSlots.removeLast();
                }
                widget.onTimeSlotsChanged(timeSlots);
              });
            },
            child: Text(
              timeSlots.length == 1 ? AppLocalizations.of(context)!.add_hour_text : AppLocalizations.of(context)!.delete_hour_text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker(BuildContext context, int index, {required bool isStartTime}) {
    final String label = isStartTime ? AppLocalizations.of(context)!.from_hour_text : AppLocalizations.of(context)!.to_hour_text;
    final TimeOfDay? time = timeSlots[index][isStartTime ? "start" : "end"];
    return Expanded(
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: InkWell(
          onTap: () => _selectDateTime(context, isStartTime, index),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
              Text(
                time == null ? (isStartTime ? "00:00" : "23:59") : time.format(context),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
