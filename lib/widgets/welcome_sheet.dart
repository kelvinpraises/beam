import 'package:flutter/material.dart';

import 'welcome_sheet_items.dart';

// void main() => runApp(const WelcomeSheet());

class WelcomeSheet extends StatefulWidget {
  const WelcomeSheet({super.key});

  @override
  State<WelcomeSheet> createState() => _WelcomeSheetState();
}

class _WelcomeSheetState extends State<WelcomeSheet>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _showOutgoingAnimation =
      false; // Flag to control visibility of initial outgoing
  bool _seenWelcomeSheet = false; // Flag to control visibility of WelcomeSheet

  final GlobalKey comingKey = GlobalKey();
  static const double _cardItemsPadding = 8;
  static const double _cardItemsWidth = 400;
  late double _childHeight;
  late double _childWidth;

  late AnimationController _controller;
  late Animation<double> _outgoingOpacityAnimation;
  late Animation<double> _incomingOpacityAnimation;
  late AnimationController _closeController;
  late Animation<double> _backgroundOpacityAnimation;
  late Animation<Offset> _containerTranslationAnimation;

  @override
  void initState() {
    super.initState();

    _childHeight = 0;
    _childWidth = 40;
    _showOutgoingAnimation = false;
    _seenWelcomeSheet = false;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();

    _incomingOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );

    _outgoingOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _closeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _backgroundOpacityAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _closeController,
      curve: Curves.easeInOut,
    ));

    _containerTranslationAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, 1.0)).animate(
      CurvedAnimation(
        parent: _closeController,
        curve: Curves.easeInOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIncomingHeight().then(
        (value) {
          setState(() {
            _childHeight = value;
          });
        },
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _closeController.dispose();
    super.dispose();
  }

  Future<double> getIncomingHeight() async {
    final RenderBox renderBox =
        comingKey.currentContext?.findRenderObject() as RenderBox;
    return renderBox.getMinIntrinsicHeight(_childWidth);
  }

  void nextCard() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % welcomeWidgets.length;
      _controller.forward(from: 0.0);
      _showOutgoingAnimation =
          true; // Set the flag to true after the first transition
    });
  }

  void closeCards() {
    _closeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _seenWelcomeSheet = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _seenWelcomeSheet
        ? const SizedBox.shrink()
        : Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              FadeTransition(
                opacity: _backgroundOpacityAnimation,
                child: Container(
                  width: 2160,
                  height: double.infinity,
                  color: Colors.black26,
                ),
              ),
              SlideTransition(
                position: _containerTranslationAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: 2160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            children: [
                              LayoutBuilder(
                                builder: (_, constraints) {
                                  // TODO: Fix and remove hack.
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    getIncomingHeight().then(
                                      (value) {
                                        setState(() {
                                          _childHeight = value;

                                          // Account for padding that takes the width of the container being monitored.
                                          _childWidth = constraints.maxWidth >=
                                                  _cardItemsWidth
                                              ? _cardItemsWidth -
                                                  _cardItemsPadding * 2
                                              : constraints.maxWidth -
                                                  _cardItemsPadding * 2;
                                        });
                                      },
                                    );
                                  });

                                  return AnimatedContainer(
                                    height: _childHeight,
                                    duration: const Duration(milliseconds: 350),
                                    curve: Curves.fastOutSlowIn,
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                          maxWidth: _cardItemsWidth),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: _cardItemsPadding,
                                        ),
                                        child: FadeTransition(
                                          opacity: _incomingOpacityAnimation,
                                          child: MediaQuery.removePadding(
                                            context: context,
                                            removeTop: true,
                                            child: ListView(
                                              children: [
                                                welcomeWidgets[_currentIndex](
                                                  incomingKey: comingKey,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child:
                                    _showOutgoingAnimation // Only show if the flag is true
                                        ? ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                maxWidth: _cardItemsWidth),
                                            child: SizedBox(
                                              height: 2000,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: _cardItemsPadding,
                                                ),
                                                child: FadeTransition(
                                                  opacity:
                                                      _outgoingOpacityAnimation,
                                                  child: ListView(
                                                    children: [
                                                      welcomeWidgets[
                                                          (_currentIndex - 1) %
                                                              welcomeWidgets
                                                                  .length]()
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox
                                            .shrink(), // Show a shrink SizedBox if the flag is false
                              ),
                            ],
                          ),
                          // Text(_childHeight.toString()),
                          const SizedBox(height: 16),
                          // Buttons
                          ConstrainedBox(
                            constraints:
                                const BoxConstraints(maxWidth: _cardItemsWidth),
                            child: welcomeWidgetsButtons[_currentIndex](
                              nextCard: nextCard,
                              closeCards: closeCards,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
