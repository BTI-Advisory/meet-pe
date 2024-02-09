import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meet_pe/utils/_utils.dart';

import '../../resources/icons/font_awesome_flutter/fa_icon.dart';
import '../../resources/resources.dart';

class EpTabbedPage extends StatefulWidget {
  const EpTabbedPage.bottomBar({
    Key? key,
    this.initialPage = 0,
    required this.pages,
    required this.pageController,
  }) : super(key: key);

  final int initialPage;
  final List<EpTabbedPageItem> pages;
  final StreamController<int> pageController;

  @override
  State<EpTabbedPage> createState() => _EpTabbedPageState();
}

class _EpTabbedPageState extends State<EpTabbedPage> {
  late int _index;
  late StreamSubscription<int> _streamSubscription;

  @override
  void initState() {
    super.initState();
    _index = widget.initialPage;
    _streamSubscription = widget.pageController.stream.listen(setIndex);
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  void setIndex(int index) {
    if (index == _index) return;
    widget.pageController.add(index);
    context.clearFocus2(); // basic clearFocus() doesn't work here.
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_index == 0) {
          return true;
        } else {
          setIndex(0);
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: widget.pages[_index].page,
        bottomNavigationBar: _EpBottomNavigationBar(
          currentIndex: _index,
          onTap: setIndex,
          items: widget.pages,
        ),
      ),
    );
  }
}

class _EpBottomNavigationBar extends StatelessWidget {
  const _EpBottomNavigationBar(
      {Key? key,
        required this.currentIndex,
        required this.onTap,
        required this.items})
      : super(key: key);

  final int currentIndex;
  final ValueChanged<int> onTap;
  final Iterable<_EpBottomNavigationBarItem> items;

  @override
  Widget build(BuildContext context) {
    final barTheme = BottomNavigationBarTheme.of(context);
    final additionalBottomPadding = MediaQuery.of(context).padding.bottom;

    return ConstrainedBox(
      constraints: BoxConstraints(
          minHeight: kBottomNavigationBarHeight + additionalBottomPadding),
      child: Material(
        // Splashes.
        color: barTheme.backgroundColor,
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: additionalBottomPadding,
            left: AppResources.paddingContent.left,
            right: AppResources.paddingContent.right,
          ),
          child: MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: items
                  .where((item) => item.icon != null)
                  .mapIndexed((index, item) {
                final isSelected = index == currentIndex;
                final child = IconButton(
                  onPressed: isSelected ? null : () => onTap(index),
                  icon: FaIcon(
                    item.icon,
                    color: isSelected
                        ? barTheme.selectedItemColor
                        : barTheme.unselectedItemColor,
                    size: 26,
                  ),
                );
                if (item.builder == null) return child;
                return item.builder!(context, child);
              }).toList(growable: false),
            ),
          ),
        ),
      ),
    );
  }
}

class _EpBottomNavigationBarItem {
  const _EpBottomNavigationBarItem(this.icon, this.builder);

  final IconData? icon;
  final ToolbarBuilder? builder;
}

class EpTabbedPageItem extends _EpBottomNavigationBarItem {
  const EpTabbedPageItem(super.icon, this.page, [super.builder]);

  final Widget page;
}
