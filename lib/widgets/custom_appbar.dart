// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Standard iOS navigation bar height without the status bar.
///
/// This height is constant and independent of accessibility as it is in iOS.
const double _kNavBarPersistentHeight = kMinInteractiveDimensionCupertino;

/// Size increase from expanding the navigation bar into an iOS-11-style large title
/// form in a [CustomScrollView].
const double _kNavBarLargeTitleHeightExtension = 52.0;

/// Number of logical pixels scrolled down before the title text is transferred
/// from the normal navigation bar to a big title below the navigation bar.
const double _kNavBarShowLargeTitleThreshold = 10.0;

const double _kNavBarEdgePadding = 16.0;

const double _kNavBarBottomPadding = 8.0;

const double _kNavBarBackButtonTapWidth = 50.0;

/// Title text transfer fade.
const Duration _kNavBarTitleFadeDuration = Duration(milliseconds: 150);

const Color _kDefaultNavBarBorderColor = Color(0x4D000000);

const Border _kDefaultNavBarBorder = Border(
  bottom: BorderSide(
    color: _kDefaultNavBarBorderColor,
    width: 0.0, // 0.0 means one physical pixel
  ),
);

// There's a single tag for all instances of navigation bars because they can
// all transition between each other (per Navigator) via Hero transitions.
const _HeroTag _defaultHeroTag = _HeroTag(null);

@immutable
class _HeroTag {
  const _HeroTag(this.navigator);

  final NavigatorState? navigator;

  // Let the Hero tag be described in tree dumps.
  @override
  String toString() => 'Default Hero tag for Cupertino navigation bars with navigator $navigator';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _HeroTag && other.navigator == navigator;
  }

  @override
  int get hashCode => identityHashCode(navigator);
}

// An `AnimatedWidget` that imposes a fixed size on its child widget, and
// shifts the child widget in the parent stack, driven by its `offsetAnimation`
// property.
class _FixedSizeSlidingTransition extends AnimatedWidget {
  const _FixedSizeSlidingTransition({
    required this.isLTR,
    required this.offsetAnimation,
    required this.size,
    required this.child,
  }) : super(listenable: offsetAnimation);

  // Whether the writing direction used in the navigation bar transition is
  // left-to-right.
  final bool isLTR;

  // The fixed size to impose on `child`.
  final Size size;

  final Animation<Offset> offsetAnimation;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: offsetAnimation.value.dy,
      left: isLTR ? offsetAnimation.value.dx : null,
      right: isLTR ? null : offsetAnimation.value.dx,
      width: size.width,
      height: size.height,
      child: child,
    );
  }
}

/// Returns `child` wrapped with background and a bottom border if background color
/// is opaque. Otherwise, also blur with [BackdropFilter].
///
/// When `updateSystemUiOverlay` is true, the nav bar will update the OS
/// status bar's color theme based on the background color of the nav bar.
///
SystemUiOverlayStyle _findBrigthness(Brightness newBrightness) {
  switch (newBrightness) {
    case Brightness.dark:
      return SystemUiOverlayStyle.light;
    case Brightness.light:
      return SystemUiOverlayStyle.dark;
  }
}

Widget _wrapWithBackground({
  Border? border,
  required Color backgroundColor,
  Brightness? brightness,
  required Widget child,
  bool updateSystemUiOverlay = true,
}) {
  Widget result = child;
  if (updateSystemUiOverlay) {
    final bool isDark = backgroundColor.computeLuminance() < 0.179;
    final Brightness newBrightness = brightness ?? (isDark ? Brightness.dark : Brightness.light);
    final SystemUiOverlayStyle overlayStyle = _findBrigthness(newBrightness);
    log('overlayStyle.statusBarColor :${overlayStyle.statusBarColor}');
    log(' overlayStyle.statusBarBrightness :${ overlayStyle.statusBarBrightness}');
    log('overlayStyle.statusBarIconBrightness :${overlayStyle.statusBarIconBrightness}');
    log('overlayStyle.statusBarIconBrightness :${overlayStyle.statusBarIconBrightness}');
    log('overlayStyle.systemStatusBarContrastEnforced :${overlayStyle.systemStatusBarContrastEnforced}');
    // [SystemUiOverlayStyle.light] and [SystemUiOverlayStyle.dark] set some system
    // navigation bar properties,
    // Before https://github.com/flutter/flutter/pull/104827 those properties
    // had no effect, now they are used if there is no AnnotatedRegion on the
    // bottom of the screen.
    // For backward compatibility, create a `SystemUiOverlayStyle` without the
    // system navigation bar properties.
    result = AnnotatedRegion<SystemUiOverlayStyle>(
      value:SystemUiOverlayStyle(
        statusBarColor:backgroundColor, //overlayStyle.statusBarColor,
        statusBarBrightness: overlayStyle.statusBarBrightness,
        statusBarIconBrightness: overlayStyle.statusBarIconBrightness,
        systemStatusBarContrastEnforced: overlayStyle.systemStatusBarContrastEnforced,
      ),
      child: result,
    );
  }
  final DecoratedBox childWithBackground = DecoratedBox(
    decoration: BoxDecoration(
      border: border,
      color: backgroundColor,
    ),
    child: result,
  );

  if (backgroundColor.alpha == 0xFF) {
    return childWithBackground;
  }

  return ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: childWithBackground,
    ),
  );
}

// Whether the current route supports nav bar hero transitions from or to.
bool _isTransitionable(BuildContext context) {
  final ModalRoute<dynamic>? route = ModalRoute.of(context);

  return route is PageRoute && !route.fullscreenDialog;
}

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight) : super.fromHeight((toolbarHeight ?? _kNavBarPersistentHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}

class FlutterCupertinoAppBarWithTabBar extends StatefulWidget implements ObstructingPreferredSizeWidget {
  /// Creates a navigation bar in the iOS style.
  FlutterCupertinoAppBarWithTabBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.automaticallyImplyMiddle = true,
    this.previousPageTitle,
    this.middle,
    this.trailing,
    this.bottom,
    this.border = _kDefaultNavBarBorder,
    this.backgroundColor,
    this.brightness,
    this.padding,
    this.transitionBetweenRoutes = true,
    this.heroTag = _defaultHeroTag,
  }) : preferredSize = _PreferredAppBarSize(_kNavBarPersistentHeight, bottom?.preferredSize.height) {
    assert(
      !transitionBetweenRoutes || identical(heroTag, _defaultHeroTag),
      'Cannot specify a heroTag override if this navigation bar does not '
      'transition due to transitionBetweenRoutes = false.',
    );
  }

  final Widget? leading;

  final bool automaticallyImplyLeading;

  final bool automaticallyImplyMiddle;

  final String? previousPageTitle;

  final Widget? middle;

  final Widget? trailing;
  final PreferredSizeWidget? bottom;

  final Color? backgroundColor;

  final Brightness? brightness;

  final EdgeInsetsDirectional? padding;

  final Border? border;

  final bool transitionBetweenRoutes;

  final Object heroTag;

  /// True if the navigation bar's background color has no transparency.
  @override
  bool shouldFullyObstruct(BuildContext context) {
    final Color backgroundColor = CupertinoDynamicColor.maybeResolve(this.backgroundColor, context) ?? CupertinoTheme.of(context).barBackgroundColor;
    return backgroundColor.alpha == 0xFF;
  }

  @override
  // Size get preferredSize {
  //   return const Size.fromHeight(_kNavBarPersistentHeight);
  // }
  final Size preferredSize;

  @override
  State<FlutterCupertinoAppBarWithTabBar> createState() => _FlutterCupertinoAppBarWithTabBarState();
}

