import 'package:flutter/widgets.dart';

import 'transitions.dart';

abstract class BaseReorderableMixin {
  Widget makeAppearingWidget(
      Widget child,
      AnimationController entranceController,
      Size? draggingFeedbackSize,
      Axis direction,
      {int? index}
      );

  Widget makeDisappearingWidget(
      Widget child,
      AnimationController ghostController,
      Size? draggingFeedbackSize,
      Axis direction,
      {int? index}
      );

  double getDraggingOpacity();
}

mixin ReorderableMixin implements BaseReorderableMixin {

  @override
  Widget makeAppearingWidget(
      Widget child,
      AnimationController entranceController,
      Size? draggingFeedbackSize,
      Axis direction,
      {int? index}
      ) {
    if (null == draggingFeedbackSize) {
      return SizeTransitionWithIntrinsicSize(
        sizeFactor: entranceController,
        axis: direction,
        child: FadeTransition(
          opacity: entranceController,
          child: child,
        ),
      );
    } else {
      var transition = SizeTransition(
        sizeFactor: entranceController,
        axis: direction,
        child: FadeTransition(opacity: entranceController, child: child),
      );

      BoxConstraints contentSizeConstraints = BoxConstraints.loose(draggingFeedbackSize);
      return ConstrainedBox(constraints: contentSizeConstraints, child: transition);
    }
  }

  @protected
  @override
  Widget makeDisappearingWidget(
      Widget child,
      AnimationController ghostController,
      Size? draggingFeedbackSize,
      Axis direction,
      {int? index}
      ) {
    if (null == draggingFeedbackSize) {
      return SizeTransitionWithIntrinsicSize(
        sizeFactor: ghostController,
        axis: direction,
        child: FadeTransition(
          opacity: ghostController,
          child: child,
        ),
      );
    } else {
      var transition = SizeTransition(
        sizeFactor: ghostController,
        axis: direction,
        child: FadeTransition(opacity: ghostController, child: child),
      );

      BoxConstraints contentSizeConstraints =
      BoxConstraints.loose(draggingFeedbackSize);
      return ConstrainedBox(
          constraints: contentSizeConstraints, child: transition);
    }
  }

  double getDraggingOpacity() {
    return 0.2;
  }
}
