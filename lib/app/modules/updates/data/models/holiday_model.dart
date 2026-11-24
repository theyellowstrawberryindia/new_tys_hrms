/*
 *  Created by Yellow Strawberry LLP on 06/06/26, 1:51 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 06/06/26, 1:51 pm
 *
 */

class HolidayData {
  int? id;
  String? holidayDate;
  String? holidayName;
  String? month;
  String? year;

  HolidayData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    holidayDate = json['holiday_date'];
    holidayName = json['holiday_name'];
    month = json['month'];
    year = json['year'];
  }
}