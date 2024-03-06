import 'package:investnation/data/models/widgets/index.dart';

String senderAccountNumber = "";
String receiverAccountNumber = "";

String senderCurrency = "";
String receiverCurrency = "";
List<DropDownCountriesModel> receiverCurrencies = [];

String senderCurrencyFlag = "";
String receiverCurrencyFlag = "";

double senderBalance = 0;

double fees = 0;

double exchangeRate = 0;

double senderAmount = 0;
double receiverAmount = 0;

String beneficiaryCountryCode = "";

// ------ REMITTANCE ------ //

bool isNewRemittanceBeneficiary = false;

String benBankCode = "";
String benMobileNo = "";
String benSubBankCode = "";
String eidExpiryDate = "";
int benAccountType = 0;
String benIdType = "";
String benIdNo = "";
String benIdExpiryDate = "";
String benBankName = "";
String benCustomerName = "";
String benAddress = "";
String benCity = "";
String benSwiftCode = "";
int benSwiftCodeRef = 0;
String? idType;
String? remittancePurpose;
String? sourceOfFunds;
String? relation;
String? providerName;
String walletNumber = "";

String quotationId = "";

bool isAddRemBeneficiary = false;

bool isBank = false;
bool isWallet = false;

bool isBankSelected = false;
bool isWalletSelected = false;

bool isSenderBearCharges = false;

String expectedTime = "";

// ----- Within Dhabi ----- //

bool isNewWithinDhabiBeneficiary = false;

bool isAddWithinDhabiBeneficiary = false;
