import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';
import 'package:moneyboi/Data%20Models/friend.dart';
import 'package:moneyboi/Network/network_service.dart';

class ProfileController extends GetxController {
  final NetworkService _apiService = NetworkService();

  RxBool isProfileLoading = false.obs;

  RxBool isFriendsLoading = false.obs;

  final RxString name = ''.obs;
  final RxString email = ''.obs;

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

  Future<void> getUserProfile() async {
    isProfileLoading.value = true;
    isFriendsLoading.value = true;
    update();

    _apiService.getUserProfile().then((ApiResponseModel _profRes) {
      if (_profRes.statusCode == 200) {
        final _res = _profRes.responseJson!.data as Map;
        // print(_res['name']);
        isProfileLoading.value = false;
        name.value = _res['name'].toString();
        email.value = _res['email'].toString();
        update();
      } else {
        isProfileLoading.value = false;
        update();
      }
    });

    _apiService.getFriendsList().then((_friendRes) {
      if (_friendRes.statusCode == 200) {
        final _res = _friendRes.responseJson!.data as List;
        debugPrint(" friends list : $_res");
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

    _apiService.getPendingActionFriendsList().then((_res) {
      if (_res.statusCode == 200) {
        final data = _res.responseJson!.data as Map<String, dynamic>;
        debugPrint(" pending friends list : $_res");
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
}
