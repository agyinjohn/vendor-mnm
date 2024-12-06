// import 'package:flutter/material.dart';

// class HomeBanner extends StatelessWidget {
//   const HomeBanner(
//       {super.key,
//       required this.title,
//       required this.content,
//       // required this.image,
//       required this.overlayColor});

//   final String title, content;
//   // image;
//   final Color overlayColor;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Image.asset(
//           'assets/images/card-pattern.jpg',
//           fit: BoxFit.cover,
//           width: double.infinity,
//           height: 160,
//         ),
//         Container(
//           width: double.infinity,
//           height: 160,
//           color: overlayColor.withOpacity(0.9),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold),
//               ),
//               const Spacer(),
//               Text(
//                 content,
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//         // Positioned(
//         //   top: 0,
//         //   right: 0,
//         //   child: Image.asset(image),
//         // ),
//       ],
//     );
//   }
// }
