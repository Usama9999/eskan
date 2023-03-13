import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../cache/cache_manager.dart';
import '../design_util.dart';
import '../input_widget/text_widget.dart';

class AppBarWidget extends StatefulWidget with PreferredSizeWidget {
  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            PreferredSize(
              preferredSize: const Size.fromHeight(20),
              child: Column(
                children: [
                  Padding(
                    padding: UiUtils.getDeviceBasedPadding(20, 10, 20, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          child: Icon(Icons.arrow_back_ios),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