// A state class exists for the nav bar so that the keys of its sub-components
// don't change when rebuilding the nav bar, causing the sub-components to
// lose their own states.
class _FlutterCupertinoAppBarWithTabBarState extends State<FlutterCupertinoAppBarWithTabBar> {
  late _NavigationBarStaticComponentsKeys keys;

  @override
  void initState() {
    super.initState();
    keys = _NavigationBarStaticComponentsKeys();
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = CupertinoDynamicColor.maybeResolve(widget.backgroundColor, context) ?? CupertinoTheme.of(context).barBackgroundColor;
    final _NavigationBarStaticComponents components = _NavigationBarStaticComponents(
      keys: keys,
      route: ModalRoute.of(context),
      userLeading: widget.leading,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      automaticallyImplyTitle: widget.automaticallyImplyMiddle,
      previousPageTitle: widget.previousPageTitle,
      userMiddle: widget.middle,
      userTrailing: widget.trailing,
      padding: widget.padding,
      userLargeTitle: null,
      large: false,
    );
    

    final Widget navBar = _wrapWithBackground(
      border: widget.border,
      backgroundColor: backgroundColor,
      brightness: widget.brightness,
      child: DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle,
        child: _PersistentNavigationBar(
          components: components,
          padding: widget.padding,
        ),
      ),
    );

    if (!widget.transitionBetweenRoutes || !_isTransitionable(context)) {
      // Lint ignore to maintain backward compatibility.
      return navBar;
    }
    if (widget.bottom != null) {
      return Builder(
          // Get the context that might have a possibly changed CupertinoTheme.
          builder: (BuildContext context) {
            return Hero(
              tag: widget.heroTag == _defaultHeroTag ? _HeroTag(Navigator.of(context)) : widget.heroTag,
              createRectTween: _linearTranslateWithLargestRectSizeTween,
              placeholderBuilder: _navBarHeroLaunchPadBuilder,
              flightShuttleBuilder: _navBarHeroFlightShuttleBuilder,
              transitionOnUserGestures: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TransitionableNavigationBar(
                    componentsKeys: keys,
                    backgroundColor: backgroundColor,
                    backButtonTextStyle: CupertinoTheme.of(context).textTheme.navActionTextStyle,
                    titleTextStyle: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                    largeTitleTextStyle: null,
                    border: widget.border,
                    hasUserMiddle: widget.middle != null,
                    largeExpanded: false,
                    child: navBar,
                  ),
                  widget.bottom!
                ],
              ),
            );
          },
      );
    }

    return Builder(
      // Get the context that might have a possibly changed CupertinoTheme.
      builder: (BuildContext context) {
        return Hero(
          tag: widget.heroTag == _defaultHeroTag ? _HeroTag(Navigator.of(context)) : widget.heroTag,
          createRectTween: _linearTranslateWithLargestRectSizeTween,
          placeholderBuilder: _navBarHeroLaunchPadBuilder,
          flightShuttleBuilder: _navBarHeroFlightShuttleBuilder,
          transitionOnUserGestures: true,
          child: _TransitionableNavigationBar(
            componentsKeys: keys,
            backgroundColor: backgroundColor,
            backButtonTextStyle: CupertinoTheme.of(context).textTheme.navActionTextStyle,
            titleTextStyle: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
            largeTitleTextStyle: null,
            border: widget.border,
            hasUserMiddle: widget.middle != null,
            largeExpanded: false,
            child: navBar,
          ),
        );
      },
    );
  }
}

class _PersistentNavigationBar extends StatelessWidget {
  const _PersistentNavigationBar({
    required this.components,
    this.padding,
    this.middleVisible,
  });

  final _NavigationBarStaticComponents components;

  final EdgeInsetsDirectional? padding;

  /// Whether the middle widget has a visible animated opacity. A null value
  /// means the middle opacity will not be animated.
  final bool? middleVisible;

  @override
  Widget build(BuildContext context) {
    Widget? middle = components.middle;

    if (middle != null) {
      middle = DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
        child: Semantics(header: true, child: middle),
      );
      // When the middle's visibility can change on the fly like with large title
      // slivers, wrap with animated opacity.
      middle = middleVisible == null
          ? middle
          : AnimatedOpacity(
              opacity: middleVisible! ? 1.0 : 0.0,
              duration: _kNavBarTitleFadeDuration,
              child: middle,
            );
    }

    Widget? leading = components.leading;
    final Widget? backChevron = components.backChevron;
    final Widget? backLabel = components.backLabel;

    if (leading == null && backChevron != null && backLabel != null) {
      leading = CupertinoNavigationBarBackButton._assemble(
        backChevron,
        backLabel,
      );
    }

    Widget paddedToolbar = NavigationToolbar(
      leading: leading,
      middle: middle,
      trailing: components.trailing,
      middleSpacing: 6.0,
    );

    if (padding != null) {
      paddedToolbar = Padding(
        padding: EdgeInsets.only(
          top: padding!.top,
          bottom: padding!.bottom,
        ),
        child: paddedToolbar,
      );
    }

    return SizedBox(
      height: _kNavBarPersistentHeight + MediaQuery.paddingOf(context).top,
      child: SafeArea(
        bottom: false,
        child: paddedToolbar,
      ),
    );
  }
}

// A collection of keys always used when building static routes' nav bars's
// components with _NavigationBarStaticComponents and read in
// _NavigationBarTransition in Hero flights in order to reference the components'
// RenderBoxes for their positions.
//
// These keys should never re-appear inside the Hero flights.
@immutable
class _NavigationBarStaticComponentsKeys {
  _NavigationBarStaticComponentsKeys()
      : navBarBoxKey = GlobalKey(debugLabel: 'Navigation bar render box'),
        leadingKey = GlobalKey(debugLabel: 'Leading'),
        backChevronKey = GlobalKey(debugLabel: 'Back chevron'),
        backLabelKey = GlobalKey(debugLabel: 'Back label'),
        middleKey = GlobalKey(debugLabel: 'Middle'),
        trailingKey = GlobalKey(debugLabel: 'Trailing'),
        largeTitleKey = GlobalKey(debugLabel: 'Large title');

  final GlobalKey navBarBoxKey;
  final GlobalKey leadingKey;
  final GlobalKey backChevronKey;
  final GlobalKey backLabelKey;
  final GlobalKey middleKey;
  final GlobalKey trailingKey;
  final GlobalKey largeTitleKey;
}

