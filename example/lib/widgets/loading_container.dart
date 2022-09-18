import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  final double? size;
  final Color? color;

  const LoadingContainer({Key? key, this.size, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      height: size,
      width: size,
      child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation(color),
      ),
    ));
  }
}
