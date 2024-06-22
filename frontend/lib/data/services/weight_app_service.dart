import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:weight_app/data/models/auth_user.dart';
import 'package:weight_app/data/responses/users_response.dart';

enum HttpMethod {
  get,
  post,
  patch,
  delete,
}

class HTTPException implements Exception {
  final int statusCode;
  final Map<String, dynamic> jsonBody;

  HTTPException(this.statusCode, this.jsonBody);

  @override
  String toString() => 'HTTPException: $statusCode $jsonBody';
}

class WeightAppService {
  String apiBaseUrl;
  String deviceName;
  String acceptLang = 'en';
  String? token;
  AuthUser? authUser;

  WeightAppService({required this.apiBaseUrl, required this.deviceName});

  Future<AuthUser> login(String email, String password) async {
    var response = await apiRequest(
        method: HttpMethod.post,
        endpoint: '/auth/token',
        body: {
          "email": email,
          "password": password,
          "device_name": deviceName,
        });

    token =
        json.decode(const Utf8Decoder().convert(response.bodyBytes))['token'];

    authUser = await getAuthUser();

    if (authUser != null) {
      return Future.value(authUser);
    } else {
      token = null;
      throw Exception('Failed to login!');
    }
  }

  Future<AuthUser?> getAuthUser() async {
    var response =
        await apiRequest(method: HttpMethod.get, endpoint: '/auth/user');

    if (response.statusCode == 200) {
      return AuthUser.fromJson(
          jsonDecode(const Utf8Decoder().convert(response.bodyBytes))['data']);
    }

    return null;
  }

  Future<void> logout() async {
    try {
      await apiRequest(method: HttpMethod.delete, endpoint: '/auth/tokens');
    } catch (e) {
      // do nothing
    }
    token = null;
    authUser = null;
  }

  Future<bool> isLoggedIn() async {
    return token != null;
  }

  Future<AuthUser> register(String name, String email, String password) async {
    var response = await apiRequest(
        method: HttpMethod.post,
        endpoint: '/auth/register',
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        });

    return AuthUser.fromJson(
        jsonDecode(const Utf8Decoder().convert(response.bodyBytes))['data']);
  }

  Future<UsersResponse> getUsers(int page) async {
    var response =
        await apiRequest(method: HttpMethod.get, endpoint: '/users?page=$page&per_page=10');
    dynamic json = jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
    return UsersResponse.fromJson(json);
  }

  Future<http.Response> apiRequest(
      {required HttpMethod method,
      required String endpoint,
      Map<String, String?> body = const {}}) async {
    var client = http.Client();
    var headers = {
      'Authorization': token != null ? 'Bearer $token' : '',
      'Accept': 'application/json',
      'Accept-Language': acceptLang,
    };
    var uri = Uri.parse('$apiBaseUrl$endpoint');

    log('---- API Request: $method $uri', error: {
      "headers": headers,
      "body": body,
    });

    http.Response response;

    if (method == HttpMethod.delete) {
      response = await client.delete(uri, headers: headers, body: body);
    } else if (method == HttpMethod.post) {
      response = await client.post(uri, headers: headers, body: body);
    } else if (method == HttpMethod.patch) {
      response = await client.patch(uri, headers: headers, body: body);
    } else {
      response = await client.get(uri, headers: headers);
    }

    log('---- API Response: ${response.statusCode} $method $uri', error: {
      "headers": response.headers,
      "body": jsonDecode(const Utf8Decoder().convert(response.bodyBytes)),
    });

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return response;
    } else {
      if (response.statusCode == 401) {
        token = null;
      }

      throw HTTPException(response.statusCode,
          jsonDecode(const Utf8Decoder().convert(response.bodyBytes)));
    }
  }
}
