import 'dart:async';
import 'dart:convert';
import 'package:Taillz/domain/auth/models/user_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future<dynamic>getUserID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return jsonDecode(prefs.getString('data')!)['CustomerID'];
}

Future CreateSession(data,{bool islogin=true}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLogin', islogin);
  await prefs.setString('data', jsonEncode(data));
}

Future<UserInfo>getSession() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return UserInfo.fromMap(jsonDecode(prefs.getString('data')??'{}'));
}

Logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}
Future<bool> isLogin() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLogin')??false;
  }

const String prefSelectedLanguageCode = 'SelectedLanguageCode';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(prefSelectedLanguageCode, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  final List<Locale> systemLocales = WidgetsBinding.instance.window.locales;
  String languageCode = _prefs.getString(prefSelectedLanguageCode) ?? systemLocales.first.languageCode;
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  final List<Locale> systemLocales = WidgetsBinding.instance.window.locales;
  return languageCode.isNotEmpty
      ? Locale(languageCode, '')
      : Locale(systemLocales.first.languageCode, '');
}

void changeLanguage(BuildContext context, String selectedLanguageCode) async {
  var _locale = await setLocale(selectedLanguageCode);
 // MyApp.setLocale(context, _locale);
  
}

