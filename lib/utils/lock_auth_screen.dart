import 'package:local_auth/local_auth.dart';

class AuthenticationService {
  final LocalAuthentication _auth = LocalAuthentication();

  // Check if the device supports biometrics or other authentication methods
  Future<bool> isDeviceSupported() async {
    return await _auth.isDeviceSupported();
  }

  // Check if any biometric method is available
  Future<bool> isBiometricAvailable() async {
    return await _auth.canCheckBiometrics;
  }

  // Get the list of available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _auth.getAvailableBiometrics();
  }

  // Authenticate the user
  Future<bool> authenticateUser(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print('Authentication error: $e');
      return false;
    }
  }
}
