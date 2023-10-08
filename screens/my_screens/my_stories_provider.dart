
import 'package:flutter/material.dart';

class MyStoriesProvider extends ChangeNotifier {
  List<bool> _isLikeData = [];

  List<bool> get isLikeData => _isLikeData;

  isLikeDataFalse(List<bool> value) {
   _isLikeData = value;
   notifyListeners();
  }

  isLikeDataTrue(int index) {

      _isLikeData.insert(index, true);
      notifyListeners();

  }
}
