import 'package:flutter/material.dart';

class Flashcard extends StatefulWidget {
  final String head;
  final String tail;

  final bool isDemo;

  const Flashcard({
    Key? key,
    required this.head,
    required this.tail,
    this.isDemo = false,
  }) : super(key: key);

  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  bool flipped = false;

  void flip() {
    setState(() {
      flipped = !flipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 5,
            spreadRadius: 2,
            color: Colors.black12,
          )
        ],
      ),
      child: GestureDetector(
        onTap: flip,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedSlide(
                offset: flipped ? Offset(0, 0) : Offset(0, 1),
                duration: Duration(milliseconds: 500),
                child: Container(
                  color: Colors.green.shade700,
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: Text(
                      widget.tail,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedSlide(
                offset: !flipped ? Offset(0, 0) : Offset(0, -1),
                duration: Duration(milliseconds: 500),
                child: Container(
                  color: Colors.green,
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: Text(
                      widget.head,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
