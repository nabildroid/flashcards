import 'package:flutter/material.dart';

class Sources extends StatelessWidget {
  const Sources({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        // todo implement sources => add icons of Notion, Pocket, Twitter ..
        // Icon(Icons.sync, color: Colors.black),
        // Icon(Icons.sync, color: Colors.black),
        // Icon(Icons.sync, color: Colors.black),
      ],
    );
  }
}

class TextLogo extends StatelessWidget {
  const TextLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.headline6?.copyWith(
              letterSpacing: 0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
        children: const [
          TextSpan(
              text: "U",
              style: TextStyle(
                color: Colors.indigo,
              )),
          TextSpan(text: "nfair "),
          TextSpan(
              text: "A",
              style: TextStyle(
                color: Colors.indigo,
              )),
          TextSpan(text: "dvantage"),
        ],
      ),
    );
  }
}
