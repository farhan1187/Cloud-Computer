import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share/share.dart';

Future<void> generateAndSavePDF(
    BuildContext context, List<dynamic> selectedVouchers) async {
  final pdf = pw.Document();

  TextEditingController fileNameController = TextEditingController();
  String defaultFileName = 'selected_vouchers';
  String? fileName;

  await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter PDF File Name'),
        content: TextField(
          controller: fileNameController,
          decoration: const InputDecoration(hintText: 'Enter file name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              fileName = fileNameController.text.trim().isEmpty
                  ? defaultFileName
                  : fileNameController.text.trim();
              Navigator.pop(context, fileName);
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );

  final fontData = await rootBundle.load('assets/fonts/Rubik-Bold.ttf');
  final fontData_2 = await rootBundle.load('assets/fonts/Rubik-Light.ttf');
  final font = pw.Font.ttf(fontData.buffer.asByteData());
  final font_2 = pw.Font.ttf(fontData_2.buffer.asByteData());

  List<List<dynamic>> chunk(List<dynamic> list, int chunkSize) {
    List<List<dynamic>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  final rows = chunk(selectedVouchers, 5);

  if (fileName != null) {
    String directoryPath = (await getApplicationDocumentsDirectory()).path;
    String customPath = '$directoryPath/$fileName.pdf';
    File file = File(customPath);

    //print(customPath);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return rows.map((row) {
            return pw.Container(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: row.map((voucher) {
                      return pw.Container(
                        width: 80, // Set a fixed width for each item
                        margin: const pw.EdgeInsets.all(8),
                        padding: const pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(
                              '1 user',
                              style: pw.TextStyle(font: font_2),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Text(
                              '${voucher['name']}',
                              style: pw.TextStyle(
                                font: font,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 3),
                            pw.Text(
                              'Limit: ${voucher['limit-uptime']}',
                              style: pw.TextStyle(font: font_2),
                            ),
                            // Add more details as needed...
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }).toList();
        },
      ),
    );

    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(customPath);
    Share.shareFiles([customPath], text: 'Sharing PDF');
  }
}
