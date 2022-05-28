import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:moneyboi/Constants/urls.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';

class NetworkService {
  final Box _authBox = Hive.box('authBox');
  Future<ApiResponseModel> login({
    required String email,
    required String password,
  }) async {
    final Dio _dio = Dio();

    try {
      final Response _loginResp = await _dio.post(
        '$baseUrl$loginEndPoint',
        data: {
          "email": email,
          "password": password,
        },
      );

      if (_loginResp.statusCode == 200) {
        _authBox.put('token', (_loginResp.data as Map)['token']);
        debugPrint((_loginResp.data as Map)['token'].toString());
        return ApiResponseModel(
          statusCode: _loginResp.statusCode!,
          endPoint: loginEndPoint,
          specificMessage: "Login Successful",
        );
      } else {
        return ApiResponseModel(
          statusCode: _loginResp.statusCode ?? 400,
          endPoint: loginEndPoint,
          specificMessage: _loginResp.data.toString(),
        );
      }
    } on DioError catch (e) {
      debugPrint("Dio Error: $e");
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: loginEndPoint,
        specificMessage: e.response?.data.toString(),
      );
    } catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: loginEndPoint,
        specificMessage: " unknown error",
      );
    }
  }

  Future<ApiResponseModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final Dio _dio = Dio();

    try {
      final Response _signupResp = await _dio.post(
        '$baseUrl$signupEndPoint',
        data: {
          "name": name,
          "email": email,
          "password": password,
        },
      );

      if (_signupResp.statusCode == 200) {
        return ApiResponseModel(
          statusCode: _signupResp.statusCode!,
          endPoint: loginEndPoint,
          specificMessage: "Signup Successful",
        );
      } else {
        return ApiResponseModel(
          statusCode: _signupResp.statusCode ?? 400,
          endPoint: loginEndPoint,
          specificMessage: _signupResp.data.toString(),
        );
      }
    } on DioError catch (e) {
      debugPrint("Dio Error $loginEndPoint $e");
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: loginEndPoint,
        specificMessage: e.response?.data.toString(),
      );
    } catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: loginEndPoint,
        specificMessage: " unknown error",
      );
    }
  }

  Future<ApiResponseModel> getExpenseRecords({
    String? dateIn,
    String? dateOut,
  }) async {
    final Dio _dio = Dio();
    final String _token = _authBox.get('token').toString();
    _dio.options.headers['x-auth-token'] = _token;
    try {
      final Response _expenseRecordsResp;

      if (dateIn != null && dateOut != null) {
        _expenseRecordsResp = await _dio.get(
          '$baseUrl$expenseRecordsListingEndPoint',
          queryParameters: {
            "date_in": dateIn,
            "date_out": dateOut,
          },
        );
      } else if (dateIn == null && dateOut != null) {
        _expenseRecordsResp = await _dio.get(
          '$baseUrl$expenseRecordsListingEndPoint',
          queryParameters: {
            "date_out": dateOut,
          },
        );
      } else if (dateIn != null && dateOut == null) {
        _expenseRecordsResp = await _dio.get(
          '$baseUrl$expenseRecordsListingEndPoint',
          queryParameters: {
            "date_in": dateIn,
          },
        );
      } else {
        _expenseRecordsResp = await _dio.get(
          '$baseUrl$expenseRecordsListingEndPoint',
        );
      }

      if (_expenseRecordsResp.statusCode == 200) {
        return ApiResponseModel(
          statusCode: _expenseRecordsResp.statusCode!,
          endPoint: expenseRecordsListingEndPoint,
          responseJson: _expenseRecordsResp,
        );
      } else {
        return ApiResponseModel(
          statusCode: _expenseRecordsResp.statusCode ?? 400,
          endPoint: expenseRecordsListingEndPoint,
        );
      }
    } on DioError catch (e) {
      debugPrint("Dio Error: $expenseRecordsListingEndPoint $e");
      debugPrint(e.response?.data.toString());
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: expenseRecordsListingEndPoint,
        specificMessage: e.response?.data.toString(),
      );
    } catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: expenseRecordsListingEndPoint,
        specificMessage: " unknown error",
      );
    }
  }

  Future<ApiResponseModel> createExpenseRecords({
    required String recordDate,
    required String category,
    required int amount,
    required String remarks,
  }) async {
    final Dio _dio = Dio();
    final String _token = _authBox.get('token').toString();
    _dio.options.headers['x-auth-token'] = _token;
    try {
      final Response _expenseRecordResp;

      _expenseRecordResp = await _dio.post(
        '$baseUrl$expenseRecordCreateEndPoint',
        data: {
          "category": category,
          "amount": amount,
          "record_date": recordDate,
          "remarks": remarks
        },
      );

      if (_expenseRecordResp.statusCode == 200) {
        return ApiResponseModel(
          statusCode: _expenseRecordResp.statusCode!,
          endPoint: expenseRecordCreateEndPoint,
          responseJson: _expenseRecordResp,
        );
      } else {
        return ApiResponseModel(
          statusCode: _expenseRecordResp.statusCode ?? 400,
          endPoint: expenseRecordCreateEndPoint,
        );
      }
    } on DioError catch (e) {
      debugPrint("Dio Error: $e");
      debugPrint(e.response?.data.toString());
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: expenseRecordCreateEndPoint,
        specificMessage: e.response?.data.toString(),
      );
    } catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: expenseRecordCreateEndPoint,
        specificMessage: " unknown error",
      );
    }
  }

  Future<ApiResponseModel> updateExpenseRecords({
    required String recordDate,
    required String category,
    required int amount,
    required String remarks,
    required String id,
  }) async {
    final Dio _dio = Dio();
    final String _token = _authBox.get('token').toString();
    _dio.options.headers['x-auth-token'] = _token;
    try {
      final Response _expenseRecordResp;

      _expenseRecordResp = await _dio.put(
        '$baseUrl$expenseRecordCreateEndPoint/$id',
        data: {
          "category": category,
          "amount": amount,
          "record_date": recordDate,
          "remarks": remarks
        },
      );

      if (_expenseRecordResp.statusCode == 200) {
        return ApiResponseModel(
          statusCode: _expenseRecordResp.statusCode!,
          endPoint: expenseRecordCreateEndPoint,
          responseJson: _expenseRecordResp,
        );
      } else {
        return ApiResponseModel(
          statusCode: _expenseRecordResp.statusCode ?? 400,
          endPoint: expenseRecordCreateEndPoint,
        );
      }
    } on DioError catch (e) {
      debugPrint("Dio Error: $e");
      debugPrint(e.response?.data.toString());
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: expenseRecordCreateEndPoint,
        specificMessage: e.response?.data.toString(),
      );
    } catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: expenseRecordCreateEndPoint,
        specificMessage: " unknown error",
      );
    }
  }

  Future<ApiResponseModel> deleteExpenseRecords({required String id}) async {
    final Dio _dio = Dio();
    final String _token = _authBox.get('token').toString();
    _dio.options.headers['x-auth-token'] = _token;
    try {
      final Response _expenseRecordResp;

      _expenseRecordResp =
          await _dio.delete('$baseUrl$expenseRecordCreateEndPoint/$id');

      debugPrint(_expenseRecordResp.data.toString());

      if (_expenseRecordResp.statusCode == 200) {
        return ApiResponseModel(
          statusCode: 200,
          endPoint: "$expenseRecordCreateEndPoint/$id",
          responseJson: _expenseRecordResp,
        );
      } else {
        return ApiResponseModel(
          statusCode: _expenseRecordResp.statusCode ?? 400,
          endPoint: "$expenseRecordCreateEndPoint/$id",
        );
      }
    } on DioError catch (e) {
      debugPrint("Dio Error: $e");
      debugPrint(e.response?.data.toString());
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: "$expenseRecordCreateEndPoint/$id",
        specificMessage: e.response?.data.toString(),
      );
    } catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: "$expenseRecordCreateEndPoint/$id",
        specificMessage: " unknown error",
      );
    }
  }

  Future<ApiResponseModel> getUserProfile() async {
    final Dio _dio = Dio();
    final String _token = _authBox.get('token').toString();
    _dio.options.headers['x-auth-token'] = _token;
    try {
      final Response _profileResp =
          await _dio.get('$baseUrl$profileGetEndPoint');

      if (_profileResp.statusCode == 200) {
        return ApiResponseModel(
          statusCode: _profileResp.statusCode ?? 200,
          endPoint: profileGetEndPoint,
          specificMessage: '',
          responseJson: _profileResp,
        );
      }

      return ApiResponseModel(
        statusCode: 404,
        endPoint: profileGetEndPoint,
        specificMessage: _profileResp.data.toString(),
      );
    } on DioError catch (e) {
      debugPrint("Dio Error: $profileGetEndPoint $e");
      debugPrint(e.response?.data.toString());
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: profileGetEndPoint,
        specificMessage: e.response?.data.toString(),
      );
    } catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: profileGetEndPoint,
        specificMessage: " unknown error",
      );
    }
  }

  Future<ApiResponseModel> forgotPasswordOtpGenerate({
    required String email,
  }) async {
    final Dio _dio = Dio();
    try {
      final Response _frgtPswdGenRes = await _dio.post(
        '$baseUrl$forgotPasswordOtpGetEndPoint',
        data: {
          'email': email,
        },
      );

      if (_frgtPswdGenRes.statusCode == 200) {
        return ApiResponseModel(
          statusCode: _frgtPswdGenRes.statusCode ?? 200,
          endPoint: forgotPasswordOtpGetEndPoint,
          specificMessage: '',
          responseJson: _frgtPswdGenRes,
        );
      }

      return ApiResponseModel(
        statusCode: 404,
        endPoint: forgotPasswordOtpGetEndPoint,
        specificMessage: _frgtPswdGenRes.data.toString(),
      );
    } on DioError catch (e) {
      debugPrint("Dio Error: $forgotPasswordOtpGetEndPoint $e");
      debugPrint(e.response?.data.toString());
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: forgotPasswordOtpGetEndPoint,
        specificMessage: e.response?.data.toString(),
      );
    } catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: forgotPasswordOtpGetEndPoint,
        specificMessage: " unknown error",
      );
    }
  }

  Future<ApiResponseModel> forgotPasswordOtpVerify({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final Dio _dio = Dio();
    try {
      final Response _frgtPswdVerifyRes = await _dio.post(
        '$baseUrl$forgotPasswordOtpVerifyEndPoint',
        data: {
          'email': email,
          'otp': otp,
          'new_password': newPassword,
        },
      );

      if (_frgtPswdVerifyRes.statusCode == 200) {
        return ApiResponseModel(
          statusCode: _frgtPswdVerifyRes.statusCode ?? 200,
          endPoint: forgotPasswordOtpVerifyEndPoint,
          specificMessage: '',
          responseJson: _frgtPswdVerifyRes,
        );
      }

      return ApiResponseModel(
        statusCode: 404,
        endPoint: forgotPasswordOtpVerifyEndPoint,
        specificMessage: _frgtPswdVerifyRes.data.toString(),
      );
    } on DioError catch (e) {
      debugPrint("Dio Error: $forgotPasswordOtpVerifyEndPoint $e");
      debugPrint(e.response?.data.toString());
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: forgotPasswordOtpVerifyEndPoint,
        specificMessage: e.response?.data.toString(),
      );
    } catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: forgotPasswordOtpVerifyEndPoint,
        specificMessage: " unknown error",
      );
    }
  }

  /// API function to get friends List of the user. (Only accepted ones)
  Future<ApiResponseModel> getFriendsList() async {
    final Dio _dio = Dio();
    final String _token = _authBox.get('token').toString();
    _dio.options.headers['x-auth-token'] = _token;
    try {
      final Response _friendsListRes = await _dio.get(
        '$baseUrl$getFriendsListEndPoint',
      );

      if (_friendsListRes.statusCode == 200) {
        return ApiResponseModel(
          statusCode: _friendsListRes.statusCode ?? 200,
          endPoint: forgotPasswordOtpVerifyEndPoint,
          specificMessage: '',
          responseJson: _friendsListRes,
        );
      }

      return ApiResponseModel(
        statusCode: 404,
        endPoint: forgotPasswordOtpVerifyEndPoint,
        specificMessage: _friendsListRes.data.toString(),
      );
    } on DioError catch (e) {
      debugPrint("Dio Error: $forgotPasswordOtpVerifyEndPoint $e");
      debugPrint(e.response?.data.toString());
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: forgotPasswordOtpVerifyEndPoint,
        specificMessage: e.response?.data.toString(),
      );
    } catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: forgotPasswordOtpVerifyEndPoint,
        specificMessage: " unknown error",
      );
    }
  }

  /// API function to get pending action friends List of the user. (pending, requested)
  Future<ApiResponseModel> getPendingActionFriendsList() async {
    final Dio _dio = Dio();
    final String _token = _authBox.get('token').toString();
    _dio.options.headers['x-auth-token'] = _token;
    try {
      final Response _friendsListRes = await _dio.get(
        '$baseUrl$getPendingActionsFriendsListEndPoint',
      );

      if (_friendsListRes.statusCode == 200) {
        return ApiResponseModel(
          statusCode: _friendsListRes.statusCode ?? 200,
          endPoint: forgotPasswordOtpVerifyEndPoint,
          specificMessage: '',
          responseJson: _friendsListRes,
        );
      }

      return ApiResponseModel(
        statusCode: 404,
        endPoint: forgotPasswordOtpVerifyEndPoint,
        specificMessage: _friendsListRes.data.toString(),
      );
    } on DioError catch (e) {
      debugPrint("Dio Error: $forgotPasswordOtpVerifyEndPoint $e");
      debugPrint(e.response?.data.toString());
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: forgotPasswordOtpVerifyEndPoint,
        specificMessage: e.response?.data.toString(),
      );
    } catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: forgotPasswordOtpVerifyEndPoint,
        specificMessage: " unknown error",
      );
    }
  }

  /// API function to accept a pending friend request.
  Future<ApiResponseModel> acceptFriendRequest({
    required String friendRequestId,
  }) async {
    final Dio _dio = Dio();
    final String _token = _authBox.get('token').toString();
    _dio.options.headers['x-auth-token'] = _token;
    try {
      final Response _acceptReqRes = await _dio.post(
        '$baseUrl$acceptFriendRequestEndPoint',
        data: {
          'id': friendRequestId,
        },
      );

      if (_acceptReqRes.statusCode == 200) {
        return ApiResponseModel(
          statusCode: _acceptReqRes.statusCode ?? 200,
          endPoint: acceptFriendRequestEndPoint,
          specificMessage: '',
          responseJson: _acceptReqRes,
        );
      }

      return ApiResponseModel(
        statusCode: 404,
        endPoint: acceptFriendRequestEndPoint,
        specificMessage: _acceptReqRes.data.toString(),
      );
    } on DioError catch (e) {
      debugPrint("Dio Error: $acceptFriendRequestEndPoint $e");
      debugPrint(e.response?.data.toString());
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: acceptFriendRequestEndPoint,
        specificMessage: e.response?.data.toString(),
      );
    } catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: acceptFriendRequestEndPoint,
        specificMessage: " unknown error",
      );
    }
  }

  /// API function to send a friend request.
  Future<ApiResponseModel> sendFriendRequest({
    required String friendEmail,
  }) async {
    final Dio _dio = Dio();
    final String _token = _authBox.get('token').toString();
    _dio.options.headers['x-auth-token'] = _token;
    try {
      final Response _sendReqRes = await _dio.post(
        '$baseUrl$sendFriendRequestEndPoint',
        data: {
          'email': friendEmail,
        },
      );

      if (_sendReqRes.statusCode == 200) {
        return ApiResponseModel(
          statusCode: _sendReqRes.statusCode ?? 200,
          endPoint: sendFriendRequestEndPoint,
          specificMessage: '',
          responseJson: _sendReqRes,
        );
      }

      return ApiResponseModel(
        statusCode: 404,
        endPoint: sendFriendRequestEndPoint,
        specificMessage: _sendReqRes.data.toString(),
      );
    } on DioError catch (e) {
      debugPrint("Dio Error: $sendFriendRequestEndPoint $e");
      debugPrint(e.response?.data.toString());
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: sendFriendRequestEndPoint,
        specificMessage: e.response?.data.toString(),
      );
    } catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: sendFriendRequestEndPoint,
        specificMessage: " unknown error",
      );
    }
  }

  /// API function to delete a friend request.
  Future<ApiResponseModel> deleteFriendRequest({
    required String friendRequestId,
  }) async {
    final Dio _dio = Dio();
    final String _token = _authBox.get('token').toString();
    _dio.options.headers['x-auth-token'] = _token;
    try {
      final Response _delRequest = await _dio.delete(
        '$baseUrl$deleteFriendRequestEndPoint' + '/$friendRequestId',
      );

      if (_delRequest.statusCode == 204) {
        return ApiResponseModel(
          statusCode: _delRequest.statusCode ?? 204,
          endPoint: deleteFriendRequestEndPoint,
          specificMessage: '',
          responseJson: _delRequest,
        );
      }

      return ApiResponseModel(
        statusCode: 404,
        endPoint: deleteFriendRequestEndPoint,
        specificMessage: _delRequest.data.toString(),
      );
    } on DioError catch (e) {
      debugPrint("Dio Error: $deleteFriendRequestEndPoint $e");
      debugPrint(e.response?.data.toString());
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: deleteFriendRequestEndPoint,
        specificMessage: e.response?.data.toString(),
      );
    } catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: deleteFriendRequestEndPoint,
        specificMessage: " unknown error",
      );
    }
  }
}
