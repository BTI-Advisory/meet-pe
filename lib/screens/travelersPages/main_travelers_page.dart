import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../resources/icons/font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/_utils.dart';
import '../../widgets/_widgets.dart';
import '../../widgets/themed/ep_tabbed_travelers_page.dart';
import 'favoris_page.dart';
import 'matching_page.dart';
import 'messages_travelers_page.dart';
import 'profile_travelers_page.dart';

class MainTravelersPage extends StatefulWidget {
  MainTravelersPage({super.key, required this.initialPage});

  var initialPage = 0;
  final GlobalKey favorKey = GlobalKey();
  final GlobalKey percentKey = GlobalKey();
  final GlobalKey searchCityKey = GlobalKey();
  final GlobalKey aroundMeKey = GlobalKey();
  final GlobalKey filtersKey = GlobalKey();

  @override
  State<MainTravelersPage> createState() => _MainTravelersPageState();
}

class _MainTravelersPageState extends State<MainTravelersPage>
    with BlocProvider<MainTravelersPage, MainTravelersPageBloc> {
  @override
  initBloc() => MainTravelersPageBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EpTabbedTravelersPage.bottomBar(
        pageController: bloc.pageController,
        initialPage: widget.initialPage,
        pages: [
          EpTabbedTravelersPageItem(Icons.backpack, MatchingPage(favorKey: widget.favorKey, percentKey: widget.percentKey, searchCityKey: widget.searchCityKey, aroundMeKey: widget.aroundMeKey, filtersKey: widget.filtersKey)),
          const EpTabbedTravelersPageItem(Icons.favorite_border, FavorisPage()),
          EpTabbedTravelersPageItem(FontAwesomeIcons.envelope, const MessagesTravelersPage(),
                  (context, child) {
                return ValueStreamBuilder<bool>(
                  stream: bloc.hasUnreadMessages,
                  builder: (context, snapshot) {
                    final hasUnreadMessages = snapshot.data!;
                    return _UnreadBadge(
                      showBadge: hasUnreadMessages,
                      child: child,
                    );
                  },
                );
              }),
          const EpTabbedTravelersPageItem(FontAwesomeIcons.airplay, ProfileTravelersPage()),
        ],
      ),
    );
  }
}

class _EpRootAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _EpRootAppBar({
    Key? key,
    required this.onPageChanged,
    required this.pageController,
  }) : super(key: key);
  final ValueChanged<int> onPageChanged;
  final StreamController<int> pageController;
  static const size = Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
      ),
    );
  }

  @override
  Size get preferredSize => size;
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({Key? key, this.showBadge = true, required this.child})
      : super(key: key);

  final bool showBadge;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (showBadge)
          const Positioned(
            top: 10,
            right: 8,
            child: EpThickDot(),
          ),
      ],
    );
  }
}

class MainTravelersPageBloc with Disposable {
  static MainTravelersPageBloc? instance;

  MainTravelersPageBloc() {
    // Store instance in static
    instance = this;

    // Init notifications
    //AppService.instance.initFirebaseMessaging();
  }
  StreamController<int> pageController = StreamController<int>.broadcast();
  final hasUnreadMessages = BehaviorSubject.seeded(false);

  void setPage(int index) {
    pageController.sink.add(index);
  }

  @override
  void dispose() {
    if (instance == this) instance = null;
    hasUnreadMessages.close();
    pageController.close();
    super.dispose();
  }
}
