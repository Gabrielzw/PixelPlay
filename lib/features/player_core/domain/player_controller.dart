import 'package:get/get.dart';

const double kPlayerInitialProgress = 0.12;

class PlayerController extends GetxController {
  final RxBool isPlaying = true.obs;
  final RxBool controlsLocked = false.obs;
  final RxDouble progress = kPlayerInitialProgress.obs;

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
  }

  void toggleLock() {
    controlsLocked.value = !controlsLocked.value;
  }

  void seekTo(double value) {
    progress.value = value;
  }
}

