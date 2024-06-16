import 'package:flutter/material.dart';

class PriceTextView extends StatelessWidget {
  final String price;

  PriceTextView({required this.price});

  @override
  Widget build(BuildContext context) {
    // Convert the price string to a double
    double priceDouble = double.parse(price);
    // Format the double to a string with two decimal places
    String formattedPrice = priceDouble.toStringAsFixed(2);

    return Text(
      formattedPrice,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
