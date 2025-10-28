import 'package:flutter/material.dart';

/// 작은 로딩 위젯 (화면 일부용)
class LoadingWidget extends StatelessWidget {
  final double height;

  const LoadingWidget({
    super.key,
    this.height = 400,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}
