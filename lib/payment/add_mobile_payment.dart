import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mnm_vendor/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/providers/add_and_fetch_payments_methods.dart';
import '../widgets/custom_button.dart';

final paymentChannelsProvider =
    StateNotifierProvider<PaymentChannelsNotifier, List<PaymentChannel>>(
  (ref) => PaymentChannelsNotifier(),
);

class PaymentChannel {
  final String name;
  final String code;

  PaymentChannel({required this.name, required this.code});
}

class PaymentChannelsNotifier extends StateNotifier<List<PaymentChannel>> {
  PaymentChannelsNotifier() : super([]);

  Future<void> fetchPaymentChannels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception("Token not found");

      final response = await fetchPaymentChannelsAPI(token);
      state = response
          .map((channel) =>
              PaymentChannel(name: channel['name'], code: channel['code']))
          .toList();
    } catch (error) {
      print("Error fetching payment channels: $error");
    }
  }

  Future<List<dynamic>> fetchPaymentChannelsAPI(String token) async {
    const url = "${AppColors.url}/vendor/channels/mobile";
    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return List<dynamic>.from(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load payment channels");
    }
  }
}

class AddMomoAccountPage extends ConsumerStatefulWidget {
  const AddMomoAccountPage({super.key});
  static const routeName = '/add-account';

  @override
  ConsumerState<AddMomoAccountPage> createState() => _AddMomoAccountPageState();
}

class _AddMomoAccountPageState extends ConsumerState<AddMomoAccountPage> {
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedCode;

  // Future<void> _loadEmailFromToken() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('token');

