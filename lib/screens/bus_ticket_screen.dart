import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:date_format/date_format.dart';
import 'package:watantelecom/widgets/default_button.dart';

import 'bus_result.dart';

class BusTicketScreen extends StatefulWidget {
  BusTicketScreen({super.key});

  @override
  State<BusTicketScreen> createState() => _BusTicketScreenState();
}

class _BusTicketScreenState extends State<BusTicketScreen> {
  List fromlistt = [
    "Dhaka",
    "Magura",
    "Rajshahi",
    "Sylhet",
    "Kadirpara",
    "Screepur",
  ];

  String from = "From...";
  String destination = "To...";
  String selectetdDate = "Select a date";

  TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;

        selectetdDate = DateFormat.yMMMEd(_selectedDate).toString();

        _dateController.text = _selectedDate.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        centerTitle: true,
        title: Text(
          "Bus Ticket",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/busticket.jpg"),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 120,
                child: TimelineTile(
                  isLast: false,
                  isFirst: true,
                  indicatorStyle: IndicatorStyle(
                    width: 25,
                    iconStyle: IconStyle(
                      iconData: Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  endChild: Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 50,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Container(
                      height: 50,
                      width: screenWidth,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: Center(
                                  child: Row(
                                    children: [
                                      Text(from.toString()),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        surfaceTintColor: Colors.white,
                                        backgroundColor: Colors.white,
                                        content: Container(
                                          height: 280,
                                          width: screenWidth,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: ListView.builder(
                                            itemCount: fromlistt.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    from = fromlistt[index]
                                                        .toString();
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      fromlistt[index]
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_downward_outlined,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 120,
                child: TimelineTile(
                  isLast: false,
                  isFirst: false,
                  indicatorStyle: IndicatorStyle(
                    width: 25,
                    iconStyle: IconStyle(
                      iconData: Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  endChild: Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 50,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Container(
                      height: 50,
                      width: screenWidth,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: Center(
                                  child: Row(
                                    children: [
                                      Text(destination.toString()),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        surfaceTintColor: Colors.white,
                                        backgroundColor: Colors.white,
                                        content: Container(
                                          height: 280,
                                          width: screenWidth,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: ListView.builder(
                                            itemCount: fromlistt.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    destination =
                                                        fromlistt[index]
                                                            .toString();
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      fromlistt[index]
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_downward_outlined,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 120,
                child: TimelineTile(
                  isLast: true,
                  isFirst: false,
                  indicatorStyle: IndicatorStyle(
                    width: 25,
                    iconStyle: IconStyle(
                      iconData: Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  endChild: Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 50,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Container(
                      height: 50,
                      width: screenWidth,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: Center(
                                  child: Row(
                                    children: [
                                      Text(selectetdDate.toString()),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: Container(
                                  child: Center(
                                    child: Icon(
                                      Icons.calendar_month,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              DefaultButton(
                buttonName: "Search Bus",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BusResultScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
