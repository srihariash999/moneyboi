import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Controllers/profile_controller.dart';
import 'package:moneyboi/Controllers/repayment_single_controller.dart';
import 'package:moneyboi/Data%20Models/repayment_detail.dart';
import 'package:moneyboi/Data%20Models/repayment_transaction.dart';
import 'package:moneyboi/Widgets/big_bar_button.dart';
import 'package:moneyboi/Widgets/text_field_widget.dart';

class RepaymentSingleScreen extends StatelessWidget {
  const RepaymentSingleScreen({
    Key? key,
    required this.repayAccount,
  }) : super(key: key);
  final RepaymentAccount repayAccount;

  void showSheet({required BuildContext context, required bool giving}) {
    final TextEditingController _amountController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'New Repayment Transaction',
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GetBuilder<RepaymentsSingleController>(
                  builder: (controller) {
                    return Column(
                      children: [
                        TextFieldWidget(
                          controller: _amountController,
                          horizontalMargin: 32.0,
                          verticalPadding: 8.0,
                          inputType: TextInputType.number,
                          label: "Amount",
                          hint: "Enter amount in Rupees",
                        ),
                        const SizedBox(
                          height: 32.0,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (_amountController.text.isEmpty) {
                              BotToast.showText(text: "Amount cannot be empty");
                            } else {
                              if (giving) {
                                await controller.addNewTransaction(
                                  repayAccount.id,
                                  int.parse(_amountController.text),
                                  context,
                                );
                              } else {
                                await controller.addNewTransaction(
                                  repayAccount.id,
                                  int.parse(_amountController.text) * -1,
                                  context,
                                );
                              }
                            }
                          },
                          child: BigBarButtonBody(
                            horizontalPadding: 64.0,
                            child: controller.isSubmitLoading
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: const LinearProgressIndicator(
                                      backgroundColor: moneyBoyPurple,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    giving ? 'GIVE' : 'TAKE',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showOptionDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          content: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.0),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 48.0,
              horizontal: 24.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    showSheet(context: context, giving: true);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    margin: const EdgeInsets.only(
                      left: 4.0,
                      right: 4.0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: 10.0,
                    ),
                    child: Text(
                      "GIVE",
                      style: GoogleFonts.inter(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    showSheet(context: context, giving: false);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    margin: const EdgeInsets.only(
                      right: 4.0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: 10.0,
                    ),
                    child: Text(
                      "TAKE",
                      style: GoogleFonts.inter(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: GetBuilder<RepaymentsSingleController>(
          initState: (_) {
            Get.find<RepaymentsSingleController>().init(
              repayAccount,
            );
          },
          builder: (controller) {
            if (controller.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        ' Your Repayment Accounts',
                        style: GoogleFonts.inter(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      controller: controller.scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.repayTransactions.length,
                      itemBuilder: (context, index) {
                        final RepaymentTransaction _transaction =
                            controller.repayTransactions[index];
                        final _isUser1 =
                            Get.find<ProfileController>().id.value ==
                                _transaction.user1;
                        return RepaymentHistoryListTile(
                          giving: _isUser1
                              ? _transaction.user1Transaction > 0
                              : _transaction.user2Transaction > 0,
                          amount: _isUser1
                              ? _transaction.user1Transaction
                              : _transaction.user2Transaction,
                          date: DateFormat('yMMMd').format(
                            _transaction.createdAt,
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                              color: Colors.black.withOpacity(0.4),
                            ),
                            borderRadius: BorderRadius.circular(14.0),
                            color: controller.repayAccount.value.balance > 0
                                ? Colors.green.withOpacity(0.25)
                                : Colors.red.withOpacity(0.25),
                          ),
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 4.0,
                            top: 12.0,
                            bottom: 12.0,
                          ),
                          margin: const EdgeInsets.only(
                            left: 8.0,
                            right: 4.0,
                          ),
                          child: Text(
                            controller.repayAccount.value.balance == 0
                                ? "You owe each other nothing."
                                : controller.repayAccount.value.balance > 0
                                    ? "${controller.repayAccount.value.friend.name} owes you ₹ ${controller.repayAccount.value.balance}"
                                    : "You owe ${controller.repayAccount.value.friend.name} ₹ ${controller.repayAccount.value.balance} ",
                            style: GoogleFonts.inter(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: controller.repayAccount.value.balance > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showOptionDialog(context);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: moneyBoyPurple,
                          ),
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(
                            right: 8.0,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 32.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class RepaymentHistoryListTile extends StatelessWidget {
  const RepaymentHistoryListTile({
    Key? key,
    required this.amount,
    required this.giving,
    required this.date,
  }) : super(key: key);
  final bool giving;
  final int amount;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          giving ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            left: 12.0,
            right: 32.0,
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
          child: Column(
            crossAxisAlignment:
                giving ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (giving)
                    Text(
                      "You gave",
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: GoogleFonts.montserrat(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  RotatedBox(
                    quarterTurns: giving ? 0 : 2,
                    child: Icon(
                      Icons.arrow_right_alt,
                      color: giving ? Colors.green : Colors.red,
                    ),
                  ),
                  if (!giving)
                    Text(
                      "You took",
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: GoogleFonts.montserrat(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "${amount < 0 ? amount * -1 : amount}",
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: GoogleFonts.montserrat(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w600,
                      color: giving ? Colors.green : Colors.red,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "₹",
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: GoogleFonts.montserrat(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: giving ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                date,
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: GoogleFonts.montserrat(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
