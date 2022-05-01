import 'package:flutter/material.dart';

ScaffoldMessengerState snackBar(BuildContext context, String message){
  return ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),), backgroundColor: const Color(0xffff000f), duration: const Duration(seconds: 3)));
}

ScaffoldMessengerState doubleTap(BuildContext context){
  return ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(const SnackBar(content: Text('Double tap to close app'), duration: Duration(seconds: 2)));
}