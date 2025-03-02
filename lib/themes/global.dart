import 'package:flutter/material.dart';

abstract class Global {
  static const Color blue = Color(0xff4A64FE);
  static const List lights = [
    {
      'location': 'Kitchen',
      'name': 'LED001',
      'status': true,
      'position': [-0.18, 0.1],
      'tile': 1,
    },
    {
      'location': 'Kitchen',
      'name': 'LED002',
      'status': true,
      'position': [-0.2, 0.2],
      'tile': 2,
    },
    {
      'location': 'Office 01',
      'name': 'LED003',
      'status': true,
      'position': [-0.33, 0.2],
      'tile': 3,
    },
    {
      'location': 'Meeting room 01',
      'name': 'LED004',
      'status': false,
      'position': [-0.2, -0.15],
      'tile': 4,
    },
    {
      'location': 'Office 02',
      'name': 'LED005',
      'status': true,
      'position': [0.1, 0.0],
      'tile': 1,
    },
    {
      'location': 'Office 02',
      'name': 'LED006',
      'status': true,
      'position': [0.25, 0.15],
      'tile': 1,
    },
    {
      'location': 'Office 02',
      'name': 'LED007',
      'status': false,
      'position': [-0.02, 0.17],
      'tile': 2,
    },
    {
      'location': 'Office 02',
      'name': 'LED008',
      'status': false,
      'position': [-0.33, 0.05],
      'tile': 3,
    },
  ];
}
