// import 'package:flutter/material.dart';

// class AntiMaterialsCard extends StatelessWidget {
//   final List<String> antiMaterials;

//   AntiMaterialsCard({required this.antiMaterials});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const Expanded(
//           child: Icon(Icons.arrow_back),
//         ),
//         Column(
//           children: [
//             const Text(
//               'Anti-Materials',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const Divider(),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: antiMaterials.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(antiMaterials[index]),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//         const Expanded(
//           child: Icon(Icons.arrow_forward),
//         ),
//       ],
//     );
//   }
// }
