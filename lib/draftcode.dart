import 'package:flutter/material.dart';

class MyDraftScreen extends StatelessWidget {
  final List<String> names = [
    "hasan",
    "rajib",
    "elip",
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Centered ListView Items'),
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: names.map((name) {
                        return Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(name),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
