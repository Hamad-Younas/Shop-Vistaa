import 'package:flutter/material.dart';

class Utils{
  showMessageBar(BuildContext context,String text){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            text.toString(),
          ),
        ),
      );
  }
}