import 'package:flutter/material.dart';
import '../../resources/resources.dart';
import '../../utils/_utils.dart';
import 'loginPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IntroMovePage extends StatefulWidget {
  const IntroMovePage({super.key});

  @override
  State<IntroMovePage> createState() => _IntroMovePageState();
}

final Widget ellipseFullContainer = Container(
  width: 30,
  height: 8,
  decoration: ShapeDecoration(
    color: AppResources.colorVitamine,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);

final Widget ellipseEmptyContainer = Container(
  width: 8,
  height: 8,
  decoration: ShapeDecoration(
    shape: OvalBorder(
      side: BorderSide(width: 1, color: AppResources.colorVitamine),
    ),
  ),
);

class _IntroMovePageState extends State<IntroMovePage> {
  PageController controller = PageController();
  late int _curr;
  late List<Widget> _list;

  @override
  void initState() {
    super.initState();
    controller = PageController();
    _curr = 0;
  }

  void navigateToNextPage() {
    if (_curr < _list.length - 1) {
      controller.animateToPage(
        _curr + 1,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _list = [
      Center(
        child: Pages(
          text: AppLocalizations.of(context)!.move,
          description: AppLocalizations.of(context)!.move_desc,
          imageName: 'introMove',
          ellipseOne: ellipseFullContainer,
          ellipseTow: ellipseEmptyContainer,
          ellipseThree: ellipseEmptyContainer,
          buttonShow: false,
          onNextPage: navigateToNextPage,
        ),
      ),
      Center(
          child: Pages(
            text: AppLocalizations.of(context)!.meet,
            description: AppLocalizations.of(context)!.meet_desc,
            imageName: 'introMeet',
            ellipseOne: ellipseEmptyContainer,
            ellipseTow: ellipseFullContainer,
            ellipseThree: ellipseEmptyContainer,
            buttonShow: false,
            onNextPage: navigateToNextPage,
          )),
      Center(
        child: Pages(
          text: AppLocalizations.of(context)!.share,
          description: AppLocalizations.of(context)!.share_desc,
          imageName: 'introShare',
          ellipseOne: ellipseEmptyContainer,
          ellipseTow: ellipseEmptyContainer,
          ellipseThree: ellipseFullContainer,
          buttonShow: true,
          onNextPage: () {},
        ),
      )
    ];
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFEDD8BE), Colors.white],
                )),
            child: PageView(
              allowImplicitScrolling: true,
              children: _list,
              scrollDirection: Axis.horizontal,
              // reverse: true,
              // physics: BouncingScrollPhysics(),
              controller: controller,
              onPageChanged: (num) {
                setState(() {
                  _curr = num;
                });
              },
            ),
          ),
          Positioned(
            right: 28,
            top: 38,
            child: TextButton(
              onPressed: () {
                navigateTo(context, (_) => const LoginPage());
              },
              child: Text(
                AppLocalizations.of(context)!.passer_button,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Pages extends StatelessWidget {
  final text;
  final description;
  final imageName;
  final Widget ellipseOne;
  final Widget ellipseTow;
  final Widget ellipseThree;
  final buttonShow;
  final VoidCallback onNextPage;

  Pages(
      {this.text,
        this.description,
        this.imageName,
        required this.ellipseOne,
        required this.ellipseTow,
        required this.ellipseThree,
        this.buttonShow,
        required this.onNextPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveSize.calculateWidth(320, context),
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('images/$imageName.png', width: ResponsiveSize.calculateWidth(250, context), height: ResponsiveSize.calculateHeight(262, context),),
              SizedBox(height: ResponsiveSize.calculateHeight(80, context)),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF161413),
                  fontSize: ResponsiveSize.calculateTextSize(32, context),
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: ResponsiveSize.calculateHeight(16, context)),
              Text(description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                  softWrap: true),
              SizedBox(height: ResponsiveSize.calculateHeight(44, context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ellipseOne,
                  SizedBox(width: 8),
                  ellipseTow,
                  SizedBox(width: 8),
                  ellipseThree,
                ],
              ),
              if (buttonShow == true) ...[
                SizedBox(height: ResponsiveSize.calculateHeight(122, context)),
                SizedBox(
                  width: ResponsiveSize.calculateWidth(183, context),
                  height: 44,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Color(0xFFFF4C00)),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(24, context)),
                            ))),
                    child: Text(
                      'C’EST PARTI !!!',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorWhite),
                    ),
                    onPressed: () {
                      navigateTo(context, (_) => const LoginPage());
                    },
                  ),
                ),
              ] else ...[
                SizedBox(height: ResponsiveSize.calculateHeight(122, context)),
                SizedBox(
                  width: ResponsiveSize.calculateWidth(183, context),
                  height: ResponsiveSize.calculateHeight(44, context),
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Color(0xFFFF4C00)),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(24, context)),
                            ))),
                    onPressed: !buttonShow ? onNextPage : null,
                    child: Image.asset('images/arrowLongRight.png'),
                  ),
                ),
              ]
            ]),
      ),
    );
  }
}
