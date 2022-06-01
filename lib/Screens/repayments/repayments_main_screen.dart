import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Controllers/repayments_main_controller.dart';
import 'package:moneyboi/Data%20Models/repayment_detail.dart';
import 'package:moneyboi/Screens/repayments/repayments_single_screen.dart';

class RepaymentsMainScreen extends StatelessWidget {
  const RepaymentsMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'REPAYMENTS',
          style: GoogleFonts.inter(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: moneyBoyPurple,
          ),
        ),
      ),
      backgroundColor: Colors.white,
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
            return ListView.builder(
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
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    Get.to(
                      RepaymentSingleScreen(
                        repayId: controller.repaymentAccounts[index - 1].id,
                      ),
                    );
                  },
                  child: RepaymentListTile(
                    account: controller.repaymentAccounts[index - 1],
                  ),
                );
              },
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
                    color: Colors.black,
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
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
          Text(
            " ${account.balance > 0 ? '+' : '-'} ${account.balance} ₹",
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
