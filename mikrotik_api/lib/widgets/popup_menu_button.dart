import 'package:flutter/material.dart';

class CustomPopupMenuButton extends StatelessWidget {
  final int initialValue;
  final Function(int) onSelected;

  const CustomPopupMenuButton({
    super.key,
    required this.initialValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      initialValue: initialValue,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<int>>[
          const PopupMenuItem<int>(
            value: 5,
            child: Text('Select 5'),
          ),
          const PopupMenuItem<int>(
            value: 10,
            child: Text('Select 10'),
          ),
          const PopupMenuItem<int>(
            value: 15,
            child: Text('Select 15'),
          ),
          const PopupMenuItem<int>(
            value: 20,
            child: Text('Select 20'),
          ),
          const PopupMenuItem<int>(
            value: 25,
            child: Text('Select 25'),
          ),
          const PopupMenuItem<int>(
            value: 30,
            child: Text('Select 30'),
          ),
          const PopupMenuItem<int>(
            value: 50,
            child: Text('Select 50'),
          ),
          const PopupMenuItem<int>(
            value: 75,
            child: Text('Select 75'),
          ),
          const PopupMenuItem<int>(
            value: 100,
            child: Text('Select 100'),
          ),
        ];
      },
    );
  }
}
