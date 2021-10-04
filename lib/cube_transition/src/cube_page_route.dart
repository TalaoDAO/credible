import 'package:flutter/material.dart';
import 'dart:math';

/// This is a Custom page route we use to simulate the 3D Cubic transition from page to page
/// It should be used with the [Navigator]
///
/// This was taken from: https://stackoverflow.com/questions/59649977/flutter-transition-between-pages-with-effect-3d
///
class CubePageRoute extends PageRouteBuilder {
  /// The duration of the transition
  final Duration duration;

  /// The next page we will show
  final Widget enterPage;

  /// The current page we will dismiss
  final Widget? exitPage;

  /// Background color used when the transition is running , it's [Colors.black] as default
  final Color backgroundColor;

  CubePageRoute({
    this.exitPage,
    required this.enterPage,
    this.backgroundColor = Colors.black,
    this.duration = const Duration(
      milliseconds: 500,
    ),
  }) : super(
          transitionDuration: duration,
          pageBuilder: (context, animation, secondaryAnimation) => enterPage,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Container(
              color: backgroundColor,
              child: Stack(
                children: <Widget>[
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset.zero,
                      end: Offset(-1.0, 0.0),
                    ).animate(animation),
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.003)
                        ..rotateY(pi / 2 * animation.value),
                      alignment: FractionalOffset.centerRight,
                      child: exitPage,
                    ),
                  ),
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.003)
                        ..rotateY(pi / 2 * (animation.value - 1)),
                      alignment: FractionalOffset.centerLeft,
                      child: enterPage,
                    ),
                  )
                ],
              ),
            );
          },
        );
}
