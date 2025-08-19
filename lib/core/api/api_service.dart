import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:rmw/core/models/transaction.dart';
import 'package:rmw/core/models/dashboard_summary.dart';

class ApiService {
  final Dio _dio = Dio();
  final _secureStorage = const FlutterSecureStorage();
  final String _baseUrl = 'http://10.0.2.2:8080/api';

  ApiService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // token from secure storage
          final token = await _secureStorage.read(key: 'jwt_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  // user login
  Future<void> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data['token'] != null) {
        await _secureStorage.write(
          key: 'jwt_token',
          value: response.data['token'],
        );
      } else {
        throw Exception('Failed to log in');
      }
    } on DioException catch (e) {
      print('Login Error: ${e.response?.data}');
      throw Exception('Failed to log in: ${e.response?.data}');
    }
  }

  // home screen - spends today, this week and this month
  Future<DashboardSummary> getDashboardSummary() async {
    try {
      final response = await _dio.get('$_baseUrl/v1/dashboard/summary');
      return DashboardSummary.fromJson(response.data);
    } on DioException catch (e) {
      print('Error fetching dashboard summary: ${e.response?.data}');
      throw Exception('Could not load dashboard data');
    }
  }

  // transactions - list of transactions
  Future<List<Transaction>> getTransactions() async {
    try {
      final response = await _dio.get('$_baseUrl/v1/transactions/list');

      List<dynamic> jsonList = response.data;
      return jsonList.map((json) => Transaction.fromJson(json)).toList();
    } on DioException catch (e) {
      print('Error fetching transactions: ${e.response?.data}');
      throw Exception('Could not load transactions');
    }
  }
}
