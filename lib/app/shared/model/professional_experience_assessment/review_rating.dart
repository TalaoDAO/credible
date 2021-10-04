import 'package:json_annotation/json_annotation.dart';

part 'review_rating.g.dart';

@JsonSerializable(explicitToJson: true)
class ReviewRating {
  @JsonKey(defaultValue: '')
  final String bestRating;
  @JsonKey(defaultValue: '')
  final String ratingValue;
  @JsonKey(defaultValue: '')
  final String type;
  @JsonKey(defaultValue: '')
  final String worstRating;

  factory ReviewRating.fromJson(Map<String, dynamic> json) =>
      _$ReviewRatingFromJson(json);

  ReviewRating(this.bestRating, this.ratingValue, this.type, this.worstRating);

  Map<String, dynamic> toJson() => _$ReviewRatingToJson(this);
}
