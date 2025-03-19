import 'dart:ui' as ui;

import 'package:flutter/material.dart';

 Widget backdropFilterExample(BuildContext context, Widget child) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        child,
        BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: 8.0,
            sigmaY: 8.0,
          ),
          child: Container(
            color: Colors.transparent,
          ),
        )
      ],
    );
  }