// Based on various user Widgets and other parameters, construct KeyedSubtree
// components that are used in common by the CupertinoNavigationBar and
// CupertinoSliverNavigationBar. The KeyedSubtrees are inserted into static
// routes and the KeyedSubtrees' child are reused in the Hero flights.
@immutable
class _NavigationBarStaticComponents {
  _NavigationBarStaticComponents({
    required _NavigationBarStaticComponentsKeys keys,
    required ModalRoute<dynamic>? route,
    required Widget? userLeading,
    required bool automaticallyImplyLeading,
    required bool automaticallyImplyTitle,
    required String? previousPageTitle,
    required Widget? userMiddle,
    required Widget? userTrailing,
    required Widget? userLargeTitle,
    required EdgeInsetsDirectional? padding,
    required bool large,
  })  : leading = createLeading(
          leadingKey: keys.leadingKey,
          userLeading: userLeading,
          route: route,
          automaticallyImplyLeading: automaticallyImplyLeading,
          padding: padding,
        ),
        backChevron = createBackChevron(
          backChevronKey: keys.backChevronKey,
          userLeading: userLeading,
          route: route,
          automaticallyImplyLeading: automaticallyImplyLeading,
        ),
        backLabel = createBackLabel(
          backLabelKey: keys.backLabelKey,
          userLeading: userLeading,
          route: route,
          previousPageTitle: previousPageTitle,
          automaticallyImplyLeading: automaticallyImplyLeading,
        ),
        middle = createMiddle(
          middleKey: keys.middleKey,
          userMiddle: userMiddle,
          userLargeTitle: userLargeTitle,
          route: route,
          automaticallyImplyTitle: automaticallyImplyTitle,
          large: large,
        ),
        trailing = createTrailing(
          trailingKey: keys.trailingKey,
          userTrailing: userTrailing,
          padding: padding,
        ),
        largeTitle = createLargeTitle(
          largeTitleKey: keys.largeTitleKey,
          userLargeTitle: userLargeTitle,
          route: route,
          automaticImplyTitle: automaticallyImplyTitle,
          large: large,
        );

  static Widget? _derivedTitle({
    required bool automaticallyImplyTitle,
    ModalRoute<dynamic>? currentRoute,
  }) {
    // Auto use the CupertinoPageRoute's title if middle not provided.
    if (automaticallyImplyTitle && currentRoute is CupertinoRouteTransitionMixin && currentRoute.title != null) {
      return Text(currentRoute.title!);
    }

    return null;
  }

  final KeyedSubtree? leading;
  static KeyedSubtree? createLeading({
    required GlobalKey leadingKey,
    required Widget? userLeading,
    required ModalRoute<dynamic>? route,
    required bool automaticallyImplyLeading,
    required EdgeInsetsDirectional? padding,
  }) {
    Widget? leadingContent;

    if (userLeading != null) {
      leadingContent = userLeading;
    } else if (automaticallyImplyLeading && route is PageRoute && route.canPop && route.fullscreenDialog) {
      leadingContent = CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          route.navigator!.maybePop();
        },
        child: const Text('Close'),
      );
    }

    if (leadingContent == null) {
      return null;
    }

    return KeyedSubtree(
      key: leadingKey,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: padding?.start ?? _kNavBarEdgePadding,
        ),
        child: IconTheme.merge(
          data: const IconThemeData(
            size: 32.0,
          ),
          child: leadingContent,
        ),
      ),
    );
  }

  final KeyedSubtree? backChevron;
  static KeyedSubtree? createBackChevron({
    required GlobalKey backChevronKey,
    required Widget? userLeading,
    required ModalRoute<dynamic>? route,
    required bool automaticallyImplyLeading,
  }) {
    if (userLeading != null || !automaticallyImplyLeading || route == null || !route.canPop || (route is PageRoute && route.fullscreenDialog)) {
      return null;
    }

    return KeyedSubtree(key: backChevronKey, child: const _BackChevron());
  }

  /// This widget is not decorated with a font since the font style could
  /// animate during transitions.
  final KeyedSubtree? backLabel;
  static KeyedSubtree? createBackLabel({
    required GlobalKey backLabelKey,
    required Widget? userLeading,
    required ModalRoute<dynamic>? route,
    required bool automaticallyImplyLeading,
    required String? previousPageTitle,
  }) {
    if (userLeading != null || !automaticallyImplyLeading || route == null || !route.canPop || (route is PageRoute && route.fullscreenDialog)) {
      return null;
    }

    return KeyedSubtree(
      key: backLabelKey,
      child: _BackLabel(
        specifiedPreviousTitle: previousPageTitle,
        route: route,
      ),
    );
  }

  /// This widget is not decorated with a font since the font style could
  /// animate during transitions.
  final KeyedSubtree? middle;
  static KeyedSubtree? createMiddle({
    required GlobalKey middleKey,
    required Widget? userMiddle,
    required Widget? userLargeTitle,
    required bool large,
    required bool automaticallyImplyTitle,
    required ModalRoute<dynamic>? route,
  }) {
    Widget? middleContent = userMiddle;

    if (large) {
      middleContent ??= userLargeTitle;
    }

    middleContent ??= _derivedTitle(
      automaticallyImplyTitle: automaticallyImplyTitle,
      currentRoute: route,
    );

    if (middleContent == null) {
      return null;
    }

    return KeyedSubtree(
      key: middleKey,
      child: middleContent,
    );
  }

  final KeyedSubtree? trailing;
  static KeyedSubtree? createTrailing({
    required GlobalKey trailingKey,
    required Widget? userTrailing,
    required EdgeInsetsDirectional? padding,
  }) {
    if (userTrailing == null) {
      return null;
    }

    return KeyedSubtree(
      key: trailingKey,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          end: padding?.end ?? _kNavBarEdgePadding,
        ),
        child: IconTheme.merge(
          data: const IconThemeData(
            size: 32.0,
          ),
          child: userTrailing,
        ),
      ),
    );
  }

  /// This widget is not decorated with a font since the font style could
  /// animate during transitions.
  final KeyedSubtree? largeTitle;
  static KeyedSubtree? createLargeTitle({
    required GlobalKey largeTitleKey,
    required Widget? userLargeTitle,
    required bool large,
    required bool automaticImplyTitle,
    required ModalRoute<dynamic>? route,
  }) {
    if (!large) {
      return null;
    }

    final Widget? largeTitleContent = userLargeTitle ??
        _derivedTitle(
          automaticallyImplyTitle: automaticImplyTitle,
          currentRoute: route,
        );

    assert(
      largeTitleContent != null,
      'largeTitle was not provided and there was no title from the route.',
    );

    return KeyedSubtree(
      key: largeTitleKey,
      child: largeTitleContent!,
    );
  }
}

/// A nav bar back button typically used in [CupertinoNavigationBar].
///
/// This is automatically inserted into [CupertinoNavigationBar] and
/// [CupertinoSliverNavigationBar]'s `leading` slot when
/// `automaticallyImplyLeading` is true.
///
/// When manually inserted, the [CupertinoNavigationBarBackButton] should only
/// be used in routes that can be popped unless a custom [onPressed] is
/// provided.
///
/// Shows a back chevron and the previous route's title when available from
/// the previous [CupertinoPageRoute.title]. If [previousPageTitle] is specified,
/// it will be shown instead.
class CupertinoNavigationBarBackButton extends StatelessWidget {
  /// Construct a [CupertinoNavigationBarBackButton] that can be used to pop
  /// the current route.
  const CupertinoNavigationBarBackButton({
    super.key,
    this.color,
    this.previousPageTitle,
    this.onPressed,
  })  : _backChevron = null,
        _backLabel = null;

