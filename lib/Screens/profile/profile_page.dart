import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Controllers/profile_controller.dart';
import 'package:moneyboi/Screens/profile/friends_page.dart';
// import 'package:moneyboi/Theme/light_theme.dart';
import 'package:moneyboi/Theme/theme_controller.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final ProfileController _profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: _theme.backgroundColor,
        iconTheme: IconThemeData(
          color: _theme.colorScheme.secondary,
        ),
        title: Text(
          'PROFILE',
          style: GoogleFonts.inter(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: moneyBoyPurple,
          ),
        ),
      ),
      backgroundColor: _theme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 38.0,
                backgroundColor: Colors.grey.withOpacity(0.25),
                child: Icon(
                  Icons.person,
                  size: 32.0,
                  color: _theme.primaryColorLight,
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
                        color: _theme.colorScheme.secondary.withOpacity(0.8),
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
                        color: _theme.colorScheme.secondary.withOpacity(0.8),
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
                                          color: _theme.colorScheme.secondary
                                              .withOpacity(0.8),
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
                  const SizedBox(
                    height: 20.0,
                  ),
                  GetBuilder<ThemeController>(
                    builder: (controller) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Theme",
                                style: TextStyle(
                                  // fontFamily: 'Segoe',
                                  fontSize: 20.0,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 500),
                                  switchInCurve: Curves.easeInSine,
                                  switchOutCurve: Curves.easeOutSine,
                                  transitionBuilder: (
                                    Widget child,
                                    Animation<double> animation,
                                  ) {
                                    // return ScaleTransition(
                                    //   scale: animation,
                                    //   child: child,
                                    // );

                                    final offsetAnimation = Tween<Offset>(
                                      begin: const Offset(0.0, 0.8),
                                      end: Offset.zero,
                                    ).animate(animation);
                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                  child: controller.currentTheme.value
                                      ? Icon(
                                          Icons.sunny,
                                          key: UniqueKey(),
                                          size: 30.0,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        )
                                      : Icon(
                                          Icons.nightlight,
                                          key: UniqueKey(),
                                          size: 30.0,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
                                ),
                                const SizedBox(
                                  width: 6.0,
                                ),
                                CupertinoSwitch(
                                  value: controller.currentTheme.value,
                                  trackColor: Theme.of(context).primaryColor,
                                  activeColor: Theme.of(context).highlightColor,
                                  onChanged: (val) async {
                                    controller.toggleTheme();
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            if (_profileController.isProfileLoading.value)
              Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: _theme.colorScheme.secondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
