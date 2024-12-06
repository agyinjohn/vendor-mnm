import 'package:flutter_riverpod/flutter_riverpod.dart';

// StepStateNotifier to manage the completed status of each step
class StepStateNotifier extends StateNotifier<List<bool>> {
  StepStateNotifier()
      : super([false, false, false]); // Initially, no steps are completed

  void completeStep(int index) {
    // Update the step to be completed
    state = List.from(state)..[index] = true;
  }
}

// Provider to manage the step completion state
final stepStateProvider =
    StateNotifierProvider<StepStateNotifier, List<bool>>((ref) {
  return StepStateNotifier();
});
