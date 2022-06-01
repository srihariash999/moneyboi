import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Controllers/profile_controller.dart';
import 'package:moneyboi/Controllers/repayment_single_controller.dart';
import 'package:moneyboi/Controllers/repayments_main_controller.dart';
import 'package:moneyboi/Data%20Models/repayment_detail.dart';
import 'package:moneyboi/Data%20Models/repayment_transaction.dart';

class RepaymentSingleScreen extends StatelessWidget {
  const RepaymentSingleScreen({
    Key? key,
    required this.repayId,
  }) : super(key: key);
  final String repayId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'REPAYMENT HISTORY',
          style: GoogleFonts.inter(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: moneyBoyPurple,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: GetBuilder<RepaymentsSingleController>(
        initState: (_) {
          Get.find<RepaymentsSingleController>().init(
            repayId,
          );
        },
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: controller.repayTransactions.length + 1,
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
                final RepaymentTransaction _transaction =
                    controller.repayTransactions[index - 1];
                final _isUser1 = Get.find<ProfileController>().id.value ==
                    _transaction.user1;
                return RepaymentHistoryListTile(
                  giving: _isUser1
                      ? _transaction.user1Transaction > 0
                      : _transaction.user2Transaction > 0,
                  amount: _isUser1
                      ? _transaction.user1Transaction
                      : _transaction.user2Transaction,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class RepaymentHistoryListTile extends StatelessWidget {
  const RepaymentHistoryListTile({
    Key? key,
    required this.amount,
    required this.giving,
  }) : super(key: key);
  final bool giving;
  final int amount;

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
          Text(
            "",
            maxLines: 2,
            overflow: TextOverflow.fade,
            style: GoogleFonts.montserrat(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
