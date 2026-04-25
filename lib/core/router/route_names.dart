/// All route names for the app
class RouteNames {
  RouteNames._();

  // Auth
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String registration = 'registration';
  static const String forgotPassword = 'forgotPassword';
  static const String resetPassword = 'resetPassword';
  static const String termsConditions = 'termsConditions';

  // Customer Home
  static const String home = 'home';

  // Booking
  static const String bookLesson = 'bookLesson';
  static const String locationSelection = 'locationSelection';
  static const String fixedSlotCalendar = 'fixedSlotCalendar';
  static const String extraLessonCalendar = 'extraLessonCalendar';
  static const String extraLessonLocation = 'extraLessonLocation';
  static const String calendarAvailable = 'calendarAvailable';
  static const String holidayLessons = 'holidayLessons';
  static const String bookingSummary = 'bookingSummary';
  static const String bookingSuccess = 'bookingSuccess';
  static const String cancellationConfirm = 'cancellationConfirm';

  // Reservations
  static const String myReservations = 'myReservations';
  static const String reservationDetail = 'reservationDetail';
  static const String reservationsPlanned = 'reservationsPlanned';

  // Punch Cards
  static const String myPunchCards = 'myPunchCards';
  static const String punchCardDetail = 'punchCardDetail';
  static const String purchasePunchCard = 'purchasePunchCard';
  static const String allPunchCardPrices = 'allPunchCardPrices';
  static const String confirmOrder = 'confirmOrder';
  static const String specialPunchCards = 'specialPunchCards';

  // Progress
  static const String childProgress = 'childProgress';
  static const String skillDetail = 'skillDetail';
  static const String practiceAtHome = 'practiceAtHome';
  static const String zwemdiplom = 'zwemdiplom';

  // Payment
  static const String paymentMethod = 'paymentMethod';
  static const String stripePayment = 'stripePayment';
  static const String paymentHistory = 'paymentHistory';
  static const String invoiceReceipt = 'invoiceReceipt';

  // Chat
  static const String chatList = 'chatList';
  static const String chat = 'chat';

  // Waitlist
  static const String joinWaitlist = 'joinWaitlist';
  static const String waitlistStatus = 'waitlistStatus';
  static const String waitlistInvitation = 'waitlistInvitation';
  static const String availabilityRequest = 'availabilityRequest';

  // Notifications
  static const String notifications = 'notifications';
  static const String notificationSettings = 'notificationSettings';

  // FAQ
  static const String faq = 'faq';
  static const String faqDetail = 'faqDetail';

  // Profile
  static const String profile = 'profile';
  static const String editProfile = 'editProfile';
  static const String addEditChild = 'addEditChild';
  static const String emergencyContacts = 'emergencyContacts';

  // Schedule (Walter 2026-04-22 fixed-schedule + slot-interest)
  static const String slotInterest = 'slotInterest';
  static const String slotOffers = 'slotOffers';
  static const String examContinuation = 'examContinuation';

  // Misc
  static const String contactScreen = 'contactScreen';
  static const String reviewsScreen = 'reviewsScreen';
  static const String autoConversion = 'autoConversion';
  static const String aboutUs = 'aboutUs';
  static const String offlineMode = 'offlineMode';

  /// Path helpers — use when you need the raw path (e.g. for context.push)
  /// rather than the named route.
  static const String pathHome = '/home';
  static const String pathBook = '/book';
  static const String pathCards = '/cards';
  static const String pathProfile = '/profile';
  static const String pathLogin = '/login';
  static const String pathInstructorHome = '/instructor/home';

  // Instructor
  static const String instructorHome = 'instructorHome';
  static const String instructorSchedule = 'instructorSchedule';
  static const String instructorStudents = 'instructorStudents';
  static const String instructorChatList = 'instructorChatList';
  static const String instructorChat = 'instructorChat';
  static const String instructorProfile = 'instructorProfile';
  static const String lessonDetail = 'lessonDetail';
  static const String progressUpdate = 'progressUpdate';
  static const String instructorAvailability = 'instructorAvailability';
  static const String instructorNotifications = 'instructorNotifications';
}
