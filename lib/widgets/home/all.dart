import 'package:flutter/material.dart';

class AllWidget extends StatelessWidget {
  DateTime selectedDate;
  final Function refreshTotal;
  AllWidget({Key? key, required this.selectedDate, required this.refreshTotal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, 'allTrx',
                arguments: {'date': selectedDate, 'refresh': refreshTotal});
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.purple,
                child: Icon(
                  Icons.swap_vert_circle_sharp,
                  color: Colors.white,
                  size: 40,
                ),
                radius: 40,
              ),
              SizedBox(height: 10),
              Text(
                'All',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
              SizedBox(height: 5),
              Text('Transactions',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      color: Colors.white,
    );
  }
}
