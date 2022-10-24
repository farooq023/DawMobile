// import 'package:flutter/material.dart';

// class InboxTile extends StatelessWidget {
//   // const InboxTile({super.key});

//   final Map tileData;

//   InboxTile(this.tileData);

//   @override
//   Widget build(BuildContext context) {
//     var mSize = MediaQuery.of(context).size;
//     var mHeight = mSize.height;
//     var mWidth = mSize.width;

//     return GestureDetector(
//       onLongPress: () {
//         // print('long pressed');
//         _selection = 1;
//         setState(() {});
//       },
//       child: Container(
//         height: mHeight * 0.17,
//         padding: const EdgeInsets.all(6),
//         // color: ,
//         child: Row(
//           children: [
//             Container(
//               // decoration: BoxDecoration(
//               //   border: Border.all(
//               //     color: Colors.black,
//               //     width: 2,
//               //   ),
//               // ),
//               width: mWidth * 0.138,
//               child: const Align(
//                 alignment: Alignment(0, -1),
//                 child: Icon(
//                   Icons.account_circle,
//                   size: 48,
//                 ),
//               ),
//             ),
//             Container(
//               // decoration: BoxDecoration(
//               //   border: Border.all(
//               //     color: Colors.black,
//               //     width: 2,
//               //   ),
//               // ),
//               // width: mWidth * 0.782,
//               width: mWidth * 0.81,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         width: mWidth * 0.45,
//                         child: Text(
//                           "${_setInbox[i]['Sender']}",
//                           style: const TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             // color: Colors.blue,
//                           ),
//                           maxLines: 1,
//                         ),
//                       ),
//                       Container(
//                         width: mWidth * 0.25,
//                         child: Align(
//                           alignment: const Alignment(1, 0),
//                           child: Text(
//                             "${_setInbox[i]['WFBeginDate']}",
//                             style: const TextStyle(
//                               fontSize: 15,
//                               // fontWeight: FontWeight.bold,
//                               // color: Colors.blue,
//                             ),
//                             maxLines: 1,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Container(
//                     width: mWidth * 0.45,
//                     child: Text(
//                       "${_setInbox[i]['SUBJECT']}",
//                       style: const TextStyle(
//                         fontSize: 18,
//                         // color: Colors.blue,
//                       ),
//                       maxLines: 1,
//                     ),
//                   ),
//                   Container(
//                     width: mWidth * 0.85,
//                     child: Text(
//                       "${_setInbox[i]['wfTypeDesc']}",
//                       style: const TextStyle(
//                         fontSize: 15,
//                         // color: Colors.blue,
//                       ),
//                       maxLines: 1,
//                     ),
//                   ),
//                   // const Divider(thickness: 1),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
