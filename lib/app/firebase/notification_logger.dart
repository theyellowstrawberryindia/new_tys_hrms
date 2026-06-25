/*
 *  Created by Yellow Strawberry LLP on 23/06/26, 3:28 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 23/06/26, 3:28 pm
 *
 */

class NotificationLogger {

  static void log(
      Map<String, dynamic> data) {

    print(
      "==============================",
    );

    print(
      "FCM RECEIVED",
    );

    print(data);

    print(
      "==============================",
    );
  }
}