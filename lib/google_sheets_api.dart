import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
//Create credential
  static const _credentials = r'''

{
  "type": "service_account",
  "project_id": "focal-abbey-370510",
  "private_key_id": "c31f3cff5e2c3d9279031696ca34bc0a386b634a",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCPOzPwHCwouvpl\nYe+vY26zFXGUPs/ZGx6IEb7aoX8BXWXCqRglGp169QtdBEMtwR36k8xkfCQuGb1K\nfq+UdtF1EyNu6+GzAS+NUPA1wTG4nj6SZaiNZEm+XxIuydwOAG9MBFkv9bMR2E05\nDCoDzFwnB1H9fa8sjPoQhA95iW4UqioeNezy2GvEq5ZkPIK7HF6cLNJMQ/DwRFHq\nxf78Ojp/51TKJyqCOn9VZtrMcmYCALQNgDeW6vAjH2CKTwPHs/HpW0ljJPfS13YC\nL/LgXPTpJJ7vM/Wid1V+X+eV82HBVqsoXjlAJo5c9/1W+dEwSsH7iAsi92jjm/5R\n+7sgTdrHAgMBAAECggEAL5GMcsqQeeh7P49yoG+n9K8C/SaNNf/1OGCYX5jyCrx/\njtJE1BHOSmc2ompHe1sfPzi10YuPIoZm4OZJHsgFUVoNUwng9+fFaKwAUwH6JuPb\nSRidDXRIr4J4kfR1cmr/i6IIEs8JbTxGjVM2YvOMiWO7fbIvqt6ZMEIDt6wGVLMd\npZuyh0sEGlshFnsBHAEtZ0mBy5s8ysBGzuy/4c4SewVjNRXlVGvUyfLg+6TURjBB\nLSTUn7MhCk8g+7D+epHkHhDoB/OSF7/4BQJrbF35Wg7k6sfjRYkazQWDLSyM8Weq\nY1iCUDdj2JoqL1qHWSqnAMMaqhTLiJ2sWG3I8Krf2QKBgQDHU+p1sCijmpWs+97p\nnnG9l797VzLrYwj6Bdgcx1cQi/O0SAso/+nvnCHhBqeLxdkzDw54dTC2Nc2wONd6\nzITR6EhXCPcvK4bb0/yTXy5WuFSbSnivHdXg1c1TeZuLC4oC0t5ZW7G3CFbdNgL7\n/bxKj2377Shg5JeGB9htQ4cseQKBgQC39Ew6kG5hyrH5FDKUGHJSHTdMpxX3/BLV\n0aIocO55rcJaueflgyvhRrnPyHDk0gEb+r7D4hTsjx+OimffUUOMDEhciHFCpfws\nYowHJajNV9RHNOpATw0zczAx+XkI6mcLZCNg4XRsQHm86xfK7Vy64fiCiyb+8lF3\n8QGGp4zxPwKBgQCF3RBvmy+fuBhfBQQOZw9B4aCCB+y1clw79SLPKPyKq0Kux1df\nYIbOGVATXLG2x9d3V9xC/4kIRZfuii4EVUe55MJ4WRgQQK4gAfz1SA3JxZ9kbx4f\nlOznQw7Sya+xML2t6cnTvyXZoysbAsP8UcpbVHnrn7jnYX11UN2De79TGQKBgQCX\nQzlThuRdYZGLIYKdqKSIxSFt1I8KBatvSxwuaP6P68O/WtNHNN9mNQQhyc6bOdxT\np5Ip/MP76YynZ0QWq/oBNTBjdoa7qUV9MeO3FM6DW89gZjChhN90CSn+TgeqvyTQ\nhx1YUsurIDF6mU5NPXVc7uesYMRGK/e1yuXYVfpdfQKBgQCDp7dEFfAPVsnoGR0f\nBvV1kaoASYjFyIg0y63ddOak5l8dEOsgqQf89cqR1tFDUS43VBrIEsWG8gQ61RiP\nHjtu5PXSdTtG8cMABIZ9MV8Gjd8Tri/zlkRSbCeHMYTxZ1DuAM9aKSknxzSC/cQB\n7FYPmvSsl9/l1D35HeNt5aQddw==\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-gsheets-tutorial@focal-abbey-370510.iam.gserviceaccount.com",
  "client_id": "109712876674852410338",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-gsheets-tutorial%40focal-abbey-370510.iam.gserviceaccount.com"
}
''';

//Setup and connect to speadsheet
  static final _spreadsheetID = '1z_1yIS0Fas0pjOrmgks8x2gU2XSRE4hIDNxO8lrg0nA';
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
