class NotificationTypeIsNotSupportedException implements Exception {
  final String? type;

  const NotificationTypeIsNotSupportedException(this.type);

  @override
  String toString() {
    if (type == null) {
      return 'Notification type is not specified (type is null)';
    }
    return 'Notification type "$type" is not supported';
  }
}
