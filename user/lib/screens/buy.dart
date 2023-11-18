import 'package:flutter/material.dart';
// import 'package:stripe_payment/stripe_payment.dart';
import './cart.dart';
import './profile.dart';

// class BuyNowScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Buy Now'),
//         backgroundColor: Colors.orange,
//       ),
//       body: SingleChildScrollView(
//         // Wrap with SingleChildScrollView
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Product Image
//               Image.network(
//                 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c2hvZXNzJTIwc3VpdHxlbnwwfHwwfHx8MA%3D%3D',
//                 height: 200,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//
//               SizedBox(height: 16),
//
//               // Quantity Selector
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Quantity'),
//                   Row(
//                     children: [
//                       Text('1'),
//                     ],
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: 16),
//
//               // Total Price
//               Text(
//                 'Total Price: \$99.99',
//                 style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//               ),
//
//               SizedBox(height: 16),
//
//               // Shipping Details Form
//               Text(
//                 'Shipping Details',
//                 style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
//               ),
//
//               SizedBox(height: 8),
//
//               // Shipping Address Input
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Shipping Address'),
//               ),
//
//               SizedBox(height: 8),
//
//               // City Input
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'City'),
//               ),
//
//               SizedBox(height: 8),
//
//               // State Input
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'State'),
//               ),
//
//               SizedBox(height: 16),
//
//               // Buy Now Button
//               ElevatedButton(
//                 onPressed: () {
//                   // handleBuyNowAction(context);
//                 },
//                 child: Text('Buy Now'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // void handleBuyNowAction(BuildContext context) {
//   //     StripePayment.setOptions(
//   //     StripeOptions(
//   //       publishableKey: "your_stripe_publishable_key",
//   //       merchantId: "your_merchant_id",
//   //       androidPayMode: 'test',
//   //     ),
//   //   );
//   //   // Implement the rest of your Stripe Checkout logic here
//   //   // Create a PaymentIntent or use a pre-existing one
//   //   // Call StripePayment.confirmPayment(...) to initiate the payment process
//   // }
// }
