import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mnm_vendor/utils/providers/verification_provider.dart';

// Define the state class
class VendorVerificationState {
  final bool? hasStore;
  final bool isLoading;
  final String? error;
  final dynamic verified;

  VendorVerificationState({
    this.hasStore,
    this.verified,
    this.isLoading = false,
    this.error,
  });

  VendorVerificationState copyWith({
    bool? hasStore,
    bool? isLoading,
    dynamic verified,
    String? error,
  }) {
    return VendorVerificationState(
      hasStore: hasStore ?? this.hasStore,
      isLoading: isLoading ?? this.isLoading,
      verified: verified ?? this.verified,
      error: error,
    );
  }
}

// Define a provider for the state
final vendorVerificationProvider =
    StateNotifierProvider<VendorVerificationNotifier, VendorVerificationState>(
  (ref) => VendorVerificationNotifier(),
);
