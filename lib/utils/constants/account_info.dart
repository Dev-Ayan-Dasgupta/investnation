String updatedEmail = "";

String? profilePhotoBase64 = "";
String? profileName = "";
String? profileDoB = "1900-01-01";
String? profilePrimaryEmailId = "";
String? profileSecondaryEmailId = "";
String? profileMobileNumber = "";

Map<String, dynamic> customerDetails = {};
Map<String, dynamic> customerStatement = {};

List accountDetails = [];
List corporateAccountDetails = [];

List fdRates = [];
List fdRatesDates = [];

String? profileAddress = "";
String? profileAddressLine1 = "";
String? profileAddressLine2 = "";
String? profileCity = "";
String? profileState = "";
String? profilePinCode = "";

String? customerName;

bool isExpiredRiskProfiling = false;

int passwordChangesToday = 0;
int emailChangesToday = 0;
int mobileChangesToday = 0;
int onboardingState = 0;
