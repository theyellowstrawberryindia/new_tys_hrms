/*
 *  Created by Yellow Strawberry LLP on 21/05/26, 6:59 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 21/05/26, 6:59 pm
 *
 */
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime? {

  String get toReadAbleDate {
    if(this==null) return '';
    return DateFormat('dd MMM yyyy').format(this!.toLocal());
  }

  String get toReadAbleTime {
    if(this==null) return '';
    return DateFormat('HH:mm a').format(this!.toLocal());
  }

  String get toReadAbleDateTime {
    if (this == null) return '';
    return DateFormat('dd-MM-yyyy hh:mm:ss a')
        .format(this!.toLocal());
  }

  String get toCurrentDate {
    final d = DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(d.toLocal());
  }
}
