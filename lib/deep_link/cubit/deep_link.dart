import 'package:bloc/bloc.dart';

class DeepLinkCubit extends Cubit<String> {
  DeepLinkCubit() : super('');

  void addDeepLink(url) {
    emit(url);
  }
  void resetDeepLink() {
    emit('');
  }
}
