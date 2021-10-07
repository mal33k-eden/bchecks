import 'package:flutter/material.dart';

class TrxCategory {
  String name;
  Color color;
  IconData icon;

  TrxCategory({required this.name, required this.color, required this.icon});
}

List<TrxCategory> trx_categories = <TrxCategory>[
  TrxCategory(name: 'Bills', color: Colors.purple, icon: Icons.payment),
  TrxCategory(name: 'Family', color: Colors.green, icon: Icons.family_restroom),
  TrxCategory(
      name: 'Shopping',
      color: Colors.orange,
      icon: Icons.shopping_basket_sharp),
  TrxCategory(
      name: 'Help', color: Colors.brown, icon: Icons.volunteer_activism_sharp),
  TrxCategory(
      name: 'Transport', color: Colors.pink, icon: Icons.directions_car_sharp),
  TrxCategory(
      name: 'Church', color: Colors.indigo, icon: Icons.local_florist_sharp),
  TrxCategory(
      name: 'Miscellaneous', color: Colors.red, icon: Icons.payments_sharp),
];
