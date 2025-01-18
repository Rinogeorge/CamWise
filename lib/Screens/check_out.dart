import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rinosfirstproject/Screens/sell_details.dart';
import '../functions/model.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<void> saveCustomerDetails() async {
    try {
      final invoiceBox = await Hive.openBox<InvoiceModel>('invoiceBox');

      // Retrieve the last invoice
      final lastInvoiceKey = invoiceBox.keys.last;
      final InvoiceModel? lastInvoice = invoiceBox.get(lastInvoiceKey);

      if (lastInvoice == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: No recent invoice found')),
        );
        return;
      }

      // Update invoice with customer details
      final updatedInvoice = InvoiceModel(
        id: lastInvoice.id,
        squantity: lastInvoice.squantity,
        customerName: _nameController.text,
        customerPhone: _phoneController.text,
        products: lastInvoice.products,
        amount: lastInvoice.amount,
        purchaseDate: lastInvoice.purchaseDate,
        totalAmount: lastInvoice.totalAmount,
      );

      // Save updated invoice to the database
      await invoiceBox.put(lastInvoiceKey, updatedInvoice);

      // Navigate to Sell Details Page with the updated InvoiceModel
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>   SellDetailsPage( ),
        ),
      );
    } catch (e) {
      print('Error saving customer details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving customer details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Details'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6A8E4E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Customer Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Customer Phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: saveCustomerDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A8E4E),
                ),
                child: const Text('Save & Proceed'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
