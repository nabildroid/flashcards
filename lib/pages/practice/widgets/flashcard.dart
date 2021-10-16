import 'package:auto_size_text_pk/auto_size_text_pk.dart';
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
      ),
      child: GestureDetector(
        onTap: flip,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedSlide(
                offset: !flipped ? Offset(0, 0) : Offset(0, 1),
                duration: Duration(milliseconds: 500),
                child: FlashcardFront(
                  widget.head,
                  color: Color(0xFF157145),
                ),
              ),
              AnimatedSlide(
                offset: flipped ? Offset(0, 0) : Offset(0, -1),
                duration: Duration(milliseconds: 500),
                child: FlashcardFront(
                  widget.tail,
                  color: Color(0xFF1C8E58),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FlashcardFront extends StatelessWidget {
  const FlashcardFront(
    this.text, {
    required this.color,
    Key? key,
  }) : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Material(
        color: color,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                height: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      color: Color(0xFFD1FAFF),
                      iconSize: 16,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit,
                      ),
                    ),
                    IconButton(
                      color: Color(0xFFD1FAFF),
                      iconSize: 16,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite_border,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: AutoSizeText(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
