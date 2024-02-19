import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meet_pe/screens/guideProfilPages/experiences_guide_page.dart';
import 'package:meet_pe/screens/guideProfilPages/profil_guide_page.dart';
import 'package:rxdart/rxdart.dart';

import '../../resources/icons/font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/abstracts/bloc_provider.dart';
import '../../utils/abstracts/disposable.dart';
import '../../widgets/_widgets.dart';
import 'messages_guide_page.dart';

class MainGuidePage extends StatefulWidget {
  const MainGuidePage({Key? key}) : super(key: key);

  @override
  State<MainGuidePage> createState() => _MainGuidePageState();
}

class _MainGuidePageState extends State<MainGuidePage>
    with BlocProvider<MainGuidePage, MainGuidePageBloc> {
  @override
  initBloc() => MainGuidePageBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EpTabbedPage.bottomBar(
        pageController: bloc.pageController,
        initialPage: 2,
        pages: [
          const EpTabbedPageItem(Icons.backpack, ExperiencesGuidePage()),
          EpTabbedPageItem(FontAwesomeIcons.envelope, const MessagesGuidePage(),
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
          const EpTabbedPageItem(FontAwesomeIcons.airplay, ProfileGuidePage()),
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

class MainGuidePageBloc with Disposable {
  static MainGuidePageBloc? instance;

  MainGuidePageBloc() {
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
