class Environment {
  // Get base URL from environment or use default
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:5000/api/v1',
  );

  // You can add more environment variables here
  static const String apiVersion = 'v1';

  static String get fullApiUrl => baseUrl;
}
