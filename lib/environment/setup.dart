import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  // ! MISCELLANEOUS

  static String passPhrase = dotenv.env['PASS_PHRASE'] ?? "";
  static String salt = dotenv.env['SALT'] ?? "";
  static String initialVector = dotenv.env['INITIAL_VECTOR'] ?? "";
  static String selfieMatchScore = dotenv.env['PHOTO_MATCH_SCORE'] ?? "";
  static String timeOut = dotenv.env['TIME_OUT'] ?? "";

  // ! Configuration APIs

  static String getAllCountries = dotenv.env['GET_ALL_COUNTRIES'] ?? "";
  static String getSupportedLanguages =
      dotenv.env['GET_SUPPORTED_LANGUAGES'] ?? "";
  static String getCountryDetails = dotenv.env['GET_COUNTRY_DETAILS'] ?? "";
  static String getAppLabels = dotenv.env['GET_APP_LABELS'] ?? "";
  static String getAppMessages = dotenv.env['GET_APP_MESSAGES'] ?? "";
  static String getDropdownLists = dotenv.env['GET_DROPDOWN_LISTS'] ?? "";
  static String getTermsAndConditions =
      dotenv.env['GET_TERMS_AND_CONDITIONS'] ?? "";
  static String getPrivacyStatement = dotenv.env['GET_PRIVACY_STATEMENT'] ?? "";
  static String getApplicationConfigurations =
      dotenv.env['GET_APPLICATION_CONFIGURATIONS'] ?? "";
  static String getFaqs = dotenv.env['GET_FAQS'] ?? "";
  static String getAllCities = dotenv.env['CITIES'] ?? "";
  static String getBankDetails = dotenv.env['BANK_DETAILS'] ?? "";

  // ! Authentication APIs

  static String login = dotenv.env['LOGIN'] ?? "";
  static String addNewDevice = dotenv.env['ADD_NEW_DEVICE'] ?? "";
  static String validateEmailOtpForPassword =
      dotenv.env['VALIDATE_EMAIL_OTP_FOR_PASSWORD'] ?? "";
  static String changePassword = dotenv.env['CHANGE_PASSWORD'] ?? "";
  static String isDeviceValid = dotenv.env['IS_DEVICE_VALID'] ?? "";
  static String renewToken = dotenv.env['RENEW_TOKEN'] ?? "";
  static String registeredMobileOtpRequest =
      dotenv.env['REGISTERED_MOBILE_OTP_REQUEST'] ?? "";
  static String getProfileData = dotenv.env['GET_PROFILE_DATA'] ?? "";
  static String uploadProfilePhoto = dotenv.env['UPLOAD_PROFILE_PHOTO'] ?? "";
  static String updateRetailMobileNumber =
      dotenv.env['UPDATE_RETAIL_MOBILE_NUMBER'] ?? "";
  static String initiateUaePassAuth =
      dotenv.env['INITIATE_UAE_PASS_AUTH'] ?? "";
  static String uaePassLogin = dotenv.env['UAE_PASS_LOGIN'] ?? "";
  static String decrypt = dotenv.env['DECRYPT'] ?? "";

  // ! Registration APIs

  static String sendEmailOtp = dotenv.env['SEND_EMAIL_OTP'] ?? "";
  static String verifyEmailOtp = dotenv.env['VERIFY_EMAIL_OTP'] ?? "";
  static String validateEmail = dotenv.env['VALIDATE_EMAIL'] ?? "";
  static String registerUser = dotenv.env['REGISTER_USER'] ?? "";
  static String ifEidExists = dotenv.env['IF_EID_EXISTS'] ?? "";
  static String uploadEid = dotenv.env['UPLOAD_EID'] ?? "";
  static String registerRetailCustomerAddress =
      dotenv.env['REGISTER_RETAIL_CUSTOMER_ADDRESS'] ?? "";
  static String addOrUpdateIncomeSource =
      dotenv.env['ADD_OR_UPDATE_INCOME_SOURCE'] ?? "";
  static String uploadCustomerTaxInformation =
      dotenv.env['UPLOAD_CUSTOMER_TAX_INFORMATION'] ?? "";
  static String sendMobileOtp = dotenv.env['SEND_MOBILE_OTP'] ?? "";
  static String verifyMobileOtp = dotenv.env['VERIFY_MOBILE_OTP'] ?? "";
  static String registerRetailCustomer =
      dotenv.env['REGISTER_RETAIL_CUSTOMER'] ?? "";
  static String createCustomer = dotenv.env['CREATE_CUSTOMER'] ?? "";
  static String addOrUpdateSecondaryEmail =
      dotenv.env['ADD_OR_UPDATE_SECONDARY_EMAIL'] ?? "";

  // ! Risk Profiling APIs

  static String getRiskProfileQuestions =
      dotenv.env['GET_RISK_PROFILE_QUESTIONS'] ?? "";
  static String setRiskProfile = dotenv.env['SET_RISK_PROFILE'] ?? "";
  static String getRiskProfile = dotenv.env['GET_RISK_PROFILE'] ?? "";

  // ! Account APIs

  static String getCustomerDetails = dotenv.env['GET_CUSTOMER_DETAILS'] ?? "";
  static String getCardDetails = dotenv.env['GET_CARD_DETAILS'] ?? "";
  static String createCard = dotenv.env['CREATE_CARD'] ?? "";
  static String getAccountBalance = dotenv.env['GET_ACCOUNT_BALANCE'] ?? "";
  static String getTransactionHistory =
      dotenv.env['GET_TRANSACTION_HISTORY'] ?? "";
  static String getBeneficiaries = dotenv.env['GET_BENEFICIARIES'] ?? "";
  static String createBeneficiary = dotenv.env['CREATE_BENEFICIARIES'] ?? "";
  static String deleteBeneficiary = dotenv.env['DELETE_BENEFICIARIES'] ?? "";
  static String cardFreeze = dotenv.env['CARD_FREEZE'] ?? "";
  static String getAppBanner = dotenv.env['GET_APP_BANNER'] ?? "";
  static String getPDFCustomerAccountStatement =
      dotenv.env['GET_PDF_CUSTOMER_ACCOUNT_STATEMENT'] ?? "";
  static String getPDFPortfolioSummary =
      dotenv.env['GET_PDF_PORTFOLIO_SUMMARY'] ?? "";

  // ! Payments APIs

  static String makeInternalMoneyTransfer =
      dotenv.env['MAKE_INTERNAL_MONEY_TRANSFER'] ?? "";
  static String getInvestnationCustomerDetails =
      dotenv.env['GET_INVESTNATION_CUSTOMER_DETAILS'] ?? "";

  // ! Investment APIs

  static String createInvestment = dotenv.env['CREATE_INVESTMENT'] ?? "";
  static String getInvestmentDetails = dotenv.env['INVESTMENT_DETAILS'] ?? "";
  static String checkDailyInvLimit = dotenv.env['CHECK_DAILY_INV_LIMIT'] ?? "";
  static String getAvailablePortfolios =
      dotenv.env['GET_AVAILABLE_PORTFOLIOS'] ?? "";
  static String getPortfolioDetails = dotenv.env['GET_PORTFOLIO_DETAILS'] ?? "";
  static String getFactSheet = dotenv.env['GET_FACT_SHEET'] ?? "";
  static String checkDailyRedemptionLimit =
      dotenv.env['CHECK_DAILY_REDEMPTION_LIMIT'] ?? "";
  static String redeemInvestment = dotenv.env['REDEEM_INVESTMENT'] ?? "";
  static String portfolioAllocationDetails =
      dotenv.env['PORTFOLIO_ALLOCATION_DETAILS'] ?? "";

  // ! Referral APIs

  static String checkReferralCode = dotenv.env['CHECK_REF_CODE'] ?? "";
  static String createReferralCode = dotenv.env['CREATE_REF_CODE'] ?? "";
  static String getReferralDetails = dotenv.env['GET_REF_DETAILS'] ?? "";
  static String isAuthorizedToSendInvitations =
      dotenv.env['IS_AUTHORIZED_TO_SEND_INVITATIONS'] ?? "";
  static String getReferralConfig = dotenv.env['GET_REFERRAL_CONFIG'] ?? "";
}
