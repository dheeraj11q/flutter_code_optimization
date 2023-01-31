import 'graph_ql_api.dart';

class AuthApis {
  static void userLogin() async {
    try {
      var res = await GraphQL.request(query: '''query {
login(username:"emarsalis", password : "thePassword"){
    AUTH_KEY,
}
}''');

      print(res?.data);
    } catch (e) {
      print(e);
    }
  }

  static void userDetailGet() async {
    try {
      var res = await GraphQL.authRquest(query: '''
   {getUserProfile(username:"emarsalis"){
        first_name, last_name, dob, postal
    }}

''');

      print(res?.data);

      print(res?.exception);
    } catch (e) {
      print(e);
    }
  }
}