  // Allow the back chevron and label to be separately created (and keyed)
  // because they animate separately during page transitions.
  const CupertinoNavigationBarBackButton._assemble(
    this._backChevron,
    this._backLabel,
  )   : previousPageTitle = null,
        color = null,
        onPressed = null;

  /// The [Color] of the back button.
  ///
  /// Can be used to override the color of the back button chevron and label.
  ///
  /// Defaults to [CupertinoTheme]'s `primaryColor` if null.
  final Color? color;

  /// An override for showing the previous route's title. If null, it will be
  /// automatically derived from [CupertinoPageRoute.title] if the current and
  /// previous routes are both [CupertinoPageRoute]s.
  final String? previousPageTitle;

  /// An override callback to perform instead of the default behavior which is
  /// to pop the [Navigator].
  ///
  /// It can, for instance, be used to pop the platform's navigation stack
  /// via [SystemNavigator] instead of Flutter's [Navigator] in add-to-app
  /// situations.
  ///
  /// Defaults to null.
  final VoidCallback? onPressed;

  final Widget? _backChevron;

  final Widget? _backLabel;

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic>? currentRoute = ModalRoute.of(context);
    if (onPressed == null) {
      assert(
        currentRoute?.canPop ?? false,
        'CupertinoNavigationBarBackButton should only be used in routes that can be popped',
      );
    }

    TextStyle actionTextStyle = CupertinoTheme.of(context).textTheme.navActionTextStyle;
    if (color != null) {
      actionTextStyle = actionTextStyle.copyWith(color: CupertinoDynamicColor.maybeResolve(color, context));
    }

    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Semantics(
        container: true,
        excludeSemantics: true,
        label: 'Back',
        button: true,
        child: DefaultTextStyle(
          style: actionTextStyle,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: _kNavBarBackButtonTapWidth),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(padding: EdgeInsetsDirectional.only(start: 8.0)),
                _backChevron ?? const _BackChevron(),
                const Padding(padding: EdgeInsetsDirectional.only(start: 6.0)),
                Flexible(
                  child: _backLabel ??
                      _BackLabel(
                        specifiedPreviousTitle: previousPageTitle,
                        route: currentRoute,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.maybePop(context);
        }
      },
    );
  }
}

class _BackChevron extends StatelessWidget {
  const _BackChevron();

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final TextStyle textStyle = DefaultTextStyle.of(context).style;

    // Replicate the Icon logic here to get a tightly sized icon and add
    // custom non-square padding.
    Widget iconWidget = Padding(
      padding: const EdgeInsetsDirectional.only(start: 6, end: 2),
      child: Text.rich(
        TextSpan(
          text: String.fromCharCode(CupertinoIcons.back.codePoint),
          style: TextStyle(
            inherit: false,
            color: textStyle.color,
            fontSize: 30.0,
            fontFamily: CupertinoIcons.back.fontFamily,
            package: CupertinoIcons.back.fontPackage,
          ),
        ),
      ),
    );
    switch (textDirection) {
      case TextDirection.rtl:
        iconWidget = Transform(
          transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
          alignment: Alignment.center,
          transformHitTests: false,
          child: iconWidget,
        );
        break;
      case TextDirection.ltr:
        break;
    }

    return iconWidget;
  }
}

/// A widget that shows next to the back chevron when `automaticallyImplyLeading`
/// is true.
class _BackLabel extends StatelessWidget {
  const _BackLabel({
    required this.specifiedPreviousTitle,
    required this.route,
  });

  final String? specifiedPreviousTitle;
  final ModalRoute<dynamic>? route;

