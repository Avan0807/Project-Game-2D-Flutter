import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String imagePath;
  const CustomButton({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      width: 142,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
        ),
      ),
    );
  }
}
