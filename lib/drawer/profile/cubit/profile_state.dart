import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:talao/drawer/profile/models/profile.dart';

part 'profile_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfileState extends Equatable {
  ProfileState({this.message, this.model});

   factory ProfileState.fromJson(Map<String, dynamic> json) =>
       _$ProfileStateFromJson(json);

  final ProfileModel? model;
  final StateMessage? message;

  Map<String, dynamic> toJson() => _$ProfileStateToJson(this);

  @override
  List<Object?> get props => [model, message];
}

class ProfileStateMessage extends ProfileState {
  ProfileStateMessage({StateMessage? message}) : super(message: message);
}

class ProfileStateDefault extends ProfileState {
  ProfileStateDefault({ProfileModel? model}) : super(model: model);
}
