import 'package:flutter/material.dart';

class PracticeTile2 extends StatelessWidget {
  final String title;
  final String backGroundImage;
  final VoidCallback onTap;

  const PracticeTile2({
    super.key,
    required this.title,
    required this.backGroundImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(backGroundImage, fit: BoxFit.fill),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 26, 0, 16),
                    color: Colors.black.withOpacity(0.50),
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
