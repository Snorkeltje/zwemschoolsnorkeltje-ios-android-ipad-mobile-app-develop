import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
// Auth
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/registration_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/terms_conditions_screen.dart';
// Home
import '../../features/home/presentation/screens/home_screen.dart';
// Booking
import '../../features/booking/presentation/screens/booking_type_screen.dart';
import '../../features/booking/presentation/screens/book_lesson_screen.dart';
import '../../features/booking/presentation/screens/fixed_slot_calendar_screen.dart';
import '../../features/booking/presentation/screens/extra_lesson_calendar_screen.dart';
import '../../features/booking/presentation/screens/holiday_lessons_screen.dart';
import '../../features/booking/presentation/screens/location_selection_screen.dart';
import '../../features/booking/presentation/screens/booking_summary_screen.dart';
import '../../features/booking/presentation/screens/booking_success_screen.dart';
import '../../features/booking/presentation/screens/my_reservations_screen.dart';
import '../../features/booking/presentation/screens/reservation_detail_screen.dart';
import '../../features/booking/presentation/screens/cancellation_confirm_screen.dart';
import '../../features/booking/presentation/screens/auto_conversion_screen.dart';
import '../../features/booking/presentation/screens/reservations_planned_screen.dart';
// Punch Cards
import '../../features/punch_card/presentation/screens/my_punch_cards_screen.dart';
import '../../features/punch_card/presentation/screens/punch_card_detail_screen.dart';
import '../../features/punch_card/presentation/screens/punch_card_order_screen.dart';
import '../../features/punch_card/presentation/screens/all_punch_card_prices_screen.dart';
import '../../features/punch_card/presentation/screens/confirm_order_screen.dart';
import '../../features/punch_card/presentation/screens/purchase_punch_card_screen.dart';
import '../../features/punch_card/presentation/screens/special_punch_cards_screen.dart';
// Student Progress
import '../../features/student_progress/presentation/screens/child_progress_screen.dart';
import '../../features/student_progress/presentation/screens/skill_detail_screen.dart';
import '../../features/student_progress/presentation/screens/practice_at_home_screen.dart';
import '../../features/student_progress/presentation/screens/zwemdiplom_screen.dart';
// Profile
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/add_edit_child_screen.dart';
import '../../features/profile/presentation/screens/emergency_contact_screen.dart';
import '../../features/profile/presentation/screens/about_us_screen.dart';
import '../../features/profile/presentation/screens/contact_screen.dart';
import '../../features/profile/presentation/screens/reviews_screen.dart';
// Payment
import '../../features/payment/presentation/screens/payment_method_screen.dart';
import '../../features/payment/presentation/screens/payment_history_screen.dart';
import '../../features/payment/presentation/screens/stripe_payment_screen.dart';
import '../../features/payment/presentation/screens/invoice_receipt_screen.dart';
// Chat
import '../../features/chat/presentation/screens/chat_list_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
// FAQ
import '../../features/faq/presentation/screens/faq_screen.dart';
import '../../features/faq/presentation/screens/faq_detail_screen.dart';
// Notifications
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/notifications/presentation/screens/notification_screen.dart';
import '../../features/notifications/presentation/screens/notification_settings_screen.dart';
// Waitlist
import '../../features/waitlist/presentation/screens/waitlist_screen.dart';
import '../../features/waitlist/presentation/screens/waitlist_status_screen.dart';
import '../../features/waitlist/presentation/screens/waitlist_invitation_screen.dart';
// Instructor
import '../../features/instructor/presentation/screens/instructor_home_screen.dart';
import '../../features/instructor/presentation/screens/instructor_schedule_screen.dart';
import '../../features/instructor/presentation/screens/instructor_students_screen.dart';
import '../../features/instructor/presentation/screens/instructor_chat_list_screen.dart';
import '../../features/instructor/presentation/screens/instructor_chat_screen.dart';
import '../../features/instructor/presentation/screens/instructor_profile_screen.dart';
import '../../features/instructor/presentation/screens/progress_update_screen.dart';
import '../../features/instructor/presentation/screens/monthly_report_screen.dart';
import '../../features/instructor/presentation/screens/offline_mode_screen.dart';
import '../../features/instructor/presentation/screens/availability_request_screen.dart';
import '../../features/instructor/presentation/screens/instructor_notifications_screen.dart';
import '../../features/instructor/presentation/widgets/instructor_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // === AUTH ROUTES ===
      GoRoute(
        path: '/',
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: RouteNames.registration,
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        name: RouteNames.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/terms-conditions',
        name: RouteNames.termsConditions,
        builder: (context, state) => const TermsConditionsScreen(),
      ),

      // === MAIN APP (with bottom nav shell) ===
      ShellRoute(
        builder: (context, state, child) {
          return ScaffoldWithBottomNav(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: RouteNames.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/book',
            name: RouteNames.bookLesson,
            builder: (context, state) => const BookingTypeScreen(),
          ),
          GoRoute(
            path: '/cards',
            name: RouteNames.myPunchCards,
            builder: (context, state) => const MyPunchCardsScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: RouteNames.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // === BOOKING FLOW ===
      GoRoute(
        path: '/booking/lesson-type',
        builder: (context, state) => const BookLessonScreen(),
      ),
      GoRoute(
        path: '/booking/location',
        name: RouteNames.locationSelection,
        builder: (context, state) => const LocationSelectionScreen(),
      ),
      GoRoute(
        path: '/booking/fixed-slot',
        name: RouteNames.fixedSlotCalendar,
        builder: (context, state) => const FixedSlotCalendarScreen(),
      ),
      GoRoute(
        path: '/booking/extra-lesson',
        name: RouteNames.extraLessonCalendar,
        builder: (context, state) => const ExtraLessonCalendarScreen(),
      ),
      GoRoute(
        path: '/booking/holiday',
        name: RouteNames.holidayLessons,
        builder: (context, state) => const HolidayLessonsScreen(),
      ),
      GoRoute(
        path: '/booking/summary',
        name: RouteNames.bookingSummary,
        builder: (context, state) => const BookingSummaryScreen(),
      ),
      GoRoute(
        path: '/booking/success',
        name: RouteNames.bookingSuccess,
        builder: (context, state) => const BookingSuccessScreen(),
      ),

      // === RESERVATIONS ===
      GoRoute(
        path: '/reservations',
        name: RouteNames.myReservations,
        builder: (context, state) => const MyReservationsScreen(),
      ),
      GoRoute(
        path: '/reservation/:id',
        name: RouteNames.reservationDetail,
        builder: (context, state) => const ReservationDetailScreen(),
      ),
      GoRoute(
        path: '/reservations-planned',
        name: RouteNames.reservationsPlanned,
        builder: (context, state) => const ReservationsPlannedScreen(),
      ),
      GoRoute(
        path: '/cancellation-confirm',
        name: RouteNames.cancellationConfirm,
        builder: (context, state) => const CancellationConfirmScreen(),
      ),
      GoRoute(
        path: '/auto-conversion',
        name: RouteNames.autoConversion,
        builder: (context, state) => const AutoConversionScreen(),
      ),

      // === PUNCH CARDS ===
      GoRoute(
        path: '/punch-card/:id',
        name: RouteNames.punchCardDetail,
        builder: (context, state) => const PunchCardDetailScreen(),
      ),
      GoRoute(
        path: '/punch-card-order',
        name: RouteNames.purchasePunchCard,
        builder: (context, state) => const PunchCardOrderScreen(),
      ),
      GoRoute(
        path: '/purchase-punch-card',
        builder: (context, state) => const PurchasePunchCardScreen(),
      ),
      GoRoute(
        path: '/all-punch-card-prices',
        name: RouteNames.allPunchCardPrices,
        builder: (context, state) => const AllPunchCardPricesScreen(),
      ),
      GoRoute(
        path: '/confirm-order',
        name: RouteNames.confirmOrder,
        builder: (context, state) => const ConfirmOrderScreen(),
      ),
      GoRoute(
        path: '/special-punch-cards',
        name: RouteNames.specialPunchCards,
        builder: (context, state) => const SpecialPunchCardsScreen(),
      ),

      // === STUDENT PROGRESS ===
      GoRoute(
        path: '/child-progress',
        name: RouteNames.childProgress,
        builder: (context, state) => const ChildProgressScreen(),
      ),
      GoRoute(
        path: '/skill-detail',
        name: RouteNames.skillDetail,
        builder: (context, state) => const SkillDetailScreen(),
      ),
      GoRoute(
        path: '/practice-at-home',
        name: RouteNames.practiceAtHome,
        builder: (context, state) => const PracticeAtHomeScreen(),
      ),
      GoRoute(
        path: '/zwemdiplom',
        name: RouteNames.zwemdiplom,
        builder: (context, state) => const ZwemdiplomScreen(),
      ),

      // === PAYMENT ===
      GoRoute(
        path: '/payment-method',
        name: RouteNames.paymentMethod,
        builder: (context, state) => const PaymentMethodScreen(),
      ),
      GoRoute(
        path: '/payment-history',
        name: RouteNames.paymentHistory,
        builder: (context, state) => const PaymentHistoryScreen(),
      ),
      GoRoute(
        path: '/stripe-payment',
        name: RouteNames.stripePayment,
        builder: (context, state) => const StripePaymentScreen(),
      ),
      GoRoute(
        path: '/invoice/:id',
        name: RouteNames.invoiceReceipt,
        builder: (context, state) => const InvoiceReceiptScreen(),
      ),

      // === CHAT ===
      GoRoute(
        path: '/chat-list',
        name: RouteNames.chatList,
        builder: (context, state) => const ChatListScreen(),
      ),
      GoRoute(
        path: '/chat/:id',
        name: RouteNames.chat,
        builder: (context, state) => ChatScreen(
          chatId: state.pathParameters['id'] ?? '1',
        ),
      ),

      // === FAQ ===
      GoRoute(
        path: '/faq',
        name: RouteNames.faq,
        builder: (context, state) => const FaqScreen(),
      ),
      GoRoute(
        path: '/faq/:id',
        name: RouteNames.faqDetail,
        builder: (context, state) => FaqDetailScreen(
          faqId: state.pathParameters['id'] ?? '1',
        ),
      ),

      // === NOTIFICATIONS ===
      GoRoute(
        path: '/notifications',
        name: RouteNames.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/notification/:id',
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: '/notification-settings',
        name: RouteNames.notificationSettings,
        builder: (context, state) => const NotificationSettingsScreen(),
      ),

      // === WAITLIST ===
      GoRoute(
        path: '/waitlist',
        name: RouteNames.joinWaitlist,
        builder: (context, state) => const WaitlistScreen(),
      ),
      GoRoute(
        path: '/waitlist-status',
        name: RouteNames.waitlistStatus,
        builder: (context, state) => const WaitlistStatusScreen(),
      ),
      GoRoute(
        path: '/waitlist-invitation',
        name: RouteNames.waitlistInvitation,
        builder: (context, state) => const WaitlistInvitationScreen(),
      ),

      // === PROFILE DETAILS ===
      GoRoute(
        path: '/edit-profile',
        name: RouteNames.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/add-child',
        name: RouteNames.addEditChild,
        builder: (context, state) => const AddEditChildScreen(),
      ),
      GoRoute(
        path: '/emergency-contacts',
        name: RouteNames.emergencyContacts,
        builder: (context, state) => const EmergencyContactScreen(),
      ),
      GoRoute(
        path: '/about-us',
        name: RouteNames.aboutUs,
        builder: (context, state) => const AboutUsScreen(),
      ),
      GoRoute(
        path: '/contact-us',
        name: RouteNames.contactScreen,
        builder: (context, state) => const ContactScreen(),
      ),
      GoRoute(
        path: '/reviews',
        name: RouteNames.reviewsScreen,
        builder: (context, state) => const ReviewsScreen(),
      ),

      // === INSTRUCTOR (shell — bottom nav) ===
      ShellRoute(
        builder: (context, state, child) => InstructorShell(child: child),
        routes: [
          GoRoute(
            path: '/instructor/home',
            name: RouteNames.instructorHome,
            builder: (context, state) => const InstructorHomeScreen(),
          ),
          GoRoute(
            path: '/instructor/schedule',
            name: RouteNames.instructorSchedule,
            builder: (context, state) => const InstructorScheduleScreen(),
          ),
          GoRoute(
            path: '/instructor/students',
            name: RouteNames.instructorStudents,
            builder: (context, state) => const InstructorStudentsScreen(),
          ),
          GoRoute(
            path: '/instructor/chat-list',
            name: RouteNames.instructorChatList,
            builder: (context, state) => const InstructorChatListScreen(),
          ),
          GoRoute(
            path: '/instructor/profile',
            name: RouteNames.instructorProfile,
            builder: (context, state) => const InstructorProfileScreen(),
          ),
        ],
      ),
      // === INSTRUCTOR (non-shell — full-screen detail routes) ===
      GoRoute(
        path: '/instructor/chat/:id',
        name: RouteNames.instructorChat,
        builder: (context, state) => InstructorChatScreen(
          chatId: state.pathParameters['id'] ?? '1',
        ),
      ),
      GoRoute(
        path: '/instructor/progress-update/:studentInitial',
        name: RouteNames.progressUpdate,
        builder: (context, state) => ProgressUpdateScreen(
          studentInitial: state.pathParameters['studentInitial'] ?? '',
        ),
      ),
      GoRoute(
        path: '/instructor/monthly-report',
        builder: (context, state) => const MonthlyReportScreen(),
      ),
      GoRoute(
        path: '/instructor/availability',
        name: RouteNames.instructorAvailability,
        builder: (context, state) => const AvailabilityRequestScreen(),
      ),
      GoRoute(
        path: '/instructor/notifications',
        name: RouteNames.instructorNotifications,
        builder: (context, state) => const InstructorNotificationsScreen(),
      ),
      GoRoute(
        path: '/offline-mode',
        name: RouteNames.offlineMode,
        builder: (context, state) => const OfflineModeScreen(),
      ),
      GoRoute(
        path: '/availability-request',
        name: RouteNames.availabilityRequest,
        builder: (context, state) => const AvailabilityRequestScreen(),
      ),
    ],
  );
});

/// Bottom navigation shell for main app screens
class ScaffoldWithBottomNav extends StatelessWidget {
  final Widget child;

  const ScaffoldWithBottomNav({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Thuis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Boeken',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card_outlined),
            activeIcon: Icon(Icons.credit_card),
            label: 'Kaarten',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profiel',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/book')) return 1;
    if (location.startsWith('/cards')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed(RouteNames.home);
        break;
      case 1:
        context.goNamed(RouteNames.bookLesson);
        break;
      case 2:
        context.goNamed(RouteNames.myPunchCards);
        break;
      case 3:
        context.goNamed(RouteNames.profile);
        break;
    }
  }
}
