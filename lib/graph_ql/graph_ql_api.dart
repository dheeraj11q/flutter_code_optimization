import 'package:graphql/client.dart';

class GraphQL {
  static final _graphQlUrl = HttpLink(
    'http://gbx.lightstonedata.com/graphql',
  );

  static GraphQLClient _client(Link httpLink) {
    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
  }

  // << Simple Rquest

  static Future<QueryResult<Object?>?> request({String query = ""}) async {
    try {
      QueryOptions queryOptions = QueryOptions(document: gql(query));

      GraphQLClient client = _client(_graphQlUrl);

      var result = await client.query(queryOptions);

      return result;
    } catch (e) {
      throw e;
      // print("GraphQL request error : $e");
    }
  }

  // >>

  // << auth request with token

  static Future<QueryResult<Object?>?> authRquest({String query = ""}) async {
    try {
      // auth header
      final authHeader = AuthLink(
          getToken: () => '258eb35f-9f2d-4e16-99b5-a0cda9f0f950',
          headerKey: 'AUTH_KEY');

      // auth link
      Link authlink = authHeader.concat(_graphQlUrl);

      // query
      QueryOptions queryOptions = QueryOptions(document: gql(query));

      // auth client

      GraphQLClient authClient = _client(authlink);

      // query run

      var result = await authClient.query(queryOptions);

      return result;
    } catch (e) {
      // ignore: avoid_print
      print("GraphQL auth error : $e");
    }
  }

  // >>
}
