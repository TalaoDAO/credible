// ignore_for_file: unused_import

import 'package:talao/app/interop/launch_url/launch_url.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/card_animation.dart';
import 'package:talao/app/shared/widget/display_description_card.dart';
import 'package:talao/app/shared/widget/display_name_card.dart';
import 'package:talao/app/shared/widget/image_card_text.dart';
import 'package:talao/app/shared/widget/image_from_network.dart';
import 'package:talao/credentials/widget/credential_background.dart';
import 'package:talao/credentials/widget/credential_container.dart';
import 'package:talao/credentials/widget/display_issuer.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/model/learning_achievement/has_credential.dart';
import 'package:talao/app/shared/widget/base/credential_field.dart';
import 'package:url_launcher/url_launcher.dart';

part 'sub_learning_achievement.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class SubLearningAchievement {
  @JsonKey(defaultValue: '')
  String description;
  @JsonKey(defaultValue: '')
  String id;
  @JsonKey(defaultValue: '')
  String title;

  SubLearningAchievement(this.description, this.id, this.title);

  factory SubLearningAchievement.fromJson(Map<String, dynamic> json) =>
      _$SubLearningAchievementFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SubLearningAchievementToJson(this);
}
