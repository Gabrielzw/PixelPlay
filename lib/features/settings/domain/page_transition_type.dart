enum PageTransitionType {
  rightToLeftCupertino,
  rightToLeft,
  leftToRight,
  leftToRightCupertino,
  upToDown,
  downToUp,
  scale,
  rotate,
  size,
  rightToLeftWithFade,
  leftToRightWithFade,
  upToDownWithFade,
  downToUpWithFade,
  none,
}

const PageTransitionType kDefaultPageTransitionType =
    PageTransitionType.rightToLeft;

extension PageTransitionTypePresentation on PageTransitionType {
  String get label {
    return switch (this) {
      PageTransitionType.rightToLeftCupertino => '右滑进入（iOS）',
      PageTransitionType.rightToLeft => '右滑进入',
      PageTransitionType.leftToRight => '左滑进入',
      PageTransitionType.leftToRightCupertino => '左滑进入（iOS）',
      PageTransitionType.upToDown => '上到下',
      PageTransitionType.downToUp => '下到上',
      PageTransitionType.scale => '缩放',
      PageTransitionType.rotate => '旋转',
      PageTransitionType.size => '尺寸展开',
      PageTransitionType.rightToLeftWithFade => '右滑淡入',
      PageTransitionType.leftToRightWithFade => '左滑淡入',
      PageTransitionType.upToDownWithFade => '上滑淡入',
      PageTransitionType.downToUpWithFade => '下滑淡入',
      PageTransitionType.none => '无动画',
    };
  }

  String get description {
    return switch (this) {
      PageTransitionType.rightToLeftCupertino => '新页从右侧进入，旧页轻微左移。',
      PageTransitionType.rightToLeft => '新页从右侧滑入。',
      PageTransitionType.leftToRight => '新页从左侧滑入。',
      PageTransitionType.leftToRightCupertino => '新页从左侧进入，旧页轻微右移。',
      PageTransitionType.upToDown => '新页从上方向下滑入。',
      PageTransitionType.downToUp => '新页从下方向上滑入。',
      PageTransitionType.scale => '新页缩放进入。',
      PageTransitionType.rotate => '新页旋转进入。',
      PageTransitionType.size => '新页按尺寸展开。',
      PageTransitionType.rightToLeftWithFade => '右滑进入并同时淡入。',
      PageTransitionType.leftToRightWithFade => '左滑进入并同时淡入。',
      PageTransitionType.upToDownWithFade => '上滑进入并同时淡入。',
      PageTransitionType.downToUpWithFade => '下滑进入并同时淡入。',
      PageTransitionType.none => '直接切换，不使用过渡动画。',
    };
  }
}
