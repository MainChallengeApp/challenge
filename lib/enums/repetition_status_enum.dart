import 'package:challenge/exceptions/repetition_status_is_not_supported_exception.dart';

enum RepetitionStatusEnum {
  success('success'),
  failed('failed'),
  inProgress('inProgress'),
  backlog('backlog');

  const RepetitionStatusEnum(this.status);

  final String status;

  static RepetitionStatusEnum fromString(String status) {
    return RepetitionStatusEnum.values.firstWhere(
      (element) => element.status == status,
      orElse: () => throw RepetitionStatusIsNotSupportedException(status),
    );
  }
}
