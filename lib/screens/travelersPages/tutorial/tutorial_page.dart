import 'package:flutter/material.dart';

import '../../../resources/resources.dart';
import '../../../utils/_utils.dart';
import '../main_travelers_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TutorialPage extends StatefulWidget {
  final MainTravelersPage mainTravelersPage;

  TutorialPage({required this.mainTravelersPage});

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  int _currentStep = 0;
  bool _showTutorial = true;
  Offset? highlightPosition;
  Size? highlightSize;
  bool _isLoading = true;

  List<Map<String, dynamic>> _tutorialSteps = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 500), () {
        _calculateTutorialSteps();
        _updateHighlight();
      });
    });
  }

  void _calculateTutorialSteps() {
    final favorKey = widget.mainTravelersPage.favorKey;
    final percentKey = widget.mainTravelersPage.percentKey;
    final searchCityKey = widget.mainTravelersPage.searchCityKey;
    final aroundMeKey = widget.mainTravelersPage.aroundMeKey;
    final filtersKey = widget.mainTravelersPage.filtersKey;

    final favorPosition = _getWidgetPosition(favorKey);
    final percentPosition = _getWidgetPosition(percentKey);
    final searchCityPosition = _getWidgetPosition(searchCityKey);
    final aroundMePosition = _getWidgetPosition(aroundMeKey);
    final filtersPosition = _getWidgetPosition(filtersKey);

    setState(() {
      _tutorialSteps = [
        {
          'title': AppLocalizations.of(context)!.tutorial_step_1_title_text,
          'description': AppLocalizations.of(context)!.tutorial_step_1_descr_text,
          'buttonText': AppLocalizations.of(context)!.tutorial_button_1_text,
          'alignment': Alignment.topCenter,
          'position': EdgeInsets.only(top: favorPosition.dy + 100, left: 20, right: 20),
          'highlightPosition': favorPosition,
          'key': widget.mainTravelersPage.favorKey,
        },
        {
          'title': AppLocalizations.of(context)!.tutorial_step_2_title_text,
          'description': AppLocalizations.of(context)!.tutorial_step_2_descr_text,
          'buttonText': AppLocalizations.of(context)!.tutorial_button_1_text,
          'alignment': Alignment.topCenter,
          'position': EdgeInsets.only(top: percentPosition.dy + 100, left: 20, right: 20),
          'highlightPosition': percentPosition,
          'key': widget.mainTravelersPage.percentKey,
        },
        {
          'title': AppLocalizations.of(context)!.tutorial_step_3_title_text,
          'description': AppLocalizations.of(context)!.tutorial_step_3_descr_text,
          'buttonText': AppLocalizations.of(context)!.tutorial_button_1_text,
          'alignment': Alignment.topCenter,
          'position': EdgeInsets.only(top: searchCityPosition.dy + 100, left: 20, right: 20),
          'highlightPosition': searchCityPosition,
          'key': widget.mainTravelersPage.searchCityKey,
        },
        {
          'title': AppLocalizations.of(context)!.tutorial_step_4_title_text,
          'description': AppLocalizations.of(context)!.tutorial_step_4_descr_text,
          'buttonText': AppLocalizations.of(context)!.tutorial_button_1_text,
          'alignment': Alignment.topCenter,
          'position': EdgeInsets.only(top: aroundMePosition.dy + 100, left: 20, right: 20),
          'highlightPosition': aroundMePosition,
          'key': widget.mainTravelersPage.aroundMeKey,
        },
        {
          'title': AppLocalizations.of(context)!.tutorial_step_5_title_text,
          'description': AppLocalizations.of(context)!.tutorial_step_5_descr_text,
          'buttonText': AppLocalizations.of(context)!.tutorial_button_2_text,
          'alignment': Alignment.center,
          'position': EdgeInsets.only(top: filtersPosition.dy + 100, left: 20, right: 20),
          'highlightPosition': filtersPosition,
          'key': widget.mainTravelersPage.filtersKey,
        },
      ];
      _isLoading = false;
    });
  }

  Offset _getWidgetPosition(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return Offset.zero;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return Offset.zero;
    return renderBox.localToGlobal(Offset.zero);
  }

  void _finishTutorial() {
    setState(() {
      _showTutorial = false;
    });
  }

  void _skipTutorial() {
    _finishTutorial();
  }

  void _updateHighlight() {
    final currentKey = _tutorialSteps[_currentStep]['key'] as GlobalKey;
    final keyContext = currentKey.currentContext;

    if (keyContext != null) {
      final box = keyContext.findRenderObject() as RenderBox?;
      if (box != null) {
        setState(() {
          highlightPosition = box.localToGlobal(Offset.zero);
          highlightSize = box.size;
        });
      }
    } else {
      Future.delayed(Duration(milliseconds: 300), _updateHighlight);
    }
  }

  void _nextStep() {
    if (_currentStep < _tutorialSteps.length - 1) {
      setState(() {
        _currentStep++;
      });
      _updateHighlight();
    } else {
      _finishTutorial();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          widget.mainTravelersPage,

          if (_showTutorial && highlightPosition != null && highlightSize != null)
            Positioned.fill(
              child: AbsorbPointer(
                absorbing: false,
                child: CustomPaint(
                  painter: HolePainter(
                    position: highlightPosition!,
                    size: highlightSize!,
                  ),
                ),
              ),
            ),

          if (_showTutorial && highlightPosition != null && highlightSize != null && _tutorialSteps.isNotEmpty)
            Positioned(
              top: _currentStep == 0
                  ? highlightPosition!.dy - 250
                  : highlightPosition!.dy + highlightSize!.height + 20,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _tutorialSteps[_currentStep]['title'],
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: AppResources.colorDark, fontSize: 14),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: _skipTutorial,
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      _tutorialSteps[_currentStep]['description'],
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                    ),
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _nextStep,
                        child: Text(
                          _tutorialSteps[_currentStep]['buttonText'],
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppResources.colorVitamine),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class HolePainter extends CustomPainter {
  final Offset position;
  final Size size;

  HolePainter({required this.position, required this.size});

  @override
  void paint(Canvas canvas, Size screenSize) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final holePath = Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, screenSize.width, screenSize.height)),
      Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              position.dx - 10,
              position.dy - 10,
              size.width + 20,
              size.height + 20,
            ),
            Radius.circular(12),
          ),
        ),
    );

    canvas.drawPath(holePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
