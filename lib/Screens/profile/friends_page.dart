import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Controllers/profile_controller.dart';
import 'package:moneyboi/Widgets/big_bar_button.dart';
import 'package:moneyboi/Widgets/text_field_widget.dart';

final scaffoldState = GlobalKey<ScaffoldState>();

class FriendsPage extends StatelessWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'FRIENDS',
          style: GoogleFonts.inter(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: moneyBoyPurple,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        "Search for friends",
                        style: GoogleFonts.inter(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          color: moneyBoyPurple,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "It's always more fun with friends. You can search for friends using their registered email id.",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.montserrat(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withOpacity(0.85),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    TextFieldWidget(
                      controller: TextEditingController(),
                      hint: "Enter Friend's Email",
                      inputType: TextInputType.emailAddress,
                      horizontalMargin: 24.0,
                      verticalPadding: 8.0,
                      fontSize: 20.0,
                      hintFontSize: 18.0,
                    ),
                    const SizedBox(height: 24.0),
                    GestureDetector(
                      onTap: () {},
                      child: BigBarButtonBody(
                        horizontalPadding: 32.0,
                        child: Text(
                          "Search",
                          style: GoogleFonts.inter(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: moneyBoyPurple,
        elevation: 1.0,
        child: const Icon(
          Icons.add,
          size: 42.0,
        ),
      ),
      body: Column(
        children: [
          GetBuilder<ProfileController>(
            builder: (controller) {
              final int _tabIndex = controller.friendsTabIndex.value;
              return Row(
                children: [
                  TabLabel(
                    isActive: _tabIndex == 0,
                    labelText: "Friends",
                    onTap: () => controller.changeFriendTab(0),
                  ),
                  TabLabel(
                    isActive: _tabIndex == 1,
                    labelText: "Requests",
                    onTap: () => controller.changeFriendTab(1),
                  ),
                ],
              );
            },
          ),
          GetBuilder<ProfileController>(
            builder: (controller) {
              return controller.friendsTabIndex.value == 0
                  ? buildFriends(controller)
                  : buildRequests(controller);
            },
          ),
        ],
      ),
    );
  }

  Expanded buildFriends(ProfileController controller) {
    return Expanded(
      child: controller.isFriendsLoading.value
          ? Container()
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: controller.friendList
                    .map(
                      (friend) => Padding(
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
                            children: [
                              const Icon(
                                CupertinoIcons.person_circle_fill,
                                size: 42.0,
                              ),
                              const SizedBox(
                                width: 16.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    friend.name,
                                    style: GoogleFonts.inter(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                  Text(
                                    friend.email,
                                    style: GoogleFonts.inter(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }

  Expanded buildRequests(ProfileController controller) {
    return Expanded(
      child: controller.isFriendsLoading.value
          ? Container()
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: controller.pendingList
                        .map(
                          (friend) => Padding(
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
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.person_circle_fill,
                                        size: 42.0,
                                      ),
                                      const SizedBox(
                                        width: 16.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            friend.name,
                                            style: GoogleFonts.inter(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                            ),
                                          ),
                                          Text(
                                            friend.email,
                                            style: GoogleFonts.inter(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0.0,
                                          primary: moneyBoyPurple,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0,
                                            vertical: 10.0,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          'Accept',
                                          style: GoogleFonts.inter(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0.0,
                                          primary: Colors.red.withOpacity(0.7),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0,
                                            vertical: 10.0,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          'Decline',
                                          style: GoogleFonts.inter(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Column(
                    children: controller.requestedList
                        .map(
                          (friend) => Padding(
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
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.person_circle_fill,
                                        size: 42.0,
                                      ),
                                      const SizedBox(
                                        width: 16.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            friend.name,
                                            style: GoogleFonts.inter(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                            ),
                                          ),
                                          Text(
                                            friend.email,
                                            style: GoogleFonts.inter(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 32.0,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.grey.withOpacity(0.35),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Friend request sent ",
                                          style: GoogleFonts.inter(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                        ),
                                        Icon(
                                          Icons.check,
                                          color: Colors.black.withOpacity(0.5),
                                          size: 20.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
    );
  }
}

class TabLabel extends StatelessWidget {
  const TabLabel({
    Key? key,
    required this.isActive,
    required this.labelText,
    required this.onTap,
  }) : super(key: key);

  final bool isActive;
  final String labelText;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Column(
          children: [
            Text(
              labelText,
              style: GoogleFonts.inter(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0),
              height: 3.0,
              width: double.maxFinite,
              color: isActive ? moneyBoyPurple : null,
            ),
          ],
        ),
      ),
    );
  }
}
