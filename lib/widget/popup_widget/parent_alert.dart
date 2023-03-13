import 'package:flutter/material.dart';

class ParentAlert {
  BuildContext context;
  Widget body;
  ParentAlert(this.context, this.body) {
    showDialog(
        useRootNavigator: false,
        context: context,
        useSafeArea: false,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return Dialog(
            elevation: 0,
            insetPadding: EdgeInsets.all(0),
            backgroundColor: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: body,
            ),
          );
        });
  }
}
