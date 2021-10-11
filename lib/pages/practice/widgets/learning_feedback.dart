import 'package:flutter/material.dart';

class LearningFeedback extends StatelessWidget {
  final Function hard;
  final Function good;
  final Function easy;
  const LearningFeedback({
    Key? key,
    required this.hard,
    required this.good,
    required this.easy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: FeedbackButton(
              color: Colors.red,
              label: "Hard",
              onPressed: hard,
            ),
          ),
          Expanded(
            child: FeedbackButton(
              color: Colors.green,
              label: "Good",
              onPressed: good,
            ),
          ),
          Expanded(
            child: FeedbackButton(
              color: Colors.blueGrey,
              label: "easy",
              onPressed: easy,
            ),
          ),
        ],
      ),
    );
  }
}

class FeedbackButton extends StatelessWidget {
  final Function onPressed;
  final Color color;
  final String label;
  const FeedbackButton({
    Key? key,
    required this.onPressed,
    required this.color,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: color,
        primary: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      onPressed: () => onPressed(),
      child: Text(label),
    );
  }
}
