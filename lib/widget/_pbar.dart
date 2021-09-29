// Copyright 2020 J-P Nurmi <jpnurmi@gmail.com>
//
// Based on flutter/lib/cupertino/slider.dart
// https://github.com/jpnurmi/cupertino_progress_bar
//
// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// An iOS-style progress bar.
///
/// {@macro cupertino_progress_bar.CupertinoProgressBar}
class CupertinoProgressBar extends StatefulWidget {
  /// Creates an iOS-style progress bar.
  ///
  /// The [value] argument can either be null for an indeterminate
  /// progress indicator, or non-null for a determinate progress
  /// indicator.
  ///
  /// ## Accessibility
  ///
  /// The [semanticsLabel] can be used to identify the purpose of this progress
  /// bar for screen reading software. The [semanticsValue] property may be used
  /// for determinate progress indicators to indicate how much progress has been made.
  const CupertinoProgressBar({
    Key? key,
    this.value = 0.0,
    this.trackColor = CupertinoColors.systemFill,
    this.valueColor,
    this.semanticsLabel,
    this.semanticsValue,
  })  : assert(value >= 0.0 && value <= 1.0),
        super(key: key);

  /// The value of this progress bar.
  ///
  /// A value of 0.0 means no progress and 1.0 means that progress is complete.
  final double value;

  /// The progress bar's background color.
  ///
  /// The [CupertinoColors.systemFill] color by default.
  final Color? trackColor;

  /// The progress bar's value color.
  ///
  /// The current theme's [CupertinoThemeData.primaryColor] by default.
  final Color? valueColor;

  /// {@macro flutter.material.progressIndicator.semanticsLabel}
  final String? semanticsLabel;

  /// {@macro flutter.material.progressIndicator.semanticsValue}
  final String? semanticsValue;

  @override
  _CupertinoProgressBarState createState() => _CupertinoProgressBarState();
}

class _CupertinoProgressBarState extends State<CupertinoProgressBar> {
  @override
  Widget build(BuildContext context) {
    String? expandedSemanticsValue = widget.semanticsValue;
    expandedSemanticsValue ??= '${(widget.value * 100).round()}%';
    return Semantics(
      label: widget.semanticsLabel,
      value: expandedSemanticsValue,
      child: _CupertinoProgressBarRenderObjectWidget(
        value: widget.value,
        valueColor: CupertinoDynamicColor.resolve(
          widget.valueColor ?? CupertinoTheme.of(context).primaryColor,
          context,
        ),
        trackColor: CupertinoDynamicColor.resolve(
          widget.trackColor ?? Color(0x00000000),
          context,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(PercentProperty('value', widget.value, showName: false));
  }
}

class _CupertinoProgressBarRenderObjectWidget extends LeafRenderObjectWidget {
  const _CupertinoProgressBarRenderObjectWidget({
    Key? key,
    required this.value,
    this.valueColor,
    this.trackColor,
  }) : super(key: key);

  final double value;
  final Color? valueColor;
  final Color? trackColor;

  @override
  _RenderCupertinoProgressBar createRenderObject(BuildContext context) {
    return _RenderCupertinoProgressBar(
      value: value,
      valueColor: valueColor,
      trackColor: trackColor,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderCupertinoProgressBar renderObject) {
    renderObject
      ..value = value
      ..valueColor = valueColor
      ..trackColor = trackColor
      ..textDirection = Directionality.of(context);
  }
}

const double _kPadding = 0.0;
const double _kBarHeight = 2.0;
const double _kBarWidth = 176.0; // Matches Material Design slider.

class _RenderCupertinoProgressBar extends RenderConstrainedBox {
  _RenderCupertinoProgressBar({
    required double value,
    Color? valueColor,
    Color? trackColor,
    required TextDirection textDirection,
  })  : assert(value >= 0.0 && value <= 1.0),
        _value = value,
        _valueColor = valueColor,
        _trackColor = trackColor,
        _textDirection = textDirection,
        super(
            additionalConstraints: const BoxConstraints.tightFor(
                width: _kBarWidth, height: _kBarHeight));

  double get value => _value;
  double _value;
  set value(double newValue) {
    assert(newValue >= 0.0 && newValue <= 1.0);
    if (newValue == _value) return;
    _value = newValue;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  Color? get valueColor => _valueColor;
  Color? _valueColor;
  set valueColor(Color? value) {
    if (value == _valueColor) return;
    _valueColor = value;
    markNeedsPaint();
  }

  Color? get trackColor => _trackColor;
  Color? _trackColor;
  set trackColor(Color? value) {
    if (value == _trackColor) return;
    _trackColor = value;
    markNeedsPaint();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsPaint();
  }

  double get _trackLeft => _kPadding;
  double get _trackRight => size.width - _kPadding;
  double? get _thumbCenter {
    double? visualPosition;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - _value;
        break;
      case TextDirection.ltr:
        visualPosition = _value;
        break;
    }
    return lerpDouble(_trackLeft, _trackRight, visualPosition);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    double? visualPosition;
    Color? leftColor;
    Color? rightColor;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - _value;
        leftColor = _valueColor;
        rightColor = trackColor;
        break;
      case TextDirection.ltr:
        visualPosition = _value;
        leftColor = trackColor;
        rightColor = _valueColor;
        break;
    }

    final double trackCenter = offset.dy + size.height / 2.0;
    final double trackLeft = offset.dx + _trackLeft;
    final double trackTop = max(0, trackCenter - 1.0);
    final double trackBottom = min(offset.dy + size.height, trackCenter + 1.0);
    final double trackRight = offset.dx + _trackRight;
    final double trackActive = offset.dx + _thumbCenter!;

    final Canvas canvas = context.canvas;

    if (visualPosition > 0.0 && rightColor != null) {
      final Paint paint = Paint()..color = rightColor;
      canvas.drawRRect(
          RRect.fromLTRBXY(
              trackLeft, trackTop, trackActive, trackBottom, 1.0, 1.0),
          paint);
    }

    if (visualPosition < 1.0 && leftColor != null) {
      final Paint paint = Paint()..color = leftColor;
      canvas.drawRRect(
          RRect.fromLTRBXY(
              trackActive, trackTop, trackRight, trackBottom, 1.0, 1.0),
          paint);
    }
  }
}
