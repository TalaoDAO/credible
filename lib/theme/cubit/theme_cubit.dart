import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void setLightTheme(){
    emit(ThemeMode.light);
  }

  void setDartTheme(){
    emit(ThemeMode.dark);
  }

}
