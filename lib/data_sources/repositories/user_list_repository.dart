import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_urls.dart';
import 'package:moduler_test/models/user.dart';
import 'package:moduler_test/resources/ulis/fetch_data_exception.dart';

abstract class UserListRepository {
  Future<List<User>> fetchUser();
}

class UserListRepositoryIml implements UserListRepository {
  @override
  Future<List<User>> fetchUser() {
    return http
        .get(API_USER_LIST)
        .then((http.Response response) {
      final String jsonBody = response.body;
      final int statusCode = response.statusCode;

      if(statusCode != 200 || jsonBody == null){
        print(response.reasonPhrase);
        throw new FetchDataException("StatusCode:$statusCode, Error:${response.reasonPhrase}");
      }

      final JsonDecoder _decoder = new JsonDecoder();
      final useListContainer = _decoder.convert(jsonBody);
      final List userList = useListContainer['results'];
      return userList.map((contactRaw) => new User.fromJson(contactRaw)).toList();
    });
  }
}