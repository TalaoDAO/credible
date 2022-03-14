part of 'scan_cubit.dart';

@JsonSerializable()
class ScanState extends Equatable {
  ScanState({
    this.message,
    this.preview,
    this.data,
    this.uri,
    this.keyId,
    this.challenge,
    this.domain,
    this.done,
  });

  factory ScanState.fromJson(Map<String, dynamic> json) =>
      _$ScanStateFromJson(json);

  final StateMessage? message;
  final Map<String, dynamic>? preview;
  final Map<String, dynamic>? data;
  final Uri? uri;
  final String? keyId;
  final String? challenge;
  final String? domain;
  @JsonKey(ignore: true)
  final void Function(String)? done;

  Map<String, dynamic> toJson() => _$ScanStateToJson(this);

  @override
  List<Object?> get props =>
      [message, preview, data, uri, keyId, challenge, domain, done];
}

class ScanStateIdle extends ScanState {}

class ScanStateMessage extends ScanState {
  ScanStateMessage({StateMessage? message}) : super(message: message);
}

class ScanStatePreview extends ScanState {
  ScanStatePreview({Map<String, dynamic>? preview}) : super(preview: preview);
}

class ScanStateSuccess extends ScanState {}

class ScanStateStoreQueryByExample extends ScanState {
  ScanStateStoreQueryByExample({Map<String, dynamic>? data, Uri? uri})
      : super(data: data, uri: uri);
}

class ScanStateAskPermissionDIDAuth extends ScanState {
  ScanStateAskPermissionDIDAuth(
      {String? keyId,
      String? challenge,
      String? domain,
      Uri? uri,
      void Function(String)? done})
      : super(
            keyId: keyId,
            challenge: challenge,
            domain: domain,
            uri: uri,
            done: done);
}
