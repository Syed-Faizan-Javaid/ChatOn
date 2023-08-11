import 'package:flutter/material.dart';

class LoadingOverlay {
  OverlayEntry? _overlay;
  void show(BuildContext context) {
    if (_overlay == null) {
      _overlay = OverlayEntry(
        builder: (context) => SafeArea(
          child: ColoredBox(
            color: Colors.black12.withOpacity(0.1),
            child: Center(
                child: Image.asset(
              "assets/icons/loading.gif",
              height: 90,
              width: 90,
            )),
          ),
        ),
      );
      Overlay.of(context).insert(_overlay!);
    }
  }

  void hide() {
    if (_overlay != null) {
      _overlay!.remove();
      _overlay = null;
    }
  }
}
