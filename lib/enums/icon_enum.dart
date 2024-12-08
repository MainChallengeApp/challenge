import 'package:flutter/material.dart';

enum IconEnum {
  add(Icons.add_rounded),
  arrowDown(Icons.keyboard_arrow_down_rounded),
  arrowRight(Icons.keyboard_arrow_right_rounded),
  bio(Icons.notes_rounded),
  blockedUsers(Icons.block_rounded),
  camera(Icons.camera_alt_outlined),
  connect(Icons.group_add_rounded),
  credits(Icons.handshake_outlined),
  delete(Icons.delete),
  disconnect(Icons.group_remove_rounded),
  edit(Icons.edit_outlined),
  email(Icons.email_rounded),
  feedback(Icons.feedback_outlined),
  groupChallenge(Icons.groups_rounded),
  inbox(Icons.inbox_outlined),
  info(Icons.info_outline_rounded),
  logout(Icons.logout_rounded),
  more(Icons.more_horiz_rounded),
  newChallenge(Icons.add_rounded),
  notification(Icons.notifications_outlined),
  openRequests(Icons.outbox_rounded),
  openResponses(Icons.move_to_inbox_rounded),
  password(Icons.password_rounded),
  picture(Icons.image_rounded),
  progress(Icons.bolt_rounded),
  recent(Icons.history_rounded),
  remove(Icons.highlight_remove_rounded),
  removeFullCircle(Icons.cancel_rounded),
  reportUser(Icons.report_gmailerrorred_rounded),
  search(Icons.search_rounded),
  select(Icons.check_rounded),
  settings(Icons.settings_outlined),
  shuffle(Icons.shuffle_rounded),
  upload(Icons.upload_rounded),
  user(Icons.person_rounded),
  username(Icons.alternate_email_rounded),
  ;

  const IconEnum(this.icon);

  final IconData icon;
}
