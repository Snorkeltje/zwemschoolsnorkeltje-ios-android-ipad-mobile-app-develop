/// API configuration constants
class ApiConstants {
  ApiConstants._();

  // Base URL - will be configured per environment
  static const String baseUrl = 'https://api.zwemschoolsnorkeltje.nl';
  static const String apiVersion = '/api/v1';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // User endpoints
  static const String profile = '/users/me';
  static const String updateProfile = '/users/me';
  static const String children = '/users/me/children';

  // Booking endpoints
  static const String locations = '/locations';
  static const String timeSlots = '/time-slots';
  static const String bookings = '/bookings';
  static const String myBookings = '/bookings/my';

  // Payment endpoints
  static const String payments = '/payments';
  static const String createPaymentIntent = '/payments/create-intent';

  // Punch card endpoints
  static const String punchCards = '/punch-cards';
  static const String purchasePunchCard = '/punch-cards/purchase';

  // Progress endpoints
  static const String progress = '/progress';
  static const String practiceExercises = '/progress/exercises';

  // Waitlist endpoints
  static const String waitlist = '/waitlist';
  static const String waitlistInvitation = '/waitlist/invitation';

  // Chat endpoints
  static const String messages = '/messages';
  static const String conversations = '/messages/conversations';

  // Notification endpoints
  static const String notifications = '/notifications';
  static const String registerDevice = '/notifications/register-device';

  // FAQ endpoints
  static const String faq = '/faq';

  // Instructor endpoints
  static const String instructorSchedule = '/instructor/schedule';
  static const String instructorProgress = '/instructor/progress';

  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
