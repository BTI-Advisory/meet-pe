import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
    topLeft: Radius.circular(25),
    topRight: Radius.circular(25),
  ));
  SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.pinned;
  EdgeInsets padding = EdgeInsets.zero;
  SnakeShape snakeShape = SnakeShape.circle;
  Color selectedColor = AppResources.colorBeige;
  Color unselectedColor = AppResources.colorDark;
  bool showSelectedLabels = true;
  bool showUnselectedLabels = true;
  int _selectedItemPosition = 2;

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
        body: widget.pages[_index].page,
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(185, 185, 184, 0.10),
                offset: Offset(0, -1),
                blurRadius: 2,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Color.fromRGBO(185, 185, 184, 0.09),
                offset: Offset(0, -4),
                blurRadius: 4,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Color.fromRGBO(185, 185, 184, 0.05),
                offset: Offset(0, -9),
                blurRadius: 6,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Color.fromRGBO(185, 185, 184, 0.01),
                offset: Offset(0, -17),
                blurRadius: 7,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Color.fromRGBO(185, 185, 184, 0.00),
                offset: Offset(0, -26),
                blurRadius: 7,
                spreadRadius: 0,
              ),
            ],
          ),
          child: SnakeNavigationBar.color(
            height: 72,
            behaviour: snakeBarStyle,
            snakeShape: snakeShape,
            shape: bottomBarShape,
            padding: padding,

            ///configuration for SnakeNavigationBar.color
            snakeViewColor: selectedColor,
            selectedItemColor:
                snakeShape == SnakeShape.indicator ? selectedColor : null,
            unselectedItemColor: unselectedColor,

            ///configuration for SnakeNavigationBar.gradient
            // snakeViewGradient: selectedGradient,
            // selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
            // unselectedItemGradient: unselectedGradient,

            showUnselectedLabels: showUnselectedLabels,
            showSelectedLabels: showSelectedLabels,

            items: [
              /*BottomNavigationBarItem(
                  icon: Icon(Icons.backpack), label: 'Expériences'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.message), label: 'Messages'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil')*/
              BottomNavigationBarItem(
                  icon: ColorFiltered(
                    colorFilter: _index == 0
                        ? const ColorFilter.mode(
                            AppResources.colorVitamine, BlendMode.srcIn)
                        : const ColorFilter.mode(
                            AppResources.colorGray90, BlendMode.srcIn),
                    child: SvgPicture.asset('images/bag_svg.svg'),
                  ),
                  label: 'Expériences'),
              BottomNavigationBarItem(
                  icon: ColorFiltered(
                    colorFilter: _index == 1
                        ? const ColorFilter.mode(
                            AppResources.colorVitamine, BlendMode.srcIn)
                        : const ColorFilter.mode(
                            AppResources.colorGray90, BlendMode.srcIn),
                    child: SvgPicture.asset('images/message_svg.svg'),
                  ),
                  label: 'Messages'),
              BottomNavigationBarItem(
                  icon: ColorFiltered(
                    colorFilter: _index == 2
                        ? const ColorFilter.mode(
                            AppResources.colorVitamine, BlendMode.srcIn)
                        : const ColorFilter.mode(
                            AppResources.colorGray90, BlendMode.srcIn),
                    child: SvgPicture.asset('images/user_svg.svg'),
                  ),
                  label: 'Profil')
            ],
            currentIndex: _index,
            onTap: setIndex,
            //items: widget.pages,
            selectedLabelStyle: const TextStyle(fontSize: 14),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
          ),
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
