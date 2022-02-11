import 'package:admin/BLoC/firestore_bloc.dart';
import 'package:admin/Constants/design.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

import 'admin_page.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _techCreateKey = GlobalKey<FormState>();
  String barcodeNumber = '';
  String? productName;

  @override
  Widget build(BuildContext context) {
    final _index = context.read<SelectedIndex>();
    bool busy = false;
    ValueNotifier busyVal = ValueNotifier(busy);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: 'Add QR Code',
                  style: GoogleFonts.openSans(color: const Color(0xFF002E56), fontSize: MediaQuery.of(context).size.width * 0.02, fontWeight: FontWeight.w700))
            ])),
      ),
      ValueListenableBuilder(
        valueListenable: busyVal,
        builder: (BuildContext context, value, Widget? child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
                child: Form(
                    key: _techCreateKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
                          child: ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              color: Colors.grey[300],
                              child: TextFormField(
                                initialValue: barcodeNumber,
                                textCapitalization: TextCapitalization.characters,
                                validator: (value) {
                                  if (value!.isEmpty || value.length != 10) {
                                    return '       Please enter a valid qr code ID.';
                                  } else {
                                    barcodeNumber = "DZ" + value;
                                  }
                                  return null;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    barcodeNumber = "DZ" +  val;
                                  });
                                },
                                decoration: InputDecoration(
                                  prefixText: "DZ",
                                  prefixIcon: const Icon(Icons.qr_code),
                                  hintText: 'QR Code ID',
                                  hintStyle: GoogleFonts.openSans(),
                                  border: InputBorder.none,
                                  focusedBorder:
                                  OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.blue)),
                                ),
                                keyboardType: TextInputType.name,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
                          child: ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              color: Colors.grey[300],
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal:  20.0),
                                child: DropdownButton<String>(
                                  hint: const Text('Select a Product'),
                                  value: productName ?? "Select a Product",
                                  items: <String>["Select a Product", "Divaz Alkaline RO+UV+UF Water Purifier", "Divaz Alkaline RO+UV+UF Water Purifier 2"].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      productName = val;
                                    });
                                  },
                                ),
                              )
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                              gradient: backgroundGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(0, 5),
                                  blurRadius: 6,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: FloatingActionButton.extended(
                              heroTag: 'RegisterDealerButton',
                              isExtended: true,
                              onPressed: () {
                                if (_techCreateKey.currentState!.validate() && productName != null) {
                                  busyVal.value = true;
                                  DataService().firestore.collection('Barcodes').document(barcodeNumber).create({"Product" : productName}).then((value) => _index.setValue(0));
                                } else {
                                  const snackBar = SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                      'Enter Proper Details',
                                      style: TextStyle(fontSize: 15.0),
                                      textAlign: TextAlign.center,
                                    ),
                                    backgroundColor: Colors.black,
                                  );
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(snackBar);
                                }
                              },
                              clipBehavior: Clip.antiAlias,
                              label: const Text(
                                'REGISTER PRODUCT',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              hoverElevation: 0,
                              focusElevation: 0,
                              highlightElevation: 0,
                              disabledElevation: 0,
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              SizedBox(height: 200, child: SfBarcodeGenerator(value: barcodeNumber, symbology: QRCode(),))
            ],
          );
        },
      ),
    ]);
  }
}
