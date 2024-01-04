import 'package:flutter/material.dart';
import 'package:mikrotik_api/services/pdf_generator/pdf_generator.dart';

class SelectedVouchersPrintView extends StatelessWidget {
  final List<dynamic> selectedVouchers;

  const SelectedVouchersPrintView({
    super.key,
    required this.selectedVouchers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selected Voucher'),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'pdf',
                  child: Text('PDF'),
                ),
              ];
            },
            onSelected: (String value) {
              if (value == 'pdf') {
                generateAndSavePDF(context, selectedVouchers);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
                children: selectedVouchers.map((voucher) {
                  return Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('1 user'),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${voucher['name']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            'Limit: ${voucher['limit-uptime']}',
                          ),
                          // Add more details as needed...
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
