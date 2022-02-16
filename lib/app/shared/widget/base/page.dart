import 'package:flutter/material.dart';
import 'package:talao/app/shared/widget/app_bar.dart';

class BasePage extends StatelessWidget {
  final String? title;

  final Widget body;
  final bool scrollView;

  final EdgeInsets padding;
  final Color? backgroundColor;

  final String? titleTag;
  final Widget? titleLeading;
  final Widget? titleTrailing;

  final Widget? navigation;

  final bool? extendBelow;

  final bool useSafeArea;

  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const BasePage({
    Key? key,
    this.backgroundColor,
    this.title,
    this.titleTag,
    this.titleLeading,
    this.titleTrailing,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 24.0,
      vertical: 32.0,
    ),
    this.scrollView = true,
    this.navigation,
    this.extendBelow,
    required this.body,
    this.useSafeArea = true,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        extendBody: extendBelow ?? false,
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.background,
        appBar: title != null && title!.isNotEmpty
            ? CustomAppBar(
                title: title!,
                tag: titleTag,
                leading: titleLeading,
                trailing: titleTrailing,
              )
            : null,
        bottomNavigationBar: navigation,
        body: scrollView
            ? SingleChildScrollView(
                padding: padding,
                child: useSafeArea ? SafeArea(child: body) : body,
              )
            : Padding(
                padding: padding,
                child: useSafeArea ? SafeArea(child: body) : body,
              ),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
    );
  }
}
