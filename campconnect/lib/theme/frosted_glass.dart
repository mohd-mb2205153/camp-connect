import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedGlassBox extends StatelessWidget {
  final double boxWidth;
  final double? boxHeight;
  final Widget boxChild;
  final bool isCurved;

  const FrostedGlassBox({
    super.key,
    required this.boxWidth,
    this.boxHeight,
    required this.boxChild,
    this.isCurved = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(isCurved ? 15 : 0),
      child: Container(
        width: boxWidth,
        height: boxHeight,
        color: Colors.transparent,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      const Color.fromARGB(255, 198, 198, 198).withOpacity(0.3),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color.fromARGB(255, 118, 118, 118).withOpacity(0.1),
                    const Color.fromARGB(255, 118, 118, 118).withOpacity(0.1),
                  ],
                ),
              ),
              child: boxChild,
            ),
          ],
        ),
      ),
    );
  }
}

class FrostedGlassTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final Icon prefixIcon;
  final IconButton? suffixIcon;
  final TextInputType keyboardType;

  const FrostedGlassTextField({
    super.key,
    required this.controller,
    this.obscureText = false,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 60,
        color: Colors.transparent,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color:
                      const Color.fromARGB(255, 198, 198, 198).withOpacity(0.1),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color.fromARGB(255, 170, 170, 170).withOpacity(0.05),
                    const Color.fromARGB(255, 170, 170, 170).withOpacity(0.05),
                  ],
                ),
              ),
            ),
            Center(
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintText: hintText,
                  prefixIcon: prefixIcon,
                  suffixIcon: suffixIcon,
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
