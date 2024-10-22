import 'package:flutter/material.dart';

enum IconEnum {
  bio(Icons.notes_rounded),
  blockedUsers(Icons.block_rounded),
  connect(Icons.group_add_rounded),
  delete(Icons.delete),
  disconnect(Icons.group_remove_rounded),
  edit(Icons.edit_rounded),
  email(Icons.email_rounded),
  inbox(Icons.inbox_outlined),
  info(Icons.info_outline_rounded),
  more(Icons.more_horiz_rounded),
  newChallenge(Icons.add_rounded),
  openRequests(Icons.outbox_rounded),
  openResponses(Icons.move_to_inbox_rounded),
  password(Icons.password_rounded),
  picture(Icons.image_rounded),
  progress(Icons.bolt_rounded),
  remove(Icons.highlight_remove_rounded),
  reportUser(Icons.report_gmailerrorred_rounded),
  search(Icons.search_rounded),
  settings(Icons.settings_outlined),
  shuffle(Icons.shuffle_rounded),
  upload(Icons.upload_rounded),
  user(Icons.person_rounded),
  username(Icons.alternate_email_rounded),
  ;

  const IconEnum(this.icon);

  final IconData icon;
}
