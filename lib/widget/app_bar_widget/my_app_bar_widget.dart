import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../cache/cache_manager.dart';
import '../design_util.dart';
import '../input_widget/text_widget.dart';

class MyAppBarWidget extends StatefulWidget with PreferredSizeWidget {
  String appBarTitle;
  bool addBackArrow;
  MyAppBarWidget({required this.appBarTitle, this.addBackArrow = false});

  @override
  State<MyAppBarWidget> createState() => _MyAppBarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MyAppBarWidgetState extends State<MyAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: UiUtils.getDeviceBasedPadding(10, 20, 20, 0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      if (widget.addBackArrow)
                        GestureDetector(
                          child: Icon(Icons.arrow_back_ios),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      const Spacer(),
                      TextWidget(
                        text: widget.appBarTitle,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
