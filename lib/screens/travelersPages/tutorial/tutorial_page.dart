import 'package:flutter/material.dart';

import '../../../services/secure_storage_service.dart';
import '../../../utils/_utils.dart';
import '../main_travelers_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {

    if (await SecureStorageService.readIsFirstLaunch() == null) {
      SecureStorageService.saveIsFirstLaunch('true');
      navigateTo(context, (_) => TutorialPage());
    } else {
      navigateTo(context, (_) => MainTravelersPage(initialPage: 0,));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class TutorialPage extends StatefulWidget {
  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  int _currentIndex = 0;
  final List<String> _tutorialImages = [
    /*'images/tutorial1.svg',
    'images/tutorial2.svg',
    'images/tutorial3.svg',
    'images/tutorial4.svg',
    'images/tutorial5.svg',*/

    'images/tutorial1.png',
    'images/tutorial2.png',
    'images/tutorial3.png',
    'images/tutorial4.png',
    'images/tutorial5.png',
    'images/tutorial6.png',
  ];

  void _nextImage() {
    if (_currentIndex < _tutorialImages.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      navigateTo(context, (_) => MainTravelersPage(initialPage: 0,));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: _nextImage,
        child: Center(
          //child: SvgPicture.asset(_tutorialImages[_currentIndex], width: double.infinity, height: double.infinity,),
          child: Image.asset(_tutorialImages[_currentIndex], width: double.infinity, height: double.infinity, fit: BoxFit.fill,),
        ),
      ),
    );
  }
}
