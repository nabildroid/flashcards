import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -2),
            color: Colors.black12,
            blurRadius: 2,
            spreadRadius: .5,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Button(
            onPressed: () {},
            icon: Icons.star,
            label: "Favorit",
          ),
          Button(
            onPressed: () {},
            icon: Icons.shuffle,
            label: "Random",
          ),
          Button(
            onPressed: () {},
            icon: Icons.quiz_outlined,
            label: "Practice",
            autoFocus: true,
          ),
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  final IconData icon;
  final String label;
  final void Function() onPressed;
  final bool autoFocus;
  const Button({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.autoFocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      autofocus: autoFocus,
      onPressed: onPressed,
      label: Text(label),
      icon: Icon(icon),
      style: TextButton.styleFrom(
        primary: Colors.indigo,
      ),
    );
  }
}
