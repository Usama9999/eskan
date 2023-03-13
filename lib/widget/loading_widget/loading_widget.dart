import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../constants/app_colors.dart';

class LoadingWidget {
  BuildContext context;

  LoadingWidget(this.context);

  showProgressIndicator() {
    debugPrint("showProgressIndicator");
    showDialog(
        useRootNavigator: false,
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black26,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: LoadingIndicator(),
          );
        });
  }

  hideProgressIndicator() {
    debugPrint("hideProgressIndicator");
    try {
      Navigator.pop(context);
    } catch (_) {
      print(_.toString());
    }
  }
}

class LoadingIndicator extends StatefulWidget {
  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
            child: SpinKitDoubleBounce(color: AppColors.appSecondaryColor)),
      ],
    );
  }
}
