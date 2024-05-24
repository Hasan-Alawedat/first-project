import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RememberMeController extends GetxController {
  final GetStorage storage = GetStorage();
  final RxBool rememberMe = false.obs;
  @override
  void onInit() {
    rememberMe.value = storage.read('rememberMe') ?? false;
    super.onInit();
  }

  void toggleRememberMe(bool value) {
    rememberMe.value = value;
    storage.write('rememberMe', value);
  }
}
