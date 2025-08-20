import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:rmw/core/models/transaction.dart';
import 'package:rmw/core/models/category.dart';
import 'package:rmw/core/models/account.dart';
import 'package:rmw/core/models/dashboard_summary.dart';
import 'package:rmw/core/models/budget.dart';

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

  // check whether the jwt token is valid or not
  Future<bool> checkTokenValidity() async {
    try {
      await _dio.get('$_baseUrl/v1/users/me');
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        return false;
      }
      
      return false;
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

  // fetch all the accounts
  Future<List<Account>> getAccounts() async {
    try {
      final response = await _dio.get('$_baseUrl/v1/accounts/list');
      List<dynamic> jsonList = response.data;
      return jsonList.map((json) => Account.fromJson(json)).toList();
    } on DioException {
      throw Exception('Could not load accounts');
    }
  }

  // fetch all the categories
  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get('$_baseUrl/v1/categories/list');
      List<dynamic> jsonList = response.data;
      return jsonList.map((json) => Category.fromJson(json)).toList();
    } on DioException {
      throw Exception('Could not load categories');
    }
  }

  // add transaction
  Future<void> createTransaction(Map<String, dynamic> transactionData) async {
    try {
      await _dio.post(
        '$_baseUrl/v1/transactions/create',
        data: transactionData,
      );
    } on DioException catch (e) {
      print('Error creating transaction: ${e.response?.data}');
      throw Exception('Failed to create transaction');
    }
  }

  // list of budgets
  Future<List<Budget>> getBudgets(String period) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/v1/budgets',
        queryParameters: {'period': period},
      );
      List<dynamic> jsonList = response.data;
      return jsonList.map((json) => Budget.fromJson(json)).toList();
    } on DioException {
      throw Exception('Could not load budgets');
    }
  }
}
