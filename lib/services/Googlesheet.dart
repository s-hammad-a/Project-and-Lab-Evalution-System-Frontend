import 'package:gsheets/gsheets.dart';
class GoogleSheet
{
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "test-8a87e",
  "private_key_id": "8fbe22c0cc22b37021990f8965e6ccf2f420e6b4",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDTFefBXDqX5KNA\nGrgiMmyvJ5Vck4hGqQcqJay310+2wHfBfKr2IfsYY5wDi3CaAc8b6+1CNKTPqHxo\nbye6EeAISATFhh9lwGMa1Fo2B0bfg2NI6pFEyme825rfYH9S+UilvKi81wmz4FWq\nNkky5ba4Ch4x9M4iKnmSbvtRc1F7uCiqFDMkOmNEm0cGkhJ43Apq1W5dYkEN6KhA\nFXk05dRFtz3VJvLcSEvTmT5LZRoKm+VC8ExJ4NGP/pXYRpa7y5iHW+F+kBagPMQn\nVP6LhVavBDaB+rjS3UN5HCOhK0yRylz6gLKnxdRrvPZOuuccE+KAH3OfpeVCzal9\nk0HTDyEVAgMBAAECggEACYl21BynpQ82dQIACcN/d5ZxQCKGSLMAWN4k5JV8y4P8\npShNzRsR7jMp7FsTdlHYmqlZKeGZBKzXGhzTjaubFKS0WnxJ1N4RXDf173T6tcSI\n6tV2RMZkU3sUjz0b45LRvnM8qHOKw67CEBOt0Pfh/oSugpFN8us6XOxYvIBaUR2W\n2UFiVSW8/UAflL7qQszgTqWty14Ka3aGMnXgW5kFPMXOtNjIWWLU4bQSwDLmPqft\nJ3jjOcAmXfCldpQ9v7X1hAYQdTwf8Gp5wLtcDZaiA/H8v+J+FGI6raJdRJRCiu3I\niZDQPGsmuZlYbrhBEABBUAY0TWSoYMEboAbQlQVRoQKBgQD+ed/v8zXyDzuL/0RD\n6ambAjmOODtn6ewh312vYNsnHhsE13Um3EViQHtdFTMTwgNi9+fHA4uaTKN83j7R\nJpHZHTTLQVzrUJOZQR1j2yNuJkgKfe+FP3Uvm1LxXOnqBoXo6WCWqUL7VbZAkWCK\nL2iIpN11o4vHTAQpDpXmUJNp2QKBgQDUWYK2/47DFaJnWWU8eJ6rn8UT17NF8l1i\n7oBijquWbzFoDbu49wES2uFSA9IxCCuW1eFLjXRqsonsLB1blycjywVp0UA1jYdD\nAL/3SgtP+Tc6HpCx0GsvSP1AiXZJSDwc+Wfi02wCx7CYgu9ZAwjIwctuU9wPfXIP\ngjtLcV+PnQKBgQCo5Gpj7p8XEFUNDVZZXHNclZVtdpS22uIFeSHMjBPnWmvEQttV\n90t1ciZuGOvVaSamQLJru0akGclHzpkSZu7VkjS/0ZnB87CCPl0rMP3K1U1q6TpW\nzU8RUZ0y49+7mqi1dG7Oj3gNJ03WfKX+EIjoZ8MzmF/k3ebE+REz0raDwQKBgBs6\nGuOB4vkqhfdAZBWb1aRlyOwhZRAb4lN0Bywb5O5V9XzE/gPaT93uCKPub33v8T7W\nz5tTWNDxcXPBuEXtHIyfVGNb/CKhse0qZHK9oLOxXZ5rGtxhv8yBTE+BEJSW2XZR\nmDtiJmA44HC9oRjFpdOv3XiY8gdea0iHxziGId2VAoGBAM2dRTNJ0Jfq1gew3TDK\ncXMAM6LM1D8NoGc0XFgf50dv1fZbNSpvGRV2z9BbM/msM6u0mSBNPleTCxR5gkg2\nom8zXax17Hehrt/H8iBzb6p/HkRWKHy0rCzNXqIr8zGvEot1HxFtGcGqju82X+7T\n/Wi5rKxc6ckRC20evyOoJphM\n-----END PRIVATE KEY-----\n",
  "client_email": "test-250@test-8a87e.iam.gserviceaccount.com",
  "client_id": "101196049955401108632",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/test-250%40test-8a87e.iam.gserviceaccount.com"
}''';

  static const _spreadSheetId = '1ZhDUgzmAN1Nvu7feqf9yj5UVGNAEledk1zV360GUVK8';
  static final _gSheets = GSheets(_credentials);
  static Worksheet? _userSheet;

  static Future init() async {
    try{
      final spreadsheet = await _gSheets.spreadsheet(_spreadSheetId);
      _userSheet = spreadsheet.sheets.first;
      //Worksheet mySheet = await _getWorkSheet(spreadsheet, title: 'test2');
      //final firstRow = USerFields.getFields();
      //_userSheet!.values.insertRow(1, firstRow);
    }
    catch (e) {
      print('Error: $e');
    }
  }

  Future<Map> getById() async {
    final spreadsheet = await _gSheets.spreadsheet(_spreadSheetId);
    _userSheet = spreadsheet.sheets.first;
    Map map = await _userSheet!.values.map.column(8, fromRow: 4, length: 1);
    String courseCode = map['Course Code'];
    map = await _userSheet!.values.map.column(8, fromRow: 5, length: 1);
    String courseName = map['Course Title'];
    List<String> studentEnrolls = await _userSheet!.values.column(3, fromRow: 5);
    List<String> studentNames = await _userSheet!.values.column(12, fromRow: 5);
    studentNames.removeWhere((item) => item.isEmpty);
    studentEnrolls.removeWhere((item) => item.isEmpty);
    studentNames.removeWhere((item) => item == "Name");
    studentEnrolls.removeWhere((item) => !item.contains('01'));
    return {
      'courseId' : courseCode,
      'courseName' : courseName,
      'studentNames' : studentNames,
      'studentIds' : studentEnrolls,
    };
  }

  static Future<Worksheet> getWorkSheet(
      Spreadsheet spreadsheet, {required String title,}
      ) async {
    try {
      return spreadsheet.sheets.last;  //addWorksheet(title);
    }
    catch (e){
      return await spreadsheet.addWorksheet(title);
    }
  }
}