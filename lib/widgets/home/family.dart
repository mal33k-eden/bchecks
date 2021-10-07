import 'package:flutter/material.dart';

class FamilyWidget extends StatelessWidget {
  num total;
  FamilyWidget({Key? key, required this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.teal,
              child: Icon(
                Icons.family_restroom_sharp,
                color: Colors.white,
                size: 40,
              ),
              radius: 40,
            ),
            SizedBox(height: 10),
            Text(
              'Family',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            SizedBox(height: 5),
            Text('\$$total',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      color: Colors.white,
    );
  }
}
