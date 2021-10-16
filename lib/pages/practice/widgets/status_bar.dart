import 'package:flashcards/cubits/practice_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF5D7D9A),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardNumber(),
              Timer(),
            ],
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 3,
            width: double.infinity,
            child: Progress(),
          )
        ],
      ),
    );
  }
}

class Timer extends StatelessWidget {
  const Timer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.timer,
          color: Color(0xFF157145),
        ),
        SizedBox(width: 4),
        Text(
          "88:88",
          style: TextStyle(color: Color(0xFFD1FAFF)),
        ),
      ],
    );
  }
}

class CardNumber extends StatelessWidget {
  const CardNumber({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        text: "Card 1",
        style: TextStyle(
          color: Color(0xFFD1FAFF),
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: " / 2",
            style: TextStyle(
              color: Color(0xFF157145),
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class Progress extends StatelessWidget {
  const Progress({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
            10,
            (_) => Container(
                  height: double.infinity,
                  width: (width * .7) / 10,
                  decoration: BoxDecoration(
                    color: Color(0xFF9BD1E5),
                    borderRadius: BorderRadius.circular(100),
                  ),
                )).toList(),
      );
    });
  }
}
