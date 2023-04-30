import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyboi/Constants/enums.dart';
import 'package:moneyboi/Constants/urls.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';
import 'package:moneyboi/Data%20Models/friend.dart';
import 'package:moneyboi/Network/network_service.dart';

class ProfileController extends GetxController {
  final NetworkService _apiService = NetworkService();

  RxBool isProfileLoading = false.obs;

  RxBool isFriendsLoading = false.obs;

  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString id = ''.obs;

  // ignore: prefer_final_fields
  final _friends = <Friend>[].obs;
  final _pending = <Friend>[].obs;
  final _requested = <Friend>[].obs;

  RxInt friendsTabIndex = 0.obs;

  List<Friend> get friendList => _friends;
  List<Friend> get pendingList => _pending;
  List<Friend> get requestedList => _requested;

  void changeFriendTab(int i) {
    if (i != friendsTabIndex.value) {
      friendsTabIndex.value = i;
      update();
    }
  }

  Future<void> getUserProfileAndFriendData() async {
    _friends.clear();
    _pending.clear();
    _requested.clear();
    isProfileLoading.value = true;
    isFriendsLoading.value = true;
    update();
    // await Future.delayed(Duration(seconds: 4));
    _apiService
        .networkCall(
      networkCallMethod: NetworkCallMethod.GET,
      endPointUrl: profileGetEndPoint,
      authenticated: true,
    )
        .then((ApiResponseModel _profRes) {
      if (_profRes.statusCode == 200) {
        final _res = _profRes.responseJson!.data as Map;
        isProfileLoading.value = false;
        name.value = _res['name'].toString();
        email.value = _res['email'].toString();
        id.value = _res['_id'].toString();
        update();
      } else {
        isProfileLoading.value = false;
        update();
      }
    });

    /// API function to get friends List of the user. (Only accepted ones)
    _apiService
        .networkCall(
      networkCallMethod: NetworkCallMethod.GET,
      endPointUrl: getFriendsListEndPoint,
      authenticated: true,
    )
        .then((_friendRes) {
      if (_friendRes.statusCode == 200) {
        final _res = _friendRes.responseJson!.data as List;
        // debugPrint(" friends list : $_res");
        for (final i in _res) {
          _friends.add(Friend.fromJson(i as Map<String, dynamic>));
        }
      } else {
        debugPrint("Error in getting friends list : ${_friendRes.statusCode}");
        debugPrint(_friendRes.specificMessage);
      }
      isFriendsLoading.value = false;
      update();
    });

    /// API function to get pending action friends List of the user. (pending, requested)
    _apiService
        .networkCall(
      networkCallMethod: NetworkCallMethod.GET,
      endPointUrl: getPendingActionsFriendsListEndPoint,
      authenticated: true,
    )
        .then((_res) {
      if (_res.statusCode == 200) {
        final data = _res.responseJson!.data as Map<String, dynamic>;
        // debugPrint(" pending friends list : $_res");
        for (final i in data['pending']!) {
          _pending.add(Friend.fromJson(i as Map<String, dynamic>));
        }
        for (final i in data['requested']!) {
          _requested.add(Friend.fromJson(i as Map<String, dynamic>));
        }
      } else {
        debugPrint(
          "Error in getting pending friends list : ${_res.statusCode}",
        );
        debugPrint(_res.specificMessage);
      }
      isFriendsLoading.value = false;
      update();
    });
  }

  Future<void> acceptRequest(String id) async {
    isFriendsLoading.value = false;
    update();

    /// API function to accept a pending friend request.
    final _res = await _apiService.networkCall(
      networkCallMethod: NetworkCallMethod.POST,
      endPointUrl: acceptFriendRequestEndPoint,
      authenticated: true,
      bodyParameters: {
        'id': id,
      },
    );
    // debugPrint(" res : ${_res.responseJson}");
    if (_res.statusCode == 200) {
      int _pendingReqIndex = -1;
      for (var i = 0; i < _pending.length; i++) {
        if (_pending[i].friendshipId == id) {
          _pendingReqIndex = i;
          break;
        }
      }
      if (_pendingReqIndex != -1) {
        final Friend _oldReq = _pending[_pendingReqIndex];
        _pending.removeAt(_pendingReqIndex);
        _friends.add(_oldReq);
      }
    } else {
      debugPrint(
        "Error in getting pending friends list : ${_res.statusCode}",
      );
      debugPrint(_res.specificMessage);
    }
    friendsTabIndex.value = 0;
    isFriendsLoading.value = false;
    update();
  }

  Future<void> sendRequest({required String email}) async {
    isFriendsLoading.value = false;
    update();

    /// API function to send a friend request.
    final _res = await _apiService.networkCall(
      networkCallMethod: NetworkCallMethod.POST,
      endPointUrl: sendFriendRequestEndPoint,
      authenticated: true,
      bodyParameters: {
        'email': email,
      },
    );
    // debugPrint(" res : ${_res.responseJson}");
    if (_res.statusCode == 200 && _res.responseJson != null) {
      _requested.add(
        Friend.fromJson(_res.responseJson!.data as Map<String, dynamic>),
      );
      Get.back();
      BotToast.showText(
        text: "Friend Request Sent.",
      );
    } else {
      debugPrint(
        "Error in sending friend request : ${_res.statusCode}",
      );
      BotToast.showText(
        text: _res.specificMessage ??
            "Cannot send request right now, try again later.",
      );
      debugPrint(_res.specificMessage);
    }
    friendsTabIndex.value = 1;
    isFriendsLoading.value = false;
    update();
  }

  Future<void> deleteRequest({
    required String id,

    /// 0 for pending, 1 for requested, 2 for friends
    required int type,
  }) async {
    isFriendsLoading.value = false;
    update();

    /// API function to delete a friend request.
    final _res = await _apiService.networkCall(
      networkCallMethod: NetworkCallMethod.DELETE,
      endPointUrl: '$deleteFriendRequestEndPoint/$id',
      authenticated: true,
    );
    // debugPrint(" res : ${_res.responseJson}");
    if (_res.statusCode == 204) {
      int _index = -1;
      if (type == 0) {
        for (var i = 0; i < _pending.length; i++) {
          if (_pending[i].friendshipId == id) {
            _index = i;
            break;
          }
        }
        if (_index != -1) {
          _pending.removeAt(_index);
        }
      } else if (type == 1) {
        for (var i = 0; i < _requested.length; i++) {
          if (_requested[i].friendshipId == id) {
            _index = i;
            break;
          }
        }
        if (_index != -1) {
          _requested.removeAt(_index);
        }
      } else {
        for (var i = 0; i < _friends.length; i++) {
          if (_friends[i].friendshipId == id) {
            _index = i;
            break;
          }
        }
        if (_index != -1) {
          _friends.removeAt(_index);
        }
      }
    } else {
      debugPrint(
        "Error in getting pending friends list : ${_res.statusCode}",
      );
      debugPrint(_res.specificMessage);
    }
    friendsTabIndex.value = 0;
    isFriendsLoading.value = false;
    update();
  }
}
