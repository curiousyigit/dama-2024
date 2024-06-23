import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:weight_app/data/models/auth_user.dart';
import 'package:weight_app/data/models/weight_entry.dart';
import 'package:weight_app/data/responses/users_response.dart';
import 'package:weight_app/data/responses/weight_entries_response.dart';

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
    Response response = await apiRequest(
        method: HttpMethod.post,
        endpoint: '/auth/token',
        body: {
          "email": email,
          "password": password,
          "device_name": deviceName,
        });

    token =
        json.decode(response.body)['token'];

    authUser = await getAuthUser();

    if (authUser != null) {
      return Future.value(authUser);
    } else {
      token = null;
      throw Exception('Failed to login!');
    }
  }

  Future<AuthUser?> getAuthUser() async {
    Response response =
        await apiRequest(method: HttpMethod.get, endpoint: '/auth/user');

    if (response.statusCode == 200) {
      return AuthUser.fromJsonStr(response.body);
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
    Response response = await apiRequest(
        method: HttpMethod.post,
        endpoint: '/auth/register',
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        });

    return AuthUser.fromJsonStr(response.body);
  }

  Future<UsersResponse> getUsers(int page) async {
    Response response =
        await apiRequest(method: HttpMethod.get, endpoint: '/users?page=$page&per_page=10');
        
    return UsersResponse.fromJsonStr(response.body);
  }

  Future<WeightEntriesResponse> getWeightEntries(int page) async {
    Response response =
        await apiRequest(method: HttpMethod.get, endpoint: '/weight-entries?page=$page&per_page=5');

    return WeightEntriesResponse.fromJsonStr(response.body);
  }

  Future<WeightEntry> createWeightEntry(double kg, String? notes) async {
    Response response = await apiRequest(
      method: HttpMethod.post,
      endpoint: '/weight-entries',
      body: {
        'kg': kg.toString(),
        'notes': notes,
      },
    );

    return WeightEntry.fromJsonStr(response.body);
  }

  Future<WeightEntry> updateWeightEntry(String id, double kg, String? notes) async {
    Response response = await apiRequest(
      method: HttpMethod.patch,
      endpoint: '/weight-entries/$id',
      body: {
        'kg': kg.toString(),
        'notes': notes,
      },
    );

    return WeightEntry.fromJsonStr(response.body);
  }

  Future<void> deleteWeightEntry(String id) async {
    await apiRequest(
      method: HttpMethod.delete,
      endpoint: '/weight-entries/$id',
    );
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
      "body": response.body.length > 2 ? jsonDecode(response.body) : null,
    });

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return response;
    } else {
      if (response.statusCode == 401) {
        token = null;
      }

      throw HTTPException(response.statusCode,
          jsonDecode(response.body));
    }
  }
}
