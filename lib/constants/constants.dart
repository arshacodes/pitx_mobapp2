// const String url = String.fromEnvironment(
//   'API_BASE_URL',
//   defaultValue: 'http://192.168.18.25:8000/api/v1',
// );


class AppConfig {
  static const String baseUrl =
      String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://192.168.18.25:8000/api/v1',
      );
}