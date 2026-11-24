/*
 *  Created by Yellow Strawberry LLP on 06/06/26, 1:51 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 06/06/26, 1:51 pm
 *
 */

class UpdateItem {
  int? id;

  String? userid;

  String? email;

  /// Common
  String? status;
  String? label;
  String? reason;
  String? comment;
  String? createdAt;
  String? updatedAt;
  String? src;

  /// Leave
  String? startDate;
  String? endDate;
  String? appliedOn;

  /// Regularization
  String? attId;
  String? attDate;
  String? regType;
  String? inTime;
  String? outTime;
  String? image;

  /// Reimbursement
  String? upiId;
  String? expenseDate;
  String? expenseItem;
  String? expenseCost;
  String? quantity;
  String? sum;
  String? receipt;
  String? totalAmt;
  String? refNo;

  UpdateItem({
    this.id,
    this.userid,
    this.email,
    this.status,
    this.label,
    this.reason,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.src,
    this.startDate,
    this.endDate,
    this.appliedOn,
    this.attId,
    this.attDate,
    this.regType,
    this.inTime,
    this.outTime,
    this.image,
    this.upiId,
    this.expenseDate,
    this.expenseItem,
    this.expenseCost,
    this.quantity,
    this.sum,
    this.receipt,
    this.totalAmt,
    this.refNo,
  });

  factory UpdateItem.fromJson(Map<String, dynamic> json) {
    return UpdateItem(
      id: json['id'],

      userid: json['userid']?.toString(),

      email: json['email']?.toString(),

      status: json['status']?.toString(),

      label: json['label']?.toString(),

      reason: json['reason']?.toString(),

      comment: json['comment']?.toString(),

      createdAt: json['created_at']?.toString(),

      updatedAt: json['updated_at']?.toString(),

      src: json['src']?.toString(),

      /// Leave
      startDate: json['start_date']?.toString(),

      endDate: json['end_date']?.toString(),

      appliedOn: json['appliedOn']?.toString(),

      /// Regularization
      attId: json['att_id']?.toString(),

      attDate: json['att_date']?.toString(),

      regType: json['reg_type']?.toString(),

      inTime: json['in_time']?.toString(),

      outTime: json['out_time']?.toString(),

      image: json['image']?.toString(),

      /// Reimbursement
      upiId: json['upi_id']?.toString(),

      expenseDate: json['expense_date']?.toString(),

      expenseItem: json['expense_item']?.toString(),

      expenseCost: json['expense_cost']?.toString(),

      quantity: json['quantity']?.toString(),

      sum: json['sum']?.toString(),

      receipt: json['receipt']?.toString(),

      totalAmt: json['total_amt']?.toString(),

      refNo: json['ref_no']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'userid': userid,

      'email': email,

      'status': status,

      'label': label,

      'reason': reason,

      'comment': comment,

      'created_at': createdAt,

      'updated_at': updatedAt,

      'src': src,

      'start_date': startDate,

      'end_date': endDate,

      'appliedOn': appliedOn,

      'att_id': attId,

      'att_date': attDate,

      'reg_type': regType,

      'in_time': inTime,

      'out_time': outTime,

      'image': image,

      'upi_id': upiId,

      'expense_date': expenseDate,

      'expense_item': expenseItem,

      'expense_cost': expenseCost,

      'quantity': quantity,

      'sum': sum,

      'receipt': receipt,

      'total_amt': totalAmt,

      'ref_no': refNo,
    };
  }

  bool get isLeave => label == "LV";

  bool get isRegularization => label == "RG";

  bool get isReimbursement => label == "RM";

  bool get isApproved =>
      (status ?? "").toLowerCase() == "approved";

  bool get isRejected =>
      (status ?? "").toLowerCase() == "rejected";

  bool get isPending =>
      (status ?? "").toLowerCase() == "pending";
}