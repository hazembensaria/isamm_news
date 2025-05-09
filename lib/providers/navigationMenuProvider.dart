import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/find_isamm/screens/map.dart';
import 'package:isamm_news/features/home/screens/home.dart';
import 'package:isamm_news/features/profile_managing/screens/profile.dart';

class NavigationMenuNotifier extends StateNotifier<int> {
  NavigationMenuNotifier() : super(0);
  final screens = [const HomeScreen() ,  MapScreen() ,const ProfileScreen() ];
 
 void setIndex(index){
  state = index ;
 }

 Widget setScreen(){
  return screens[state];
 }
}

class HomeScerrn {
  const HomeScerrn();
}

final navigationMenuProvider =
    StateNotifierProvider<NavigationMenuNotifier, int>(
        (ref) => NavigationMenuNotifier());
