import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/authentication/providers/authServiceProvider.dart';
import 'package:isamm_news/features/authentication/screens/login.dart';


class PageControllerNotifier extends StateNotifier<PageController> {
  PageControllerNotifier() : super(PageController());
  var pageIndex = 0;

  void updatePageIndicator(index) {
    pageIndex = index;
  }

  void onDotClicked(index) {
    pageIndex = index;
    state.jumpTo(index);
  }

  void skipPage(context , WidgetRef ref) {
      ref.read(authServiceProvider).setOnboardingComplete();

     Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => LoginScreen()));
  }
  //  void nextPage(context, WidgetRef ref) {
  //   if (pageIndex == 2) {
  //     ref.read(authServiceProvider).setOnboardingComplete();
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (ctx) => LoginScreen()));
  //   } else {
  //     pageIndex += 1;
  //     state.jumpToPage(pageIndex);
  //   }
  // }

  void nextPage(context, WidgetRef ref) {
    if (pageIndex == 2) {
      ref.read(authServiceProvider).setOnboardingComplete();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => LoginScreen()));
    } else {
      pageIndex += 1;
      state.jumpToPage(pageIndex);
    }
  }
}

final pageControllerProvider =
    StateNotifierProvider<PageControllerNotifier, PageController>(
        (ref) => PageControllerNotifier());
