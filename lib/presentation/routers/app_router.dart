import 'package:flutter/material.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/cardsAndFundManagement/index.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/screens/common/set_password.dart';
import 'package:investnation/presentation/screens/dashboardAndVerifications/applicationDetails/index.dart';
import 'package:investnation/presentation/screens/dashboardAndVerifications/kyc/index.dart';
import 'package:investnation/presentation/screens/dashboardAndVerifications/riskProfiling/index.dart';
import 'package:investnation/presentation/screens/dashboardAndVerifications/riskProfiling/results.dart';
import 'package:investnation/presentation/screens/investmentCreation/index.dart';
import 'package:investnation/presentation/screens/onboarding/initialOnboarding/biometric.dart';
import 'package:investnation/presentation/screens/redeemAndTopUp/index.dart';
import 'package:investnation/presentation/screens/referAndEarn/index.dart';
import 'package:investnation/presentation/screens/onboarding/initialOnboarding/index.dart';
import 'package:investnation/presentation/screens/userProfileAndSettings/index.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case Routes.onboarding:
        return MaterialPageRoute(
          builder: (_) => const StoriesPage(),
        );
      case Routes.biometric:
        return MaterialPageRoute(
          builder: (_) => const BiometricScreens(),
        );
      case Routes.registration:
        return MaterialPageRoute(
          builder: (_) => RegistrationScreen(
            argument: args,
          ),
        );
      case Routes.otp:
        return MaterialPageRoute(
          builder: (_) => OTPScreen(
            argument: args,
          ),
        );
      case Routes.dashboard:
        return MaterialPageRoute(
          builder: (_) => DashboardScreen(
            argument: args,
          ),
        );
      case Routes.profileHome:
        return MaterialPageRoute(
          builder: (_) => ProfileHomeScreen(
            argument: args,
          ),
        );
      case Routes.profileEdit:
        return MaterialPageRoute(
          builder: (_) => ProfileEditScreen(
            argument: args,
          ),
        );
      case Routes.security:
        return MaterialPageRoute(
          builder: (_) => const SecurityScreen(),
        );
      case Routes.setPassword:
        return MaterialPageRoute(
          builder: (_) => SetPasswordScreen(
            argument: args,
          ),
        );
      case Routes.faq:
        return MaterialPageRoute(
          builder: (_) => const FaqScreen(),
        );
      case Routes.documents:
        return MaterialPageRoute(
          builder: (_) => const DocumentsScreen(),
        );
      case Routes.statements:
        return MaterialPageRoute(
          builder: (_) => const StatementsScreen(),
        );
      case Routes.portfolioStatements:
        return MaterialPageRoute(
          builder: (_) => const PortfolioStatementScreen(),
        );
      case Routes.cardManagement:
        return MaterialPageRoute(
          builder: (_) => const CardManagementScreen(),
        );
      case Routes.referralDetails:
        return MaterialPageRoute(
          builder: (_) => const ReferralDetailsScreen(),
        );
      case Routes.loginUserId:
        return MaterialPageRoute(
          builder: (_) => LoginUserIdScreen(
            argument: args,
          ),
        );
      case Routes.uaePass:
        return MaterialPageRoute(
          builder: (_) => const WebViewUaePass(),
          // const UaePassScreen(),
        );
      case Routes.notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationsScreen(),
        );
      case Routes.exploreDashboard:
        return MaterialPageRoute(
          builder: (_) => const ExploreDashboardScreen(),
        );
      case Routes.createPassword:
        return MaterialPageRoute(
          builder: (_) => CreatePasswordScreen(
            argument: args,
          ),
        );
      case Routes.changePassword:
        return MaterialPageRoute(
          builder: (_) => const ChangePasswordScreen(),
        );
      case Routes.preRiskProfiling:
        return MaterialPageRoute(
          builder: (_) => const PreRiskProfileScreen(),
        );
      case Routes.preEid:
        return MaterialPageRoute(
          builder: (_) => const PreEidScreen(),
        );
      case Routes.pendingStatus:
        return MaterialPageRoute(
          builder: (_) => const PendingStatusScreen(),
        );
      case Routes.eidExplanation:
        return MaterialPageRoute(
          builder: (_) => EidExplanationScreen(
            argument: args,
          ),
        );
      case Routes.scannedDetails:
        return MaterialPageRoute(
          builder: (_) => ScannedDetailsScreen(
            argument: args,
          ),
        );
      case Routes.verificationInit:
        return MaterialPageRoute(
          builder: (_) => VerificationInitializingScreen(
            argument: args,
          ),
        );
      case Routes.errorSuccess:
        return MaterialPageRoute(
          builder: (_) => ErrorSuccessScreen(
            argument: args,
          ),
        );
      case Routes.verifyMobile:
        return MaterialPageRoute(
          builder: (_) => VerifyMobileScreen(
            argument: args,
          ),
        );
      case Routes.notAvailable:
        return MaterialPageRoute(
          builder: (_) => NotAvaiableScreen(
            argument: args,
          ),
        );
      case Routes.applicationAddress:
        return MaterialPageRoute(
          builder: (_) => const ApplicationAddressScreen(),
        );
      case Routes.applicationIncome:
        return MaterialPageRoute(
          builder: (_) => const ApplicationIncomeScreen(),
        );
      case Routes.applicationTaxFatca:
        return MaterialPageRoute(
          builder: (_) => const ApplicationTaxFATCAScreen(),
        );
      case Routes.applicationTaxCrs:
        return MaterialPageRoute(
          builder: (_) => ApplicationTaxCrsScreen(
            argument: args,
          ),
        );
      case Routes.addFunds:
        return MaterialPageRoute(
          builder: (_) => const AddFundsScreen(),
        );
      case Routes.transferOutList:
        return MaterialPageRoute(
          builder: (_) => TransferOutListScreen(
            argument: args,
          ),
        );
      case Routes.transferOutDetails:
        return MaterialPageRoute(
          builder: (_) => TransferOutDetailsScreen(
            argument: args,
          ),
        );
      case Routes.transferTransactionDetails:
        return MaterialPageRoute(
          builder: (_) => TransferTransactionDetailsScreen(
            argument: args,
          ),
        );
      case Routes.transferOutBeneficiary:
        return MaterialPageRoute(
          builder: (_) => const AddBeneficiaryScreen(),
        );
      case Routes.investmentZone:
        return MaterialPageRoute(
          builder: (_) => InvestmentZoneScreen(
            argument: args,
          ),
        );
      case Routes.plan:
        return MaterialPageRoute(
          builder: (_) => PlanScreen(
            argument: args,
          ),
        );
      case Routes.forecast:
        return MaterialPageRoute(
          builder: (_) => ForecastScreen(
            argument: args,
          ),
        );
      case Routes.invest:
        return MaterialPageRoute(
          builder: (_) => InvestScreen(
            argument: args,
          ),
        );
      case Routes.secondaryEmail:
        return MaterialPageRoute(
          builder: (_) => UpdateSecondaryEmailScreen(
            argument: args,
          ),
        );
      case Routes.investmentConfirmation:
        return MaterialPageRoute(
          builder: (_) => InvestmentConfirmationScreen(
            argument: args,
          ),
        );
      case Routes.transactionDetails:
        return MaterialPageRoute(
          builder: (_) => TransactionDetails(
            argument: args,
          ),
        );
      case Routes.factSheet:
        return MaterialPageRoute(
          builder: (_) => const FactSheetScreen(),
        );
      case Routes.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
        );
      case Routes.acceptTermsAndConditions:
        return MaterialPageRoute(
          builder: (_) => const AcceptTermsAndConditionsScreen(),
        );
      case Routes.rtPortfolio:
        return MaterialPageRoute(
          builder: (_) => const RTPortfolioScreen(),
        );
      case Routes.securityAlloc:
        return MaterialPageRoute(
          builder: (_) => SecurityAllocationScreen(
            argument: args,
          ),
        );
      case Routes.redeem:
        return MaterialPageRoute(
          builder: (_) => const RedeemScreen(),
        );
      case Routes.redemptionConfirmation:
        return MaterialPageRoute(
          builder: (_) => const RedemptionConfirmationScreen(),
        );
      case Routes.redemptionSuccess:
        return MaterialPageRoute(
          builder: (_) => RedemptionSuccessScreen(
            argument: args,
          ),
        );
      case Routes.redemptionDetails:
        return MaterialPageRoute(
          builder: (_) => RedemptionDetailsScreen(
            argument: args,
          ),
        );
      case Routes.termsAndConditions:
        return MaterialPageRoute(
          builder: (_) => const TermsAndConditionsScreen(),
        );
      case Routes.privacyStatement:
        return MaterialPageRoute(
          builder: (_) => const PrivacyStatementScreen(),
        );
      case Routes.transactionSucess:
        return MaterialPageRoute(
          builder: (_) => TransactionSuccessScreen(
            argument: args,
          ),
        );
      case Routes.investmentSuccess:
        return MaterialPageRoute(
          builder: (_) => InvestmentSuccessScreen(
            argument: args,
          ),
        );
      case Routes.riskProfiling:
        return MaterialPageRoute(
          builder: (_) => RiskProfilingScreen(
            argument: args,
          ),
        );
      case Routes.riskProfileQuestionnaire:
        return MaterialPageRoute(
          builder: (_) => RiskProfileQuestionnaireScreen(
            argument: args,
          ),
        );
      case Routes.riskIncomeQuestionnaire:
        return MaterialPageRoute(
          builder: (_) => const RiskIncomeQuestionnaireScreen(),
        );
      case Routes.riskToleranceQuestionnaire:
        return MaterialPageRoute(
          builder: (_) => const RiskToleranceQuestionnaireScreen(),
        );
      case Routes.riskProfilingResults:
        return MaterialPageRoute(
          builder: (_) => RiskProfileResultsScreen(
            argument: args,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text("Empty Screen"),
            ),
          ),
        );
    }
  }
}
