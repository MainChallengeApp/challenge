import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final List<Widget> children;

  const CustomCard({super.key, this.children = const []});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          height: 120 + 8 * 64,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(24))),
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  }
}
