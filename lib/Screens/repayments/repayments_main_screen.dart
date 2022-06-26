import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Controllers/profile_controller.dart';
import 'package:moneyboi/Controllers/repayments_main_controller.dart';
import 'package:moneyboi/Data%20Models/repayment_detail.dart';
import 'package:moneyboi/Screens/repayments/repayments_single_screen.dart';

class RepaymentsMainScreen extends StatelessWidget {
  const RepaymentsMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: _theme.backgroundColor,
        iconTheme: IconThemeData(color: _theme.colorScheme.secondary),
        title: Text(
          'REPAYMENTS',
          style: GoogleFonts.inter(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: moneyBoyPurple,
          ),
        ),
      ),
      backgroundColor: _theme.backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              final list = Get.find<ProfileController>().friendList;
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: GetBuilder<RepaymentsMainController>(
                  builder: (controller) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            "Start new repayment account",
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
                            "Create a new repayment account to track your transactions. Select a friend and we will create a repayment account for both of you.",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.montserrat(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: _theme.colorScheme.secondary
                                  .withOpacity(0.85),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        const SizedBox(height: 24.0),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: list.map((friend) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24.0,
                                    horizontal: 12.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              friend.name,
                                              style: GoogleFonts.inter(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w700,
                                                color: _theme
                                                    .colorScheme.secondary
                                                    .withOpacity(0.85),
                                              ),
                                            ),
                                            Text(
                                              friend.email,
                                              style: GoogleFonts.inter(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
                                                color: _theme
                                                    .colorScheme.secondary
                                                    .withOpacity(0.75),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          controller
                                              .addRepaymentAcc(friend.email);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                            vertical: 8.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: moneyBoyPurple,
                                            borderRadius: BorderRadius.circular(
                                              18.0,
                                            ),
                                          ),
                                          child: Text(
                                            "Select",
                                            style: GoogleFonts.inter(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              );
            },
          );
        },
        backgroundColor: moneyBoyPurple,
        elevation: 1.0,
        child: Icon(
          Icons.add,
          color: _theme.backgroundColor.withOpacity(0.7),
          size: 42.0,
        ),
      ),
      body: GetBuilder<RepaymentsMainController>(
        initState: (_) {
          Get.find<RepaymentsMainController>().init();
        },
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                controller.init();
              },
              child: ListView.builder(
                itemCount: controller.repaymentAccounts.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        ' Your Repayment Accounts',
                        style: GoogleFonts.inter(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: _theme.colorScheme.secondary.withOpacity(0.7),
                        ),
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RepaymentSingleScreen(
                            repayAccount:
                                controller.repaymentAccounts[index - 1],
                          ),
                        ),
                      );
                      controller.init();
                    },
                    child: RepaymentListTile(
                      account: controller.repaymentAccounts[index - 1],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class RepaymentListTile extends StatelessWidget {
  const RepaymentListTile({
    Key? key,
    required this.account,
  }) : super(key: key);
  final RepaymentAccount account;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(
        left: 12.0,
        right: 8.0,
        top: 16.0,
        bottom: 16.0,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
        color: Colors.grey.withOpacity(0.15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You + ${account.friend.name}",
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  style: GoogleFonts.montserrat(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: _theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  DateFormat('yMMMd').format(account.createdAt),
                  style: GoogleFonts.montserrat(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: _theme.colorScheme.secondary.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
          Text(
            " ${account.balance == 0 ? '' : account.balance > 0 ? '+' : '-'} ${account.balance.abs()} ₹",
            style: GoogleFonts.montserrat(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: account.balance > 0 ? Colors.green : Colors.red,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 18.0,
            ),
          )
        ],
      ),
    );
  }
}