  // `child` is never passed in into ValueListenableBuilder so it's always
  // null here and unused.
  Widget _buildPreviousTitleWidget(BuildContext context, String? previousTitle, Widget? child) {
    if (previousTitle == null) {
      return const SizedBox.shrink();
    }

    Text textWidget = Text(
      previousTitle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    if (previousTitle.length > 12) {
      textWidget = const Text('Back');
    }

    return Align(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: 1.0,
      child: textWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (specifiedPreviousTitle != null) {
      return _buildPreviousTitleWidget(context, specifiedPreviousTitle, null);
    } else if (route is CupertinoRouteTransitionMixin<dynamic> && !route!.isFirst) {
      final CupertinoRouteTransitionMixin<dynamic> cupertinoRoute = route! as CupertinoRouteTransitionMixin<dynamic>;
      // There is no timing issue because the previousTitle Listenable changes
      // happen during route modifications before the ValueListenableBuilder
      // is built.
      return ValueListenableBuilder<String?>(
        valueListenable: cupertinoRoute.previousTitle,
        builder: _buildPreviousTitleWidget,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

/// This should always be the first child of Hero widgets.
///
/// This class helps each Hero transition obtain the start or end navigation
/// bar's box size and the inner components of the navigation bar that will
/// move around.
///
/// It should be wrapped around the biggest [RenderBox] of the static
/// navigation bar in each route.
class _TransitionableNavigationBar extends StatelessWidget {
  _TransitionableNavigationBar({
    required this.componentsKeys,
    required this.backgroundColor,
    required this.backButtonTextStyle,
    required this.titleTextStyle,
    required this.largeTitleTextStyle,
    required this.border,
    required this.hasUserMiddle,
    required this.largeExpanded,
    required this.child,
  })  : assert(!largeExpanded || largeTitleTextStyle != null),
        super(key: componentsKeys.navBarBoxKey);

  final _NavigationBarStaticComponentsKeys componentsKeys;
  final Color? backgroundColor;
  final TextStyle backButtonTextStyle;
  final TextStyle titleTextStyle;
  final TextStyle? largeTitleTextStyle;
  final Border? border;
  final bool hasUserMiddle;
  final bool largeExpanded;
  final Widget child;

  RenderBox get renderBox {
    final RenderBox box = componentsKeys.navBarBoxKey.currentContext!.findRenderObject()! as RenderBox;
    assert(
      box.attached,
      '_TransitionableNavigationBar.renderBox should be called when building '
      'hero flight shuttles when the from and the to nav bar boxes are already '
      'laid out and painted.',
    );
    return box;
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      bool inHero = false;
      context.visitAncestorElements((Element ancestor) {
        if (ancestor is ComponentElement) {
          assert(
            ancestor.widget.runtimeType != _NavigationBarTransition,
            '_TransitionableNavigationBar should never re-appear inside '
            '_NavigationBarTransition. Keyed _TransitionableNavigationBar should '
            'only serve as anchor points in routes rather than appearing inside '
            'Hero flights themselves.',
          );
          if (ancestor.widget.runtimeType == Hero) {
            inHero = true;
          }
        }
        return true;
      });
      assert(
        inHero,
        '_TransitionableNavigationBar should only be added as the immediate '
        'child of Hero widgets.',
      );
      return true;
    }());
    return child;
  }
}

/// This class represents the widget that will be in the Hero flight instead of
/// the 2 static navigation bars by taking inner components from both.
///
/// The `topNavBar` parameter is the nav bar that was on top regardless of
/// push/pop direction.
///
/// Similarly, the `bottomNavBar` parameter is the nav bar that was at the
/// bottom regardless of the push/pop direction.
///
/// If [MediaQuery.padding] is still present in this widget's [BuildContext],
/// that padding will become part of the transitional navigation bar as well.
///
/// [MediaQuery.padding] should be consistent between the from/to routes and
/// the Hero overlay. Inconsistent [MediaQuery.padding] will produce undetermined
/// results.
class _NavigationBarTransition extends StatelessWidget {
  _NavigationBarTransition({
    required this.animation,
    required this.topNavBar,
    required this.bottomNavBar,
  })  : heightTween = Tween<double>(
          begin: bottomNavBar.renderBox.size.height,
          end: topNavBar.renderBox.size.height,
        ),
        backgroundTween = ColorTween(
          begin: bottomNavBar.backgroundColor,
          end: topNavBar.backgroundColor,
        ),
        borderTween = BorderTween(
          begin: bottomNavBar.border,
          end: topNavBar.border,
        );

  final Animation<double> animation;
  final _TransitionableNavigationBar topNavBar;
  final _TransitionableNavigationBar bottomNavBar;

  final Tween<double> heightTween;
  final ColorTween backgroundTween;
  final BorderTween borderTween;

  @override
  Widget build(BuildContext context) {
    final _NavigationBarComponentsTransition componentsTransition = _NavigationBarComponentsTransition(
      animation: animation,
      bottomNavBar: bottomNavBar,
      topNavBar: topNavBar,
      directionality: Directionality.of(context),
    );

    final List<Widget> children = <Widget>[
      // Draw an empty navigation bar box with changing shape behind all the
      // moving components without any components inside it itself.
      AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return _wrapWithBackground(
            // Don't update the system status bar color mid-flight.
            updateSystemUiOverlay: false,
            backgroundColor: backgroundTween.evaluate(animation)!,
            border: borderTween.evaluate(animation),
            child: SizedBox(
              height: heightTween.evaluate(animation),
              width: double.infinity,
            ),
          );
        },
      ),
      // Draw all the components on top of the empty bar box.
      if (componentsTransition.bottomBackChevron != null) componentsTransition.bottomBackChevron!,
      if (componentsTransition.bottomBackLabel != null) componentsTransition.bottomBackLabel!,
      if (componentsTransition.bottomLeading != null) componentsTransition.bottomLeading!,
      if (componentsTransition.bottomMiddle != null) componentsTransition.bottomMiddle!,
      if (componentsTransition.bottomLargeTitle != null) componentsTransition.bottomLargeTitle!,
      if (componentsTransition.bottomTrailing != null) componentsTransition.bottomTrailing!,
      // Draw top components on top of the bottom components.
      if (componentsTransition.topLeading != null) componentsTransition.topLeading!,
      if (componentsTransition.topBackChevron != null) componentsTransition.topBackChevron!,
      if (componentsTransition.topBackLabel != null) componentsTransition.topBackLabel!,
      if (componentsTransition.topMiddle != null) componentsTransition.topMiddle!,
      if (componentsTransition.topLargeTitle != null) componentsTransition.topLargeTitle!,
      if (componentsTransition.topTrailing != null) componentsTransition.topTrailing!,
    ];

    // The actual outer box is big enough to contain both the bottom and top
    // navigation bars. It's not a direct Rect lerp because some components
    // can actually be outside the linearly lerp'ed Rect in the middle of
    // the animation, such as the topLargeTitle. The text scaling is disabled to
    // avoid odd transitions between pages.
    return MediaQuery.withNoTextScaling(
      child: SizedBox(
        height: math.max(heightTween.begin!, heightTween.end!) + MediaQuery.paddingOf(context).top,
        width: double.infinity,
        child: Stack(
          children: children,
        ),
      ),
    );
  }
}

/// This class helps create widgets that are in transition based on static
/// components from the bottom and top navigation bars.
///
/// It animates these transitional components both in terms of position and
/// their appearance.
///
/// Instead of running the transitional components through their normal static
/// navigation bar layout logic, this creates transitional widgets that are based
/// on these widgets' existing render objects' layout and position.
///
/// This is possible because this widget is only used during Hero transitions
/// where both the from and to routes are already built and laid out.
///
/// The components' existing layout constraints and positions are then
/// replicated using [Positioned] or [PositionedTransition] wrappers.
///
/// This class should never return [KeyedSubtree]s created by
/// _NavigationBarStaticComponents directly. Since widgets from
/// _NavigationBarStaticComponents are still present in the widget tree during the
/// hero transitions, it would cause global key duplications. Instead, return
/// only the [KeyedSubtree]s' child.
@immutable
class _NavigationBarComponentsTransition {
  _NavigationBarComponentsTransition({
    required this.animation,
    required _TransitionableNavigationBar bottomNavBar,
    required _TransitionableNavigationBar topNavBar,
    required TextDirection directionality,
  })  : bottomComponents = bottomNavBar.componentsKeys,
        topComponents = topNavBar.componentsKeys,
        bottomNavBarBox = bottomNavBar.renderBox,
        topNavBarBox = topNavBar.renderBox,
        bottomBackButtonTextStyle = bottomNavBar.backButtonTextStyle,
        topBackButtonTextStyle = topNavBar.backButtonTextStyle,
        bottomTitleTextStyle = bottomNavBar.titleTextStyle,
        topTitleTextStyle = topNavBar.titleTextStyle,
        bottomLargeTitleTextStyle = bottomNavBar.largeTitleTextStyle,
        topLargeTitleTextStyle = topNavBar.largeTitleTextStyle,
        bottomHasUserMiddle = bottomNavBar.hasUserMiddle,
        topHasUserMiddle = topNavBar.hasUserMiddle,
        bottomLargeExpanded = bottomNavBar.largeExpanded,
        topLargeExpanded = topNavBar.largeExpanded,
        transitionBox =
            // paintBounds are based on offset zero so it's ok to expand the Rects.
            bottomNavBar.renderBox.paintBounds.expandToInclude(topNavBar.renderBox.paintBounds),
        forwardDirection = directionality == TextDirection.ltr ? 1.0 : -1.0;

  static final Animatable<double> fadeOut = Tween<double>(
    begin: 1.0,
    end: 0.0,
  );
  static final Animatable<double> fadeIn = Tween<double>(
    begin: 0.0,
    end: 1.0,
  );

  final Animation<double> animation;
  final _NavigationBarStaticComponentsKeys bottomComponents;
  final _NavigationBarStaticComponentsKeys topComponents;

  // These render boxes that are the ancestors of all the bottom and top
  // components are used to determine the components' relative positions inside
  // their respective navigation bars.
  final RenderBox bottomNavBarBox;
  final RenderBox topNavBarBox;

  final TextStyle bottomBackButtonTextStyle;
  final TextStyle topBackButtonTextStyle;
  final TextStyle bottomTitleTextStyle;
  final TextStyle topTitleTextStyle;
  final TextStyle? bottomLargeTitleTextStyle;
  final TextStyle? topLargeTitleTextStyle;

  final bool bottomHasUserMiddle;
  final bool topHasUserMiddle;
  final bool bottomLargeExpanded;
  final bool topLargeExpanded;

  // This is the outer box in which all the components will be fitted. The
  // sizing component of RelativeRects will be based on this rect's size.
  final Rect transitionBox;

  // x-axis unity number representing the direction of growth for text.
  final double forwardDirection;

  // Take a widget it its original ancestor navigation bar render box and
  // translate it into a RelativeBox in the transition navigation bar box.
  RelativeRect positionInTransitionBox(
    GlobalKey key, {
    required RenderBox from,
  }) {
    final RenderBox componentBox = key.currentContext!.findRenderObject()! as RenderBox;
    assert(componentBox.attached);

    return RelativeRect.fromRect(
      componentBox.localToGlobal(Offset.zero, ancestor: from) & componentBox.size,
      transitionBox,
    );
  }

  // Create an animated widget that moves the given child widget between its
  // original position in its ancestor navigation bar to another widget's
  // position in that widget's navigation bar.
  //
  // Anchor their positions based on the vertical middle of their respective
  // render boxes' leading edge.
  //
  // This method assumes there's no other transforms other than translations
  // when converting a rect from the original navigation bar's coordinate space
  // to the other navigation bar's coordinate space, to avoid performing
  // floating point operations on the size of the child widget, so that the
  // incoming constraints used for sizing the child widget will be exactly the
  // same.
  _FixedSizeSlidingTransition slideFromLeadingEdge({
    required GlobalKey fromKey,
    required RenderBox fromNavBarBox,
    required GlobalKey toKey,
    required RenderBox toNavBarBox,
    required Widget child,
  }) {
    final RenderBox fromBox = fromKey.currentContext!.findRenderObject()! as RenderBox;
    final RenderBox toBox = toKey.currentContext!.findRenderObject()! as RenderBox;

    final bool isLTR = forwardDirection > 0;

    // The animation moves the fromBox so its anchor (left-center or right-center
    // depending on the writing direction) aligns with toBox's anchor.
    final Offset fromAnchorLocal = Offset(
      isLTR ? 0 : fromBox.size.width,
      fromBox.size.height / 2,
    );
    final Offset toAnchorLocal = Offset(
      isLTR ? 0 : toBox.size.width,
      toBox.size.height / 2,
    );
    final Offset fromAnchorInFromBox = fromBox.localToGlobal(fromAnchorLocal, ancestor: fromNavBarBox);
    final Offset toAnchorInToBox = toBox.localToGlobal(toAnchorLocal, ancestor: toNavBarBox);

    // We can't get ahold of the render box of the stack (i.e., `transitionBox`)
    // we place components on yet, but we know the stack needs to be top-leading
    // aligned with both fromNavBarBox and toNavBarBox to make the transition
    // look smooth. Also use the top-leading point as the origin for ease of
    // calculation.

    // The offset to move fromAnchor to toAnchor, in transitionBox's top-leading
    // coordinates.
    final Offset translation = isLTR
        ? toAnchorInToBox - fromAnchorInFromBox
        : Offset(toNavBarBox.size.width - toAnchorInToBox.dx, toAnchorInToBox.dy) - Offset(fromNavBarBox.size.width - fromAnchorInFromBox.dx, fromAnchorInFromBox.dy);

    final RelativeRect fromBoxMargin = positionInTransitionBox(fromKey, from: fromNavBarBox);
    final Offset fromOriginInTransitionBox = Offset(
      isLTR ? fromBoxMargin.left : fromBoxMargin.right,
      fromBoxMargin.top,
    );

    final Tween<Offset> anchorMovementInTransitionBox = Tween<Offset>(
      begin: fromOriginInTransitionBox,
      end: fromOriginInTransitionBox + translation,
    );

    return _FixedSizeSlidingTransition(
      isLTR: isLTR,
      offsetAnimation: animation.drive(anchorMovementInTransitionBox),
      size: fromBox.size,
      child: child,
    );
  }

  Animation<double> fadeInFrom(double t, {Curve curve = Curves.easeIn}) {
    return animation.drive(fadeIn.chain(
      CurveTween(curve: Interval(t, 1.0, curve: curve)),
    ));
  }

  Animation<double> fadeOutBy(double t, {Curve curve = Curves.easeOut}) {
    return animation.drive(fadeOut.chain(
      CurveTween(curve: Interval(0.0, t, curve: curve)),
    ));
  }

  Widget? get bottomLeading {
    final KeyedSubtree? bottomLeading = bottomComponents.leadingKey.currentWidget as KeyedSubtree?;

    if (bottomLeading == null) {
      return null;
    }

    return Positioned.fromRelativeRect(
      rect: positionInTransitionBox(bottomComponents.leadingKey, from: bottomNavBarBox),
      child: FadeTransition(
        opacity: fadeOutBy(0.4),
        child: bottomLeading.child,
      ),
    );
  }

  Widget? get bottomBackChevron {
    final KeyedSubtree? bottomBackChevron = bottomComponents.backChevronKey.currentWidget as KeyedSubtree?;

    if (bottomBackChevron == null) {
      return null;
    }

    return Positioned.fromRelativeRect(
      rect: positionInTransitionBox(bottomComponents.backChevronKey, from: bottomNavBarBox),
      child: FadeTransition(
        opacity: fadeOutBy(0.6),
        child: DefaultTextStyle(
          style: bottomBackButtonTextStyle,
          child: bottomBackChevron.child,
        ),
      ),
    );
  }

  Widget? get bottomBackLabel {
    final KeyedSubtree? bottomBackLabel = bottomComponents.backLabelKey.currentWidget as KeyedSubtree?;

    if (bottomBackLabel == null) {
      return null;
    }

    final RelativeRect from = positionInTransitionBox(bottomComponents.backLabelKey, from: bottomNavBarBox);

    // Transition away by sliding horizontally to the leading edge off of the screen.
    final RelativeRectTween positionTween = RelativeRectTween(
      begin: from,
      end: from.shift(
        Offset(
          forwardDirection * (-bottomNavBarBox.size.width / 2.0),
          0.0,
        ),
      ),
    );

    return PositionedTransition(
      rect: animation.drive(positionTween),
      child: FadeTransition(
        opacity: fadeOutBy(0.2),
        child: DefaultTextStyle(
          style: bottomBackButtonTextStyle,
          child: bottomBackLabel.child,
        ),
      ),
    );
  }

  Widget? get bottomMiddle {
    final KeyedSubtree? bottomMiddle = bottomComponents.middleKey.currentWidget as KeyedSubtree?;
    final KeyedSubtree? topBackLabel = topComponents.backLabelKey.currentWidget as KeyedSubtree?;
    final KeyedSubtree? topLeading = topComponents.leadingKey.currentWidget as KeyedSubtree?;

    // The middle component is non-null when the nav bar is a large title
    // nav bar but would be invisible when expanded, therefore don't show it here.
    if (!bottomHasUserMiddle && bottomLargeExpanded) {
      return null;
    }

    if (bottomMiddle != null && topBackLabel != null) {
      // Move from current position to the top page's back label position.
      return slideFromLeadingEdge(
        fromKey: bottomComponents.middleKey,
        fromNavBarBox: bottomNavBarBox,
        toKey: topComponents.backLabelKey,
        toNavBarBox: topNavBarBox,
        child: FadeTransition(
          // A custom middle widget like a segmented control fades away faster.
          opacity: fadeOutBy(bottomHasUserMiddle ? 0.4 : 0.7),
          child: Align(
            // As the text shrinks, make sure it's still anchored to the leading
            // edge of a constantly sized outer box.
            alignment: AlignmentDirectional.centerStart,
            child: DefaultTextStyleTransition(
              style: animation.drive(TextStyleTween(
                begin: bottomTitleTextStyle,
                end: topBackButtonTextStyle,
              )),
              child: bottomMiddle.child,
            ),
          ),
        ),
      );
    }

    // When the top page has a leading widget override (one of the few ways to
    // not have a top back label), don't move the bottom middle widget and just
    // fade.
    if (bottomMiddle != null && topLeading != null) {
      return Positioned.fromRelativeRect(
        rect: positionInTransitionBox(bottomComponents.middleKey, from: bottomNavBarBox),
        child: FadeTransition(
          opacity: fadeOutBy(bottomHasUserMiddle ? 0.4 : 0.7),
          // Keep the font when transitioning into a non-back label leading.
          child: DefaultTextStyle(
            style: bottomTitleTextStyle,
            child: bottomMiddle.child,
          ),
        ),
      );
    }

    return null;
  }

  Widget? get bottomLargeTitle {
    final KeyedSubtree? bottomLargeTitle = bottomComponents.largeTitleKey.currentWidget as KeyedSubtree?;
    final KeyedSubtree? topBackLabel = topComponents.backLabelKey.currentWidget as KeyedSubtree?;
    final KeyedSubtree? topLeading = topComponents.leadingKey.currentWidget as KeyedSubtree?;

    if (bottomLargeTitle == null || !bottomLargeExpanded) {
      return null;
    }

    if (topBackLabel != null) {
      // Move from current position to the top page's back label position.
      return slideFromLeadingEdge(
        fromKey: bottomComponents.largeTitleKey,
        fromNavBarBox: bottomNavBarBox,
        toKey: topComponents.backLabelKey,
        toNavBarBox: topNavBarBox,
        child: FadeTransition(
          opacity: fadeOutBy(0.6),
          child: Align(
            // As the text shrinks, make sure it's still anchored to the leading
            // edge of a constantly sized outer box.
            alignment: AlignmentDirectional.centerStart,
            child: DefaultTextStyleTransition(
              style: animation.drive(TextStyleTween(
                begin: bottomLargeTitleTextStyle,
                end: topBackButtonTextStyle,
              )),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: bottomLargeTitle.child,
            ),
          ),
        ),
      );
    }

    if (topLeading != null) {
      // Unlike bottom middle, the bottom large title moves when it can't
      // transition to the top back label position.
      final RelativeRect from = positionInTransitionBox(bottomComponents.largeTitleKey, from: bottomNavBarBox);

      final RelativeRectTween positionTween = RelativeRectTween(
        begin: from,
        end: from.shift(
          Offset(
            forwardDirection * bottomNavBarBox.size.width / 4.0,
            0.0,
          ),
        ),
      );

      // Just shift slightly towards the trailing edge instead of moving to the
      // back label position.
      return PositionedTransition(
        rect: animation.drive(positionTween),
        child: FadeTransition(
          opacity: fadeOutBy(0.4),
          // Keep the font when transitioning into a non-back-label leading.
          child: DefaultTextStyle(
            style: bottomLargeTitleTextStyle!,
            child: bottomLargeTitle.child,
          ),
        ),
      );
    }

    return null;
  }

  Widget? get bottomTrailing {
    final KeyedSubtree? bottomTrailing = bottomComponents.trailingKey.currentWidget as KeyedSubtree?;

    if (bottomTrailing == null) {
      return null;
    }

    return Positioned.fromRelativeRect(
      rect: positionInTransitionBox(bottomComponents.trailingKey, from: bottomNavBarBox),
      child: FadeTransition(
        opacity: fadeOutBy(0.6),
        child: bottomTrailing.child,
      ),
    );
  }

  Widget? get topLeading {
    final KeyedSubtree? topLeading = topComponents.leadingKey.currentWidget as KeyedSubtree?;

    if (topLeading == null) {
      return null;
    }

    return Positioned.fromRelativeRect(
      rect: positionInTransitionBox(topComponents.leadingKey, from: topNavBarBox),
      child: FadeTransition(
        opacity: fadeInFrom(0.6),
        child: topLeading.child,
      ),
    );
  }

  Widget? get topBackChevron {
    final KeyedSubtree? topBackChevron = topComponents.backChevronKey.currentWidget as KeyedSubtree?;
    final KeyedSubtree? bottomBackChevron = bottomComponents.backChevronKey.currentWidget as KeyedSubtree?;

    if (topBackChevron == null) {
      return null;
    }

    final RelativeRect to = positionInTransitionBox(topComponents.backChevronKey, from: topNavBarBox);
    RelativeRect from = to;

    // If it's the first page with a back chevron, shift in slightly from the
    // right.
    if (bottomBackChevron == null) {
      final RenderBox topBackChevronBox = topComponents.backChevronKey.currentContext!.findRenderObject()! as RenderBox;
      from = to.shift(
        Offset(
          forwardDirection * topBackChevronBox.size.width * 2.0,
          0.0,
        ),
      );
    }

    final RelativeRectTween positionTween = RelativeRectTween(
      begin: from,
      end: to,
    );

    return PositionedTransition(
      rect: animation.drive(positionTween),
      child: FadeTransition(
        opacity: fadeInFrom(bottomBackChevron == null ? 0.7 : 0.4),
        child: DefaultTextStyle(
          style: topBackButtonTextStyle,
          child: topBackChevron.child,
        ),
      ),
    );
  }

  Widget? get topBackLabel {
    final KeyedSubtree? bottomMiddle = bottomComponents.middleKey.currentWidget as KeyedSubtree?;
    final KeyedSubtree? bottomLargeTitle = bottomComponents.largeTitleKey.currentWidget as KeyedSubtree?;
    final KeyedSubtree? topBackLabel = topComponents.backLabelKey.currentWidget as KeyedSubtree?;

    if (topBackLabel == null) {
      return null;
    }

    final RenderAnimatedOpacity? topBackLabelOpacity = topComponents.backLabelKey.currentContext?.findAncestorRenderObjectOfType<RenderAnimatedOpacity>();

    Animation<double>? midClickOpacity;
    if (topBackLabelOpacity != null && topBackLabelOpacity.opacity.value < 1.0) {
      midClickOpacity = animation.drive(Tween<double>(
        begin: 0.0,
        end: topBackLabelOpacity.opacity.value,
      ));
    }

    // Pick up from an incoming transition from the large title. This is
    // duplicated here from the bottomLargeTitle transition widget because the
    // content text might be different. For instance, if the bottomLargeTitle
    // text is too long, the topBackLabel will say 'Back' instead of the original
    // text.
    if (bottomLargeTitle != null && bottomLargeExpanded) {
      return slideFromLeadingEdge(
        fromKey: bottomComponents.largeTitleKey,
        fromNavBarBox: bottomNavBarBox,
        toKey: topComponents.backLabelKey,
        toNavBarBox: topNavBarBox,
        child: FadeTransition(
          opacity: midClickOpacity ?? fadeInFrom(0.4),
          child: DefaultTextStyleTransition(
            style: animation.drive(TextStyleTween(
              begin: bottomLargeTitleTextStyle,
              end: topBackButtonTextStyle,
            )),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            child: topBackLabel.child,
          ),
        ),
      );
    }

    // The topBackLabel always comes from the large title first if available
    // and expanded instead of middle.
    if (bottomMiddle != null) {
      return slideFromLeadingEdge(
        fromKey: bottomComponents.middleKey,
        fromNavBarBox: bottomNavBarBox,
        toKey: topComponents.backLabelKey,
        toNavBarBox: topNavBarBox,
        child: FadeTransition(
          opacity: midClickOpacity ?? fadeInFrom(0.3),
          child: DefaultTextStyleTransition(
            style: animation.drive(TextStyleTween(
              begin: bottomTitleTextStyle,
              end: topBackButtonTextStyle,
            )),
            child: topBackLabel.child,
          ),
        ),
      );
    }

    return null;
  }

  Widget? get topMiddle {
    final KeyedSubtree? topMiddle = topComponents.middleKey.currentWidget as KeyedSubtree?;

    if (topMiddle == null) {
      return null;
    }

    // The middle component is non-null when the nav bar is a large title
    // nav bar but would be invisible when expanded, therefore don't show it here.
    if (!topHasUserMiddle && topLargeExpanded) {
      return null;
    }

    final RelativeRect to = positionInTransitionBox(topComponents.middleKey, from: topNavBarBox);
    final RenderBox toBox = topComponents.middleKey.currentContext!.findRenderObject()! as RenderBox;

    final bool isLTR = forwardDirection > 0;

    // Anchor is the top-leading point of toBox, in transition box's top-leading
    // coordinate space.
    final Offset toAnchorInTransitionBox = Offset(
      isLTR ? to.left : to.right,
      to.top,
    );

    // Shift in from the trailing edge of the screen.
    final Tween<Offset> anchorMovementInTransitionBox = Tween<Offset>(
      begin: Offset(
        // the "width / 2" here makes the middle widget's horizontal center on
        // the trailing edge of the top nav bar.
        topNavBarBox.size.width - toBox.size.width / 2,
        to.top,
      ),
      end: toAnchorInTransitionBox,
    );

    return _FixedSizeSlidingTransition(
      isLTR: isLTR,
      offsetAnimation: animation.drive(anchorMovementInTransitionBox),
      size: toBox.size,
      child: FadeTransition(
        opacity: fadeInFrom(0.25),
        child: DefaultTextStyle(
          style: topTitleTextStyle,
          child: topMiddle.child,
        ),
      ),
    );
  }

  Widget? get topTrailing {
    final KeyedSubtree? topTrailing = topComponents.trailingKey.currentWidget as KeyedSubtree?;

    if (topTrailing == null) {
      return null;
    }

    return Positioned.fromRelativeRect(
      rect: positionInTransitionBox(topComponents.trailingKey, from: topNavBarBox),
      child: FadeTransition(
        opacity: fadeInFrom(0.4),
        child: topTrailing.child,
      ),
    );
  }

  Widget? get topLargeTitle {
    final KeyedSubtree? topLargeTitle = topComponents.largeTitleKey.currentWidget as KeyedSubtree?;

    if (topLargeTitle == null || !topLargeExpanded) {
      return null;
    }

    final RelativeRect to = positionInTransitionBox(topComponents.largeTitleKey, from: topNavBarBox);

    // Shift in from the trailing edge of the screen.
    final RelativeRectTween positionTween = RelativeRectTween(
      begin: to.shift(
        Offset(
          forwardDirection * topNavBarBox.size.width,
          0.0,
        ),
      ),
      end: to,
    );

    return PositionedTransition(
      rect: animation.drive(positionTween),
      child: FadeTransition(
        opacity: fadeInFrom(0.3),
        child: DefaultTextStyle(
          style: topLargeTitleTextStyle!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          child: topLargeTitle.child,
        ),
      ),
    );
  }
}

/// Navigation bars' hero rect tween that will move between the static bars
/// but keep a constant size that's the bigger of both navigation bars.
RectTween _linearTranslateWithLargestRectSizeTween(Rect? begin, Rect? end) {
  final Size largestSize = Size(
    math.max(begin!.size.width, end!.size.width),
    math.max(begin.size.height, end.size.height),
  );
  return RectTween(
    begin: begin.topLeft & largestSize,
    end: end.topLeft & largestSize,
  );
}

Widget _navBarHeroLaunchPadBuilder(
  BuildContext context,
  Size heroSize,
  Widget child,
) {
  assert(child is _TransitionableNavigationBar);
  // Tree reshaping is fine here because the Heroes' child is always a
  // _TransitionableNavigationBar which has a GlobalKey.

  // Keeping the Hero subtree here is needed (instead of just swapping out the
  // anchor nav bars for fixed size boxes during flights) because the nav bar
  // and their specific component children may serve as anchor points again if
  // another mid-transition flight diversion is triggered.

  // This is ok performance-wise because static nav bars are generally cheap to
  // build and layout but expensive to GPU render (due to clips and blurs) which
  // we're skipping here.
  return Visibility(
    maintainSize: true,
    maintainAnimation: true,
    maintainState: true,
    visible: false,
    child: child,
  );
}

/// Navigation bars' hero flight shuttle builder.
Widget _navBarHeroFlightShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  assert(fromHeroContext.widget is Hero);
  assert(toHeroContext.widget is Hero);

  final Hero fromHeroWidget = fromHeroContext.widget as Hero;
  final Hero toHeroWidget = toHeroContext.widget as Hero;

  assert(fromHeroWidget.child is _TransitionableNavigationBar);
  assert(toHeroWidget.child is _TransitionableNavigationBar);

  final _TransitionableNavigationBar fromNavBar = fromHeroWidget.child as _TransitionableNavigationBar;
  final _TransitionableNavigationBar toNavBar = toHeroWidget.child as _TransitionableNavigationBar;

  assert(
    fromNavBar.componentsKeys.navBarBoxKey.currentContext!.owner != null,
    'The from nav bar to Hero must have been mounted in the previous frame',
  );
  assert(
    toNavBar.componentsKeys.navBarBoxKey.currentContext!.owner != null,
    'The to nav bar to Hero must have been mounted in the previous frame',
  );

  switch (flightDirection) {
    case HeroFlightDirection.push:
      return _NavigationBarTransition(
        animation: animation,
        bottomNavBar: fromNavBar,
        topNavBar: toNavBar,
      );
    case HeroFlightDirection.pop:
      return _NavigationBarTransition(
        animation: animation,
        bottomNavBar: toNavBar,
        topNavBar: fromNavBar,
      );
  }
}
