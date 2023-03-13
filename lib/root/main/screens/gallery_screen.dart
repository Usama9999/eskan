import 'package:flutter/material.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _PageViewDemoState createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<GalleryScreen> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        Container(
          color: Colors.black,
        ),
        Container(
          color: Colors.teal,
        ),
        Container(
          color: Colors.red,
        ),
      ],
    );
  }
}
