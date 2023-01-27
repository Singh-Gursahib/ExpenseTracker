import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
//Create credential
  static const _credentials = r'''

{
//   "type": "service_account",
//   "project_id": "",
//   "private_key_id": "",
//   "private_key": "-----BEGIN PRIVATE KEY-----\n
//   "client_id": "",
//   "auth_uri": "",
//   "token_uri": "",
//   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//   "client_x509_cert_url": ""
}
''';

//Setup and connect to speadsheet
  //static final _spreadsheetID = '1z_1yIS0Fas0pjOrmgks8x2gU2XSRE4hIDNxO8lrg0nA';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

//somme variables to keep track of
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

//initialize spredsheet
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetID);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  static Future countRows() async {
    while ((await _worksheet?.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    loadTransactions();
  }

  static Future loadTransactions() async {
    if (_worksheet == null) return;
    for (int i = 1; i < numberOfTransactions; i++) {
      final String? transactionName =
          await _worksheet?.values.value(column: 1, row: i + 1);
      final String? transactionAmount =
          await _worksheet?.values.value(column: 2, row: i + 1);
      final String? transactionType =
          await _worksheet?.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions
            .add([transactionName, transactionAmount, transactionType]);
      }
    }
    //Stop loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
