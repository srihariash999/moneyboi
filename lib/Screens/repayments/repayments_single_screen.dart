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

  void showSheet({
    required BuildContext context,
    required bool giving,
  }) {
    final TextEditingController _amountController = TextEditingController();
    final TextEditingController _noteController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final ThemeData _theme = Theme.of(context);
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'New Repayment Transaction',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color:
                                _theme.colorScheme.secondary.withOpacity(0.7),
                          ),
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
                    final ThemeData _theme = Theme.of(context);
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFieldWidget(
                            controller: _amountController,
                            horizontalMargin: 32.0,
                            // verticalPadding: 4.0,
                            inputType: TextInputType.number,
                            label: "Amount",
                            hint: "Enter amount in Rupees",
                          ),
                          const SizedBox(
                            height: 32.0,
                          ),
                          TextFieldWidget(
                            controller: _noteController,
                            horizontalMargin: 32.0,
                            // verticalPadding: 4.0,
                            label: "Note",
                            hint: "Enter a note",
                          ),
                          const SizedBox(
                            height: 32.0,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (_amountController.text.isEmpty) {
                                BotToast.showText(
                                  text: "Amount cannot be empty",
                                );
                              } else {
                                if (giving) {
                                  await controller.addNewTransaction(
                                    repayAccount.id,
                                    int.parse(_amountController.text),
                                    context,
                                    _noteController.text.trim(),
                                  );
                                } else {
                                  await controller.addNewTransaction(
                                    repayAccount.id,
                                    int.parse(_amountController.text) * -1,
                                    context,
                                    _noteController.text.trim(),
                                  );
                                }
                              }
                            },
                            child: BigBarButtonBody(
                              horizontalPadding: 64.0,
                              child: controller.isSubmitLoading
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: LinearProgressIndicator(
                                        backgroundColor: moneyBoyPurple,
                                        color: _theme.colorScheme.background,
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
                          SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom,
                          ),
                        ],
                      ),
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
        final ThemeData _theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: _theme.colorScheme.secondary,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(18.0),
          ),
          backgroundColor: _theme.colorScheme.background,
          elevation: 0.0,
          content: Container(
            decoration: BoxDecoration(
              color: _theme.colorScheme.background,
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
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: _theme.colorScheme.background,
        iconTheme: IconThemeData(color: _theme.colorScheme.secondary),
        title: Text(
          "You + ${repayAccount.friend.name}",
          style: GoogleFonts.inter(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: moneyBoyPurple,
          ),
        ),
      ),
      backgroundColor: _theme.colorScheme.background,
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
              return Center(
                child: CircularProgressIndicator(
                  color: _theme.colorScheme.secondary,
                ),
              );
            } else {
              return Column(
                children: [
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
                        // if (_transaction.id == "62b83899163b3fefb921c0b9") {
                        // print(_transaction.toJson());
                        // }
                        final bool _giving = _isUser1
                            ? _transaction.user1Transaction > 0
                            : _transaction.user2Transaction > 0;
                        return RepaymentHistoryListTile(
                          id: _transaction.id,
                          giving: _giving,
                          amount: _isUser1
                              ? _transaction.user1Transaction
                              : _transaction.user2Transaction,
                          pending: _transaction.user1Accepted == false ||
                              _transaction.user2Accepted == false,
                          date: "${DateFormat('yMMMd').format(
                            _transaction.createdAt,
                          )} - ${DateFormat('hh:mm').format(
                            _transaction.createdAt,
                          )}",
                          note: _transaction.note,
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
                              color:
                                  _theme.colorScheme.secondary.withOpacity(0.4),
                            ),
                            borderRadius: BorderRadius.circular(14.0),
                            color: controller.repayAccount.value.balance == 0
                                ? _theme.colorScheme.background
                                : controller.repayAccount.value.balance > 0
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
                                    ? "${controller.repayAccount.value.friend.name} owes you ₹ ${controller.repayAccount.value.balance.abs()}"
                                    : "You owe ${controller.repayAccount.value.friend.name} ₹ ${controller.repayAccount.value.balance.abs()} ",
                            style: GoogleFonts.inter(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: controller.repayAccount.value.balance == 0
                                  ? _theme.colorScheme.secondary
                                  : controller.repayAccount.value.balance > 0
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
                          child: Icon(
                            Icons.add,
                            color: _theme.colorScheme.background,
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
  RepaymentHistoryListTile({
    Key? key,
    required this.amount,
    required this.giving,
    required this.date,
    required this.pending,
    required this.id,
    required this.note,
  }) : super(key: key);
  final bool giving;
  final int amount;
  final String date;
  final bool pending;
  final String id;
  final String? note;

  Color getColor() {
    if (pending) {
      return Colors.orange;
    }
    if (giving) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  final RepaymentsSingleController controller =
      Get.find<RepaymentsSingleController>();

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Row(
      mainAxisAlignment: pending
          ? MainAxisAlignment.center
          : giving
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
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
            crossAxisAlignment: pending
                ? CrossAxisAlignment.center
                : giving
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            children: [
              // TOP DESCRIPTION
              Row(
                children: [
                  if (pending)
                    Text(
                      "Pending Consent",
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: GoogleFonts.montserrat(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: getColor(),
                      ),
                    ),
                  if (giving && !pending)
                    Text(
                      "You gave",
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: GoogleFonts.montserrat(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: getColor(),
                      ),
                    ),
                  if (!pending)
                    RotatedBox(
                      quarterTurns: giving ? 0 : 2,
                      child: Icon(
                        Icons.arrow_right_alt,
                        color: getColor(),
                      ),
                    ),
                  if (!giving && !pending)
                    Text(
                      "You took",
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: GoogleFonts.montserrat(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: getColor(),
                      ),
                    ),
                ],
              ),

              // AMOUNT TEXT
              Row(
                children: [
                  Text(
                    "${amount < 0 ? amount * -1 : amount}",
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: GoogleFonts.montserrat(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w600,
                      color: getColor(),
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
                        color: getColor(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4.0,
              ),

              if (note != null && note!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: Text(
                    note!,
                    maxLines: 3,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: _theme.colorScheme.secondary,
                    ),
                  ),
                ),

              if (pending && !giving)
                GestureDetector(
                  onTap: () async {
                    await controller.consentToTransaction(id: id);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                      color: moneyBoyPurple,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      "Give Consent",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _theme.colorScheme.background,
                      ),
                    ),
                  ),
                ),

              // DATE TEXT
              Text(
                date,
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: GoogleFonts.montserrat(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: _theme.colorScheme.secondary.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
