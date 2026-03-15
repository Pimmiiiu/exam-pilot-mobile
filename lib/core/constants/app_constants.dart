class AppConstants {
  AppConstants._();

  // Base URL – override via environment or flavour config
  static const String baseUrl = 'https://api.exampilot.com/v1';

  // Auth endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';

  // Exam endpoints
  static const String examsEndpoint = '/exams';

  // Results endpoint
  static const String resultsEndpoint = '/results';

  // Submit endpoint
  static const String submitEndpoint = '/exams/submit';

  // Secure storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  // Timeouts
  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 15000;
}
