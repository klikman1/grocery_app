import 'package:flutter/material.dart';

class CountBox extends StatelessWidget{
  final int checkedCount;
  final int totalCount;

  const CountBox({super.key, required this.checkedCount, required this.totalCount,});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 3.0),
        borderRadius: BorderRadius.circular(18.0),
      ),
      child:  Text(
        "$checkedCount/$totalCount",
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

}