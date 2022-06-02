import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Controllers/profile_controller.dart';
import 'package:moneyboi/Screens/profile/friends_page.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final ProfileController _profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'PROFILE',
          style: GoogleFonts.inter(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: moneyBoyPurple,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 38.0,
                backgroundColor: Colors.grey.withOpacity(0.25),
                child: const Icon(
                  Icons.person,
                  size: 32.0,
                  color: moneyBoyPurple,
                ),
              ),
            ),
            if (!_profileController.isProfileLoading.value)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Text(
                      _profileController.name.value,
                      style: GoogleFonts.inter(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      _profileController.email(),
                      style: GoogleFonts.inter(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                  ),
                  if (!_profileController.isFriendsLoading.value)
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(const FriendsPage());
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 18.0,
                          ),
                          child: Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: Colors.grey.withOpacity(0.25),
                            ),
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.person_3,
                                        size: 38.0,
                                      ),
                                      Text(
                                        " View Friends ",
                                        style: GoogleFonts.inter(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  CupertinoIcons.arrow_right_circle,
                                  size: 32.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            if (_profileController.isProfileLoading.value)
              Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
