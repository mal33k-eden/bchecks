import 'package:flutter/material.dart';

class Onboarding {
  String img;
  String title;
  String des;
  Color bg;
  Color button;

  Onboarding(
      {required this.img,
      required this.title,
      required this.des,
      required this.bg,
      required this.button});
}

List<Onboarding> screens = <Onboarding>[
  Onboarding(
      img: 'assets/images/splash1.svg',
      title: 'Expenses Organized',
      des: 'Description 1',
      bg: Colors.white,
      button: Colors.black),
  Onboarding(
      img: 'assets/images/splash2.svg',
      title: 'Expenses Visibility',
      des: 'Description 2',
      bg: Colors.white,
      button: Colors.black),
  Onboarding(
      img: 'assets/images/splash3.svg',
      title: 'Budget Optimizer',
      des: 'Description 3',
      bg: Colors.white,
      button: Colors.black)
];
