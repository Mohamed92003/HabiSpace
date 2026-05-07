import 'package:flutter/material.dart';

class HistorySkeleton extends StatelessWidget{
  HistorySkeleton({
         Key? key,
  });
 
 @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(''),
            Text(''),
          ],
        ),
      ),
    );
  }
}