import 'package:example/widgets/loading_container.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/icon.png',
            errorBuilder: (_, __, ___) => Container(),
            height: 150,
          ),
          const SizedBox(
            height: 50,
          ),
          const LoadingContainer(
            color: Colors.white,
          ),
        ],
      ),
    ));
  }
}
