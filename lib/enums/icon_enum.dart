import 'package:flutter/material.dart';

enum IconEnum {
  progress(Icons.bolt_rounded),
  delete(Icons.delete),
  newChallenge(Icons.add_rounded),
  shuffle(Icons.shuffle_rounded),
  search(Icons.search_rounded),
  edit(Icons.edit_rounded),
  user(Icons.person_rounded),
  email(Icons.email_rounded),
  password(Icons.password_rounded),
  bio(Icons.notes_rounded),
  username(Icons.alternate_email_rounded),
  picture(Icons.image_rounded),
  upload(Icons.upload_rounded),
  remove(Icons.highlight_remove_rounded),
  info(Icons.info_outline_rounded),
  settings(Icons.settings_outlined),
  inbox(Icons.inbox_outlined),
  connect(Icons.group_add_rounded),
  disconnect(Icons.group_remove_rounded),
  openRequests(Icons.outbox_rounded),
  openResponses(Icons.move_to_inbox_rounded),
  ;

  const IconEnum(this.icon);

  final IconData icon;
}
