import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the enum for network
enum Network { MTN, Telecel }

// Class to represent an account
class Account {
  final String name;
  final int number;
  // final String reference;
  final Network network;

  Account({
    required this.name,
    required this.number,
    // required this.reference,
    required this.network,
  });
}

// StateNotifier to handle account actions
class AccountNotifier extends StateNotifier<List<Account>> {
  AccountNotifier() : super([]);

  void addAccount(Account account) {
    state = [...state, account];
  }

  void removeAccount(Account account) {
    state = state.where((item) => item != account).toList();
  }
}

// Provider for the AccountNotifier
final accountProvider =
    StateNotifierProvider<AccountNotifier, List<Account>>((ref) {
  return AccountNotifier();
});
