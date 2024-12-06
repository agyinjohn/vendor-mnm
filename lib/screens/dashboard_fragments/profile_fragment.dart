import 'package:flutter/material.dart';
import 'package:mnm_vendor/screens/dashboard_fragments/verification_page.dart';

import 'package:iconly/iconly.dart';
import '../../app_colors.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({super.key});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  final bool isAccountSetupComplete = true;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Main content of the profile page
          SingleChildScrollView(
            padding: EdgeInsets.all(size.width * 0.018),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: size.height * 0.03),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     const Text('Switch Accounts'),
                //     _buildStoreRating(4.5), // Pass the store rating
                //   ],
                // ),
                SizedBox(height: size.height * 0.025),

                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: double.infinity,
                  height: size.height * 0.18,
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Text('Accounts Registered: 2'),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            //  Profile Picture
                            Center(
                              child: CircleAvatar(
                                radius: 25,
                                // backgroundColor: Colors.transparent,
                                backgroundImage: const AssetImage(
                                  'assets/images/main-logo.jpg',
                                ),
                                onBackgroundImageError:
                                    (exception, stackTrace) {
                                  // Handle image loading error
                                },
                              ),
                            ),
                            SizedBox(width: size.width * 0.03),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ABC STORE',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                                Text(
                                  '+1234 567 890',
                                  style: TextStyle(fontSize: 11),
                                ),
                                Text(
                                  'vendor@abcstore.com',
                                  style: TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                            const Spacer(),

                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6)),
                              height: size.height * 0.05,
                              width: size.height * 0.05,
                              child: Center(
                                child: Image.asset('assets/images/transfer.png',
                                    fit: BoxFit.cover),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.035),
                const Text('Account Information'),
                SizedBox(height: size.height * 0.025),
                Row(
                  children: [
                    SizedBox(
                      height: 35,
                      width: 35,
                      child: Image.asset('assets/images/transfer.png',
                          fit: BoxFit.cover),
                    ),
                    SizedBox(width: size.width * 0.022),
                    const Text('Verification Status'),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      width: size.width * 0.14,
                      height: size.height * 0.06,
                      child: const Center(
                        child: Text(
                          'Verified',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ),
                    )
                  ],
                ),
                _buildInformation(
                    context,
                    'assets/images/identification-documents.png',
                    'Edit account details'),
                _buildInformation(context, 'assets/images/card-payment.png',
                    'Payment methods'),
                _buildInformation(
                    context, 'assets/images/waste.png', 'Remove account'),

                SizedBox(height: size.height * 0.028),
                const Divider(),
                SizedBox(height: size.height * 0.035),
                const Text('Utilities'),
                SizedBox(height: size.height * 0.025),

                _buildInformation(context, 'assets/images/online-support.png',
                    'Make a report'),
                _buildInformation(
                    context, 'assets/images/protect.png', 'Privacy & Policy'),
                _buildInformation(
                    context, 'assets/images/protect.png', 'Terms & Conditions'),

                SizedBox(height: size.height * 0.028),
                const Divider(),
                SizedBox(height: size.height * 0.035),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Version 1.0.0'),
                  ],
                ),
              ],
            ),
          ),

          // Positioned prompt for account setup
          if (!isAccountSetupComplete)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.amber[800],
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        'Complete your account setup to start selling!',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      width: 1,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, KycVerificationScreen.routeName);
                        // Navigate to account setup page or trigger setup action
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                        ),
                        backgroundColor: AppColors.primaryColor,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Section title builder
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInformation(
      BuildContext ctx, String imageUrl, String description) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          SizedBox(
            height: 35,
            width: 35,
            child: Image.asset(imageUrl, fit: BoxFit.cover),
          ),
          SizedBox(width: size.width * 0.022),
          Text(description),
          const Spacer(),
          const Icon(IconlyLight.arrow_right_2),
        ],
      ),
    );
  }

  // Store rating builder
  Widget _buildStoreRating(double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Store Rating:'),
        const SizedBox(width: 8),
        Icon(
          Icons.star,
          color: Colors.amber[600],
          // size: 24,
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.star,
          color: Colors.amber[600],
          // size: 24,
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.star,
          color: Colors.amber[600],
          // size: 24,
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.star,
          color: Colors.amber[600],
          // size: 24,
        ),
        const SizedBox(width: 4),
        Icon(
          rating >= 4.5
              ? Icons.star_half
              : Icons.star_border, // Display half star if rating is in between
          color: Colors.amber[600],
          // size: 24,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toString(),
          style: const TextStyle(
            // fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
// Action button builder
// Widget _buildActionButton(IconData icon, String label) {
//   return ElevatedButton.icon(
//     onPressed: () {
//       // Define action for the button
//     },
//     icon: Icon(icon, color: Colors.white),
//     label: Text(
//       label,
//       style: const TextStyle(color: Colors.white),
//     ),
//     style: ElevatedButton.styleFrom(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10), // Rounded corners
//       ),
//       backgroundColor: AppColors.primaryColor,
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//       textStyle: const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w500,
//       ),
//     ),
//   );
// }