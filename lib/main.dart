import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rinosfirstproject/Screens/splash.dart';
 
import 'package:rinosfirstproject/functions/model.dart';

Future<void> main() async {
  
     
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
   await Hive.openBox<InvoiceModel>('invoice_box');

  // Register Hive Adapters
  Hive.registerAdapter(CustomerDetailsAdapter());
  Hive.registerAdapter(UserdatamodelAdapter());
  Hive.registerAdapter(ProfilemodelAdapter());
  Hive.registerAdapter(ProductmodelAdapter());
  Hive.registerAdapter(CategorymodelAdapter());
  Hive.registerAdapter(NotificationModelAdapter());
  Hive.registerAdapter(InvoiceModelAdapter());

  // Open the necessary boxes
  // await Hive.openBox<SellProduct>('sellProductsBox');
  try {
  await Hive.initFlutter();
  // await Hive.openBox<SellProduct>('sellBox');
} catch (e) {
  print("Error initializing Hive: $e");
}


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScreenSplash(),
    );
  }
}











  //  Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //           child: Card(
  //             elevation: 9,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(16),
  //             ),
  //             color: Colors.green[100],
  //             child: Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   const Text(
  //                     'Total Revenue:',
  //                     style: TextStyle(
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.black87,
  //                     ),
  //                   ),
  //                   ValueListenableBuilder<double>(
  //                     valueListenable: grandTotalNotifier,
  //                     builder: (context, grandTotal, child) {
  //                       return Text(
  //                         '₹${grandTotal.toStringAsFixed(2)}',
  //                         style: const TextStyle(
  //                           fontSize: 20,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.green,
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),