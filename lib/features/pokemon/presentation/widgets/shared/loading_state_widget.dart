import 'package:flutter/material.dart';

class LoadingStateWidget extends StatelessWidget {
  final Color backgroundColor;

  const LoadingStateWidget({
    super.key,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}
