import 'package:flutter/material.dart';

class NotificationsTileModel {
  final String title;
  final String message;
  final String dateTime;
  final Widget widget;
  final bool isActionable;

  NotificationsTileModel({
    required this.title,
    required this.message,
    required this.dateTime,
    required this.widget,
    required this.isActionable,
  });
}
