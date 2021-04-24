import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const double preferedSize = 80;
  final String title;
  final Function() onAddFunction;

  MyAppBar({this.title, this.onAddFunction});

  @override
  Size get preferredSize => new Size.fromHeight(preferedSize);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Text(title),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom:
              new Radius.elliptical(MediaQuery.of(context).size.width, 120.0),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
            icon: Icon(
              Icons.add,
              size: 30,
            ),
            onPressed: () async => onAddFunction(),
          ),
        )
      ],
    );
  }
}
