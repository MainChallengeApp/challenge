import 'package:flutter/material.dart';

enum IconEnum {
  progress(Icons.bolt_rounded),
  delete(Icons.delete),
  newChallenge(Icons.add_rounded),
  shuffle(Icons.shuffle_rounded);

  const IconEnum(this.icon);

  final IconData icon;
}
