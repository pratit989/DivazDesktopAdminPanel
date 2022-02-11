import 'package:admin/Constants/design.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

import '../BLoC/firestore_bloc.dart';

class ComplaintDetails extends StatefulWidget {
  const ComplaintDetails({Key? key, required this.toggleDetails, required this.complaintId}) : super(key: key);
  final Function toggleDetails;
  final String complaintId;

  @override
  _ComplaintDetailsState createState() => _ComplaintDetailsState();
}

class _ComplaintDetailsState extends State<ComplaintDetails> {
  String get complaintId => widget.complaintId;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF0066CC),
            ),
            onTap: () => widget.toggleDetails(),
          ),
          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.25),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 11),
                child: Text(
                  complaintId,
                  style: GoogleFonts.openSans(
                      color: const Color(0xFF002E56), fontSize: MediaQuery.of(context).size.height * 0.03, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          )
        ],
      ),
      StreamBuilder<Document?>(
          stream: DataService().firestore.collection('Complaints').document(complaintId).stream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null && snapshot.connectionState == ConnectionState.active) {
              Document data = snapshot.data!;
              DateTime dateTime = snapshot.data!['DateTime'];
              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
                    alignment: Alignment.bottomCenter,
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: MediaQuery.of(context).size.height * 0.6,
                    decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        boxShadow: const [BoxShadow(color: Color(0x43000000), offset: Offset(0, 3), blurRadius: 6)],
                        borderRadius: BorderRadius.circular(20)),
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.8, minHeight: 0, maxWidth: MediaQuery.of(context).size.width * 0.5),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ListView(
                            children: [
                                TextField(
                                  enabled: false,
                                  controller: TextEditingController(text: "Divaz Alkaline RO + UV + UF Water Purifier"),
                                  decoration: InputDecoration(
                                      label: const Text('Product Name'),
                                      labelStyle: GoogleFonts.openSans(fontSize: MediaQuery.of(context).size.width * 0.015)),
                                  maxLines: null,
                                ),
                                TextField(
                                  enabled: false,
                                  controller: TextEditingController(text: Jiffy(dateTime).format('MMMM d, hh:mm a')),
                                  decoration: InputDecoration(
                                      label: const Text('Complaint Date & Time'),
                                      labelStyle: GoogleFonts.openSans(fontSize: MediaQuery.of(context).size.width * 0.015)),
                                  maxLines: null,
                                ),
                                TextField(
                                  enabled: false,
                                  controller: TextEditingController(text: data['Name']),
                                  decoration: InputDecoration(
                                      label: const Text('Customer Name'),
                                      labelStyle: GoogleFonts.openSans(fontSize: MediaQuery.of(context).size.width * 0.015)),
                                  maxLines: null,
                                ),
                                TextField(
                                  enabled: false,
                                  controller: TextEditingController(text: data['Location']),
                                  decoration: InputDecoration(
                                    label: const Text('Customer Address'),
                                    labelStyle: GoogleFonts.openSans(fontSize: MediaQuery.of(context).size.width * 0.015),
                                  ),
                                  maxLines: null,
                                ),
                                TextField(
                                  enabled: false,
                                  controller: TextEditingController(text: data['PhoneNumber']),
                                  decoration: InputDecoration(
                                      label: const Text('Phone Number'),
                                      labelStyle: GoogleFonts.openSans(fontSize: MediaQuery.of(context).size.width * 0.015)),
                                  maxLines: null,
                                ),
                                TextField(
                                  enabled: false,
                                  controller: TextEditingController(text: data['Description']),
                                  decoration: InputDecoration(
                                      label: const Text('Complaint Description'),
                                      labelStyle: GoogleFonts.openSans(fontSize: MediaQuery.of(context).size.width * 0.015)),
                                  maxLines: null,
                                ),
                                TextField(
                                  enabled: false,
                                  controller: TextEditingController(text: data['Cost']),
                                  decoration: InputDecoration(
                                      label: const Text('Cost'),
                                      labelStyle: GoogleFonts.openSans(fontSize: MediaQuery.of(context).size.width * 0.015)),
                                  maxLines: null,
                                ),
                                TextField(
                                  enabled: false,
                                  controller: TextEditingController(text: data['PaymentType']),
                                  decoration: InputDecoration(
                                      label: const Text('Payment Type'),
                                      labelStyle: GoogleFonts.openSans(fontSize: MediaQuery.of(context).size.width * 0.015)),
                                  maxLines: null,
                                ),
                              ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        child: Image.asset(snapshot.data!['Picture']!),
                        width: MediaQuery.of(context).size.width * 0.15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Visibility(
                            //     visible: snapshot.data!['Status'] == 2,
                            //     child: SizedBox(
                            //         height: 30,
                            //         width: 176,
                            //         child: FloatingActionButton.extended(
                            //           onPressed: () {},
                            //           label: const Text('Track Progress'),
                            //           extendedPadding: EdgeInsets.zero,
                            //           elevation: 0,
                            //         ))),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                    text: TextSpan(
                                        text: 'Status - ',
                                        children: [
                                          TextSpan(
                                              text: snapshot.data!['Status'] == 1
                                                  ? 'Pending'
                                                  : snapshot.data!['Status'] == 2
                                                      ? 'In - Progress'
                                                      : 'Completed',
                                              style: GoogleFonts.openSans(
                                                  color: snapshot.data!['Status'] == 1
                                                      ? const Color(0xFFFA2929)
                                                      : snapshot.data!['Status'] == 2
                                                          ? const Color(0xFF0066CC)
                                                          : const Color(0xFF178600)))
                                        ],
                                        style: GoogleFonts.openSans(color: const Color(0xFF393939), fontWeight: FontWeight.w700))),
                                RichText(
                                    text: TextSpan(
                                        text: 'Technician - ',
                                        children: [
                                          TextSpan(
                                              text: snapshot.data!['TechName'] ?? "No Technician Assigned",
                                              style: GoogleFonts.openSans(
                                                  color: snapshot.data!['TechName'] != null ? const Color(0xFF0066CC) : const Color(0xFF9A9A9A),
                                                  fontWeight: FontWeight.w700))
                                        ],
                                        style: GoogleFonts.openSans(color: const Color(0xFF393939), fontWeight: FontWeight.w700))),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  // SizedBox(
                  //     width: MediaQuery.of(context).size.width * 0.75,
                  //     height: MediaQuery.of(context).size.height * 0.82,
                  //     child: Align(
                  //         alignment: Alignment.bottomCenter,
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Padding(
                  //               padding: const EdgeInsets.only(right: 20.0),
                  //               child: SizedBox(
                  //                   width: MediaQuery.of(context).size.width * 0.1,
                  //                   child: FloatingActionButton.extended(
                  //                     onPressed: () {},
                  //                     label: Text(
                  //                       'ACCEPT',
                  //                       style: GoogleFonts.openSans(fontWeight: FontWeight.w700),
                  //                     ),
                  //                     backgroundColor: data['Status'] == 1
                  //                         ? const Color(0xFF0066CC)
                  //                         : data['Status'] == 2
                  //                             ? const Color(0xFF9A9A9A)
                  //                             : const Color(0xFF9A9A9A),
                  //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                  //                   )),
                  //             ),
                  //             Visibility(
                  //                 visible: data['Status'] == 1
                  //                     ? false
                  //                     : data['Status'] == 2
                  //                         ? true
                  //                         : false,
                  //                 child: SizedBox(
                  //                     width: MediaQuery.of(context).size.width * 0.1,
                  //                     child: FloatingActionButton.extended(
                  //                       onPressed: () {},
                  //                       label: Text(
                  //                         'TRANSFER',
                  //                         style: GoogleFonts.openSans(fontWeight: FontWeight.w700),
                  //                       ),
                  //                       backgroundColor: const Color(0xFF0066CC),
                  //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                  //                     ))),
                  //           ],
                  //         )))
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          })
    ]);
  }
}
