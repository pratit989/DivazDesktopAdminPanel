import 'package:admin/BLoC/firestore_bloc.dart';
import 'package:admin/Constants/design.dart';
import 'package:admin/Screens/dealers.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';


class AddDealer extends StatefulWidget {
  const AddDealer({Key? key, required this.toggle}) : super(key: key);
  final Function toggle;

  @override
  _AddDealerState createState() => _AddDealerState();
}

class _AddDealerState extends State<AddDealer> {
  final _techCreateKey = GlobalKey<FormState>();
  late String name;
  late String country;
  late String city;
  late String state;
  late String aadharCardNumber;
  late String companyName;
  late String phoneNumber;

  @override
  Widget build(BuildContext context) {
    bool busy = false;
    ValueNotifier busyVal = ValueNotifier(busy);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
          text: TextSpan(children: [
            WidgetSpan(
                child: GestureDetector(
                  child: const Icon(Icons.arrow_back_ios),
                  onTap: () {
                    widget.toggle();
                  },
                )),
            WidgetSpan(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                )),
            TextSpan(
                text: 'Add Dealers',
                style: TextStyle(color: Colors.blue[900], fontSize: MediaQuery.of(context).size.width * 0.02, fontWeight: FontWeight.w600))
          ])),
      ValueListenableBuilder(
        valueListenable: busyVal,
        builder: (BuildContext context, value, Widget? child) {
          return Padding(
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a valid company name.';
                              } else {
                                companyName = value;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.apartment),
                              hintText: 'Company Name',
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
                          child: CSCPicker(
                            dropdownDecoration: BoxDecoration(color: Colors.grey[300],),
                            showCities: true,
                            showStates: true,
                            disableCountry: true,
                            defaultCountry: DefaultCountry.India,
                            onCountryChanged: (value) {
                              setState(() {
                                country = value;
                              });
                            },
                            onStateChanged:(value) {
                              setState(() {
                                state = value ?? '';
                              });
                            },
                            onCityChanged:(value) {
                              setState(() {
                                city = value ?? '';
                              });
                            },
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
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty || value.length < 10) {
                                return 'Please enter a valid mobile number.';
                              } else {
                                phoneNumber = value;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.phone),
                              hintText: 'Phone Number',
                              border: InputBorder.none,
                              focusedBorder:
                              OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.blue)),
                            ),
                            keyboardType: TextInputType.number,
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
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a valid name.';
                              } else {
                                name = value;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              hintText: 'Name',
                              border: InputBorder.none,
                              focusedBorder:
                              OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.blue)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.05),
                      child: ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          color: Colors.grey[300],
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty || value.length < 12) {
                                return 'Please enter a valid aadhar card number.';
                              } else {
                                aadharCardNumber = value;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.document_scanner),
                              hintText: 'Aadhar Card Number',
                              border: InputBorder.none,
                              focusedBorder:
                              OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.blue)),
                            ),
                          ),
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
                            if (_techCreateKey.currentState!.validate() && state.isNotEmpty && city.isNotEmpty) {
                              busyVal.value = true;
                              var data = Dealer(companyName: companyName, state: state, place: city, phoneNumber: phoneNumber, name: name, aadharCardNumber: aadharCardNumber);
                              DataService().firestore.collection('Dealers').add({
                                'CompanyName': data.companyName,
                                'State': data.state,
                                'Place': data.place,
                                'Name': data.name,
                                'AdharCard': data.aadharCardNumber,
                                'PhoneNumber': data.phoneNumber
                              }).then((value) => widget.toggle());
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
                            'REGISTER DEALER',
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
          );
        },
      ),
    ]);
  }
}
