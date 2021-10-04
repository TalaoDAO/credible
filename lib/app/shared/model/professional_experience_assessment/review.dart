import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/professional_experience_assessment/review_rating.dart';
import 'package:talao/app/shared/model/translation.dart';

part 'review.g.dart';

@JsonSerializable(explicitToJson: true)
class Review {
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: [])
  final List<Translation> reviewBody;
  @JsonKey(fromJson: _reviewRatingFromJson)
  final ReviewRating reviewRating;
  @JsonKey(defaultValue: '')
  final String type;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Review(this.name, this.reviewBody, this.reviewRating, this.type);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);

  static ReviewRating _reviewRatingFromJson(json) {
    if (json == null || json == '') {
      return ReviewRating('', '', '', '');
    }
    return ReviewRating.fromJson(json);
  }
}
