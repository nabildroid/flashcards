import 'package:flutter/material.dart';

import 'feedback_button.dart';

class LearningFeedback extends StatelessWidget {
  final Function hard;
  final Function good;
  final Function easy;
  final bool enabled;
  const LearningFeedback({
    Key? key,
    required this.hard,
    required this.good,
    required this.easy,
    required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FeedbackButton(
            colors: [Color(0xFFEF668F), Color(0xFFEF4848)],
            label: "forget",
            onPressed: hard,
            enabled: enabled,
          ),
          FeedbackButton(
            colors: [Color(0xFF50A888), Color(0xFF41A430)],
            label: "almost",
            onPressed: good,
            enabled: enabled,
          ),
          FeedbackButton(
            colors: [Color(0xFF3FCEBD), Color(0xFF00A2C6)],
            label: "done",
            onPressed: easy,
            enabled: enabled,
          ),
        ],
      ),
    );
  }
}
