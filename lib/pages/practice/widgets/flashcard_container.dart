import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';

class FlashcardContainer extends StatefulWidget {
  final String head;
  final String tail;

  final Future<bool> Function(bool favorit)? togglefavorit;
  final bool favorit;

  const FlashcardContainer({
    Key? key,
    required this.head,
    required this.tail,
    this.favorit = false,
    this.togglefavorit,
  }) : super(key: key);

  @override
  State<FlashcardContainer> createState() => _FlashcardContainerState();
}

class _FlashcardContainerState extends State<FlashcardContainer> {
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
                  favorit: widget.favorit,
                  togglefavorit: widget.togglefavorit,
                ),
              ),
              AnimatedSlide(
                offset: flipped ? Offset(0, 0) : Offset(0, -1),
                duration: Duration(milliseconds: 500),
                child: FlashcardFront(
                  widget.tail,
                  color: Color(0xFF1C8E58),
                  favorit: widget.favorit,
                  togglefavorit: widget.togglefavorit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FlashcardFront extends StatefulWidget {
  final Future<bool> Function(bool favorit)? togglefavorit;
  final bool favorit;

  const FlashcardFront(
    this.text, {
    required this.color,
    this.favorit = false,
    this.togglefavorit,
    Key? key,
  }) : super(key: key);

  final String text;
  final Color color;

  @override
  State<FlashcardFront> createState() => _FlashcardFrontState();
}

class _FlashcardFrontState extends State<FlashcardFront> {
  late bool favorit;

  @override
  void initState() {
    favorit = widget.favorit;
    super.initState();
  }

  toggleFavorit() async {
    final isFavorit = await widget.togglefavorit!(!favorit);
    setState(() {
      favorit = isFavorit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Material(
        color: widget.color,
        child: Column(
          children: [
            if (widget.togglefavorit != null)
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
                        onPressed: toggleFavorit,
                        icon: Icon(
                          favorit ? Icons.favorite : Icons.favorite_border,
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
                    widget.text,
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
