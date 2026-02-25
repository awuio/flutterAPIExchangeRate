void main() {
  print(loginUser());
  print('ทำงานคำสั่งถัดไป');
}

String loginUser() {
  var user = getUserFromDatabase();
  return 'user : $user';
}

Future<String> getUserFromDatabase() async {
  return Future.delayed(Duration(seconds: 10), () => 'John Doe');
}