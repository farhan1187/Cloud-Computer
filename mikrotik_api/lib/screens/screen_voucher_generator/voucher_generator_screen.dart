import 'package:flutter/material.dart';
import 'package:mikrotik_api/services/post_data/post_generate_voucher.dart';
import 'package:mikrotik_api/services/selectedatamodel.dart';
import 'package:mikrotik_api/widgets/bandwidth_list_box_width.dart';
import 'package:mikrotik_api/widgets/custom_snacbar.dart';
import 'package:mikrotik_api/widgets/custom_button.dart';
import 'package:mikrotik_api/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ScreenVoucherGenerator extends StatefulWidget {
  const ScreenVoucherGenerator({super.key});

  @override
  State<ScreenVoucherGenerator> createState() => _ScreenVoucherGeneratorState();
}

class _ScreenVoucherGeneratorState extends State<ScreenVoucherGenerator> {
  final _formKey = GlobalKey<FormState>();
  final _daysController = TextEditingController();
  final _voucherController = TextEditingController();
  final _commentController = TextEditingController();

  String selectedDns = '';
  int selectedPort = 0;
  String selectedUsername = '';
  String selectedPassword = '';
  String selectedHotspot = '';
  bool isProcessing = false;
  late int numberOfVouchers = 0;
  String selectedRateLimit = '';
  @override
  void initState() {
    super.initState();

    // Fetch selected router data from SelectedDataModel
    final selectedData = Provider.of<SelectedDataModel>(context, listen: false);
    selectedDns = selectedData.selectedDns;
    selectedPort = selectedData.selectedPort;
    selectedUsername = selectedData.selectedUsername;
    selectedPassword = selectedData.selectedPassword;
    selectedHotspot = selectedData.selectedHotspot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Voucher'),
      ),
      body: SafeArea(
        child: Center(
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: ResponsiveBuilder(
                builder: (context, sizingInformation) {
                  double formWidth = sizingInformation.isMobile ? 300.0 : 400.0;
                  double verticalSpaceBetweenTextFields =
                      sizingInformation.isMobile ? 10.0 : 10.0;
                  double verticalSpaceBetweenTextFieldAndButton =
                      sizingInformation.isMobile ? 20.0 : 20.0;

                  return SizedBox(
                    width: formWidth,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(height: verticalSpaceBetweenTextFields),
                          MikroTikDataListBox(
                            dns: selectedDns,
                            port: selectedPort,
                            username: selectedUsername,
                            password: selectedPassword,
                            onDataSelected: (bandWidth) {
                              setState(() {
                                selectedRateLimit = bandWidth;
                                // Use selected rate-limit as needed
                              });
                            },
                          ),
                          CustomTextField(
                            labelText: 'No of Days',
                            controller: _daysController,
                            errortext: 'Field is empty',
                            keybordtype: TextInputType.number,
                          ),
                          SizedBox(height: verticalSpaceBetweenTextFields),
                          CustomTextField(
                            labelText: 'No of Voucher',
                            controller: _voucherController,
                            onChanged: (value) {
                              setState(() {
                                // Check if the field is not empty
                                if (value.isEmpty) {
                                  // If empty, set numberOfVouchers to 0
                                  numberOfVouchers = 0;
                                } else {
                                  // If not empty, validate and limit the value to 200
                                  int enteredValue = int.tryParse(value) ?? 0;
                                  if (enteredValue > 200) {
                                    // Set numberOfVouchers to 0 if greater than 200
                                    numberOfVouchers = 250;
                                  } else {
                                    // Otherwise, update numberOfVouchers with the entered value
                                    numberOfVouchers = enteredValue;
                                  }
                                }
                              });
                            },
                            errortext: _voucherController.text.isEmpty
                                ? 'Field is empty'
                                : 'Value should be <= 100',
                            keybordtype: TextInputType.number,
                          ),
                          SizedBox(height: verticalSpaceBetweenTextFields),
                          CustomTextField(
                            labelText: 'Comment',
                            controller: _commentController,
                            errortext: 'Field is empty',
                            keybordtype: TextInputType.text,
                          ),
                          SizedBox(
                            height: verticalSpaceBetweenTextFieldAndButton,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: isProcessing
                                  ? Container(
                                      width: double.infinity,
                                      color: Colors.black.withOpacity(0.5),
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            color: Colors.green,
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            'Please wait, processing...',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : CustomButton(
                                      text: 'Generate',
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          if (numberOfVouchers > 0) {
                                            if (numberOfVouchers <= 100) {
                                              setState(() {
                                                isProcessing = true;
                                              });

                                              await post_generate_voucher(
                                                  _commentController.text,
                                                  selectedDns,
                                                  selectedPort,
                                                  selectedUsername,
                                                  selectedPassword,
                                                  _daysController.text,
                                                  selectedHotspot,
                                                  selectedRateLimit,
                                                  numberOfVouchers);

                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      'Navigate_to_Generated_Voucher_Screen');
                                            } else {
                                              setState(() {
                                                CustomSnackBar.showSnackBar(
                                                    context,
                                                    'Voucher count should be <= 100.');
                                              });
                                            }
                                          } else {
                                            setState(() {
                                              CustomSnackBar.showSnackBar(
                                                  context,
                                                  'Please use common scence');
                                            });
                                          }
                                        }
                                      }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _daysController.clear();
    _voucherController.clear();
    _commentController.clear();

    super.dispose();
  }
}
