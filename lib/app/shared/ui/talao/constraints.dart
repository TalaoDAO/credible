import 'package:talao/app/shared/ui/base/constraints.dart';
import 'package:flutter/material.dart';

class TalaoConstraints extends UiConstraints {
  const TalaoConstraints();

  @override
  EdgeInsets get buttonPadding => const EdgeInsets.symmetric(
        vertical: 8.0,
      );

  @override
  BorderRadius get buttonRadius => BorderRadius.circular(24.0);

  @override
  EdgeInsets get navBarPadding => EdgeInsets.zero;

  @override
  BorderRadius get navBarRadius => BorderRadius.zero;

  @override
  EdgeInsets get textFieldPadding => EdgeInsets.zero;

  @override
  BorderRadius get textFieldRadius => BorderRadius.zero;
}
