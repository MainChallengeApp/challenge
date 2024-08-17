enum EnvironmentEnum {
  dev(string: 'dev'),
  test(string: 'test'),
  prod(string: 'prod');

  final String string;

  const EnvironmentEnum({required this.string});

  factory EnvironmentEnum.fromString(String? status) {
    return EnvironmentEnum.values.firstWhere(
      (e) => e.string == status,
      orElse: () => EnvironmentEnum.dev,
    );
  }
}
