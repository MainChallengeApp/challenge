import 'package:flutter/material.dart';

enum IconEnum {
  progress(Icons.bolt_rounded),
  delete(Icons.delete),
  newChallenge(Icons.add_rounded),
  shuffle(Icons.shuffle_rounded),
  search(Icons.search_rounded),
  edit(Icons.edit_rounded),
  profile(Icons.person_rounded),
  email(Icons.email_rounded),
  password(Icons.password_rounded),
  bio(Icons.notes_rounded),
  username(Icons.alternate_email_rounded),
  picture(Icons.image_rounded),
  ;

  const IconEnum(this.icon);

  final IconData icon;
}