  //     if (token != null) {
  //       final decodedToken = JwtDecoder.decode(token);
  //       final email = decodedToken['email'];
  //       if (email != null) {
  //         setState(() {
  //           _emailController.text = email;
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     print('Error decoding token: $e');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // _loadEmailFromToken();
    ref.read(paymentChannelsProvider.notifier).fetchPaymentChannels();
  }

  @override
  Widget build(BuildContext context) {
    final paymentChannels = ref.watch(paymentChannelsProvider);
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(IconlyLight.arrow_left_2),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        ),
        title: Text(
          'Add Account',
          style: theme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.03),
              Text('Add Mobile Money Wallet', style: theme.titleMedium),
              SizedBox(height: size.height * 0.004),
              Text('Add a mobile account to receive payments',
                  style: theme.bodyMedium),
              SizedBox(height: size.height * 0.024),
              Text('Mobile money number', style: theme.bodyLarge),
              SizedBox(height: size.height * 0.01),
              TextFormField(
                controller: _mobileNumberController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: 'E.g. 024 242 4242',
                  hintStyle: theme.bodyMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: size.height * 0.024),
              Text('Registered Name', style: theme.bodyLarge),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: 'John Doe',
                  hintStyle: theme.bodyMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: size.height * 0.024),
              Text('Select network', style: theme.bodyLarge),
              SizedBox(height: size.height * 0.01),
              DropdownButtonFormField<String>(
                value: _selectedCode,
                items: paymentChannels.map((channel) {
                  return DropdownMenuItem<String>(
                    value: channel.code,
                    child: Text(channel.name),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCode = newValue;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.25),
              CustomButton(
                onTap: () async {
                  if (_selectedCode != null &&
                      _mobileNumberController.text.isNotEmpty) {
                    print(_selectedCode);
                    await ref.read(paymentProvider.notifier).addPaymentMethod(
                          name: _nameController.text,
                          paymentType: 'mobile_money',
                          accountNumber: _mobileNumberController.text,
                          bankCode: _selectedCode!,
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Account successfully added!'),
                      ),
                    );
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please complete all fields'),
                      ),
                    );
                  }
                },
                title: 'Save this wallet',
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:iconly/iconly.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// // import 'package:m_n_m_rider/commons/app_colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../utils/providers/add_and_fetch_payments_methods.dart';
// import '../widgets/custom_button.dart';

// class AddMomoAccountPage extends ConsumerStatefulWidget {
//   const AddMomoAccountPage({super.key});
//   static const routeName = '/add-account';
//   @override
//   ConsumerState<AddMomoAccountPage> createState() => _AddMomoAccountPageState();
// }

// class _AddMomoAccountPageState extends ConsumerState<AddMomoAccountPage> {
//   final TextEditingController _mobileNumberController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   String _selectedNetwork = 'MTN';
//   Future<void> _loadEmailFromToken() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token =
//           prefs.getString('token'); // Replace 'auth_token' with your token key

//       if (token != null) {
//         final decodedToken = JwtDecoder.decode(token);
//         // print(decodedToken);
//         final email =
//             decodedToken['email']; // Ensure the token has an 'email' field

//         if (email != null) {
//           setState(() {
//             _emailController.text = email; // Set as placeholder
//           });
//         }
//       }
//     } catch (e) {
//       print('Error decoding token: $e');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadEmailFromToken();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final paymentMethods = ref.watch(paymentProvider);
//     final size = MediaQuery.of(context).size;
//     final theme = Theme.of(context).textTheme;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         leading: Builder(
//           builder: (BuildContext context) {
//             return IconButton(
//               icon: const Icon(IconlyLight.arrow_left_2),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               tooltip: MaterialLocalizations.of(context).backButtonTooltip,
//             );
//           },
//         ),
//         title: Text(
//           'Add Account',
//           style: theme.headlineSmall?.copyWith(
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(size.width * 0.03),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: size.height * 0.03),
//             Text('Add Mobile Money Wallet', style: theme.titleMedium),
//             SizedBox(height: size.height * 0.004),
//             Text('Add a mobile account to receive payments',
//                 style: theme.bodyMedium),
//             SizedBox(height: size.height * 0.024),
//             Text('Mobile money number', style: theme.bodyLarge),
//             SizedBox(height: size.height * 0.01),
//             TextFormField(
//               controller: _mobileNumberController,
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: Colors.grey[300],
//                 hintText: 'E.g. 024 242 4242',
//                 hintStyle: theme.bodyMedium,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(6.0),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             SizedBox(height: size.height * 0.024),
//             Text('Email', style: theme.bodyLarge),
//             TextFormField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: Colors.grey[300],
//                 hintText: 'eg. example.com',
//                 hintStyle: theme.bodyMedium,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(6.0),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             SizedBox(height: size.height * 0.024),
//             Text('Select network', style: theme.bodyLarge),
//             SizedBox(height: size.height * 0.01),
//             DropdownButtonHideUnderline(
//               child: DropdownButtonFormField<String>(
//                 value: _selectedNetwork,
//                 items: ['MTN', 'Telecel'].map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (newValue) {
//                   setState(() {
//                     _selectedNetwork = newValue!;
//                   });
//                 },
//                 decoration: InputDecoration(
//                   border: UnderlineInputBorder(
//                       borderRadius: BorderRadius.circular(6)),
//                   filled: true,
//                   fillColor: Colors.grey[300],
//                 ),
//               ),
//             ),
//             const Spacer(),
//             CustomButton(
//               onTap: () async {
//                 // final newAccount = Account(
//                 //   name: _selectedNetwork,
//                 //   number: int.parse(_mobileNumberController.text),
//                 //   network:
//                 //       _selectedNetwork == 'MTN' ? Network.MTN : Network.Telecel,
//                 // );
//                 // ref.read(accountProvider.notifier).addAccount(newAccount);
//                 await ref.read(paymentProvider.notifier).addPaymentMethod(
//                     name: ,
//                     paymentType: 'mobile_money',
//                     accountNumber: ,
//                     bankCode: 
//                    );
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Account successfully added!'),
//                   ),
//                 );
//                 Navigator.of(context).pop();
//               },
//               title: 'Save this wallet',
//             ),
//             SizedBox(height: size.height * 0.03),
//           ],
//         ),
//       ),
//     );
//   }
// }

