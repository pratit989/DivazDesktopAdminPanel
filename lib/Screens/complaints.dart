import 'dart:async';

import 'package:admin/BLoC/firestore_bloc.dart';
import 'package:admin/Screens/complaint_details.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:time_elapsed/time_elapsed.dart';

String complaintId = '';

class Complaints extends StatefulWidget {
  const Complaints({Key? key}) : super(key: key);

  @override
  _ComplaintsState createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  late final StreamSubscription _streamSubscription;
  final ScrollController controller = ScrollController();
  List<Complaint> complaints = [];
  bool details = false;
  late ComplaintDataSource _complaintDataSource = ComplaintDataSource(complaints: complaints, function: (iD) {});
  late Map<String, double> columnWidths = {
    'id': MediaQuery.of(context).size.width*0.05,
    'complaintNumber': double.nan,
    'date': MediaQuery.of(context).size.width*0.1,
    'timeElapsed': MediaQuery.of(context).size.width*0.1,
    'status': double.nan,
    'details': MediaQuery.of(context).size.width*0.1,
  };
  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _streamSubscription = DataService().firestore.collection('Complaints').stream.listen((event) {
      setState(() {
        complaints = [];
        complaints.addAll(event.asMap().entries.map((e) {
          int index = e.key;
          Document document = e.value;
          return Complaint(index + 1, document.id, Jiffy(document['DateTime']).format('do MMM').toString(),
              TimeElapsed.fromDateTime(document['DateTime']) + ' ago', document['Status'] == 2 ? 'In - Progress' : document['Status'] == 1 ? 'Pending' : 'Completed');
        }));
        _complaintDataSource = ComplaintDataSource(complaints: complaints, function: (iD) => setState(() {
          complaintId = iD;
          details = !details;
        }));
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (details) {
      return ComplaintDetails(toggleDetails: () => setState(() => details = !details), complaintId: complaintId);
    } else {
      return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Complaints',
                      style:
                          GoogleFonts.openSans(color: const Color(0xFF002E56), fontWeight: FontWeight.w700, fontSize: MediaQuery.of(context).size.height * 0.04),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(46),
              color: const Color(0xFFF7F7F7),
              boxShadow: const [BoxShadow(color: Color(0x29000000), offset: Offset(0, 3), blurRadius: 3)]
          ),
          clipBehavior: Clip.antiAlias,
          child: SfDataGrid(
            key: key,
            source: _complaintDataSource,
            allowSorting: true,
            allowColumnsResizing: true,
            onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
              setState(() {
                columnWidths[details.column.columnName] = details.width;
              });
              return true;
            },
            columns: [
              GridColumn(
                  columnWidthMode: ColumnWidthMode.fill,
                  columnName: 'id',
                  width: columnWidths['id']!,
                  label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Sr no',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.openSans(color: const Color(0xFF828282), fontWeight: FontWeight.w600),
                      ))),
              GridColumn(
                  columnWidthMode: ColumnWidthMode.fill,
                  columnName: 'complaintNumber',
                  width: columnWidths['complaintNumber']!,
                  label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Complaint Number',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.openSans(color: const Color(0xFF828282), fontWeight: FontWeight.w600),
                      ))),
              GridColumn(
                  columnName: 'date',
                  width: columnWidths['date']!,
                  label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Date',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.openSans(color: const Color(0xFF828282), fontWeight: FontWeight.w600),
                      ))),
              GridColumn(
                  columnName: 'timeElapsed',
                  width: columnWidths['timeElapsed']!,
                  label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Time',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.openSans(color: const Color(0xFF828282), fontWeight: FontWeight.w600),
                      ))),
              GridColumn(
                  columnName: 'status',
                  width: columnWidths['status']!,
                  label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Status',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.openSans(color: const Color(0xFF828282), fontWeight: FontWeight.w600),
                      ))),
              GridColumn(
                  columnName: 'details',
                  width: columnWidths['details']!,
                  label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.center,
                      child: Text(
                        '',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.openSans(color: const Color(0xFF828282), fontWeight: FontWeight.w600),
                      ))),
            ],
            columnWidthMode: ColumnWidthMode.fill,
            shrinkWrapRows: true,
          ),
        )
      ],
    );
    }
  }
}

class ComplaintDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  Function(String)? toggleDetails;

  ComplaintDataSource({required List<Complaint> complaints, required Function(String) function}) {
    toggleDetails = function;
    dataGridRows = complaints
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
              DataGridCell<String>(columnName: 'complaintNumber', value: dataGridRow.complaintNumber),
              DataGridCell<String>(columnName: 'date', value: dataGridRow.date),
              DataGridCell<String>(columnName: 'timeElapsed', value: dataGridRow.timeElapsed),
              DataGridCell<String>(columnName: 'status', value: dataGridRow.status),
              DataGridCell<String>(columnName: 'details', value: dataGridRow.details),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    // TODO: implement buildRow
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: (dataGridCell.columnName == 'id') ? Alignment.centerRight : Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          margin: dataGridCell.columnName == 'status' ? const EdgeInsets.all(8) : EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: dataGridCell.columnName == 'status' ? BorderRadius.circular(14) : BorderRadius.only(bottomLeft: (dataGridCell.columnName == 'id' && row.getCells().last == dataGridCell) ? const Radius.circular(46) : Radius.zero, bottomRight: (dataGridCell.columnName == 'details' && row.getCells().first == dataGridCell) ? const Radius.circular(46) : Radius.zero),
            color: dataGridCell.columnName == 'status' ? dataGridCell.value == 'In - Progress' ? const Color(0xFFDAEFFF) : dataGridCell.value == 'Completed' ? const Color(0xFF94D4A3) : const Color(0xFFFFBEBE) : Colors.transparent,
          ),
          clipBehavior: Clip.antiAlias,
          child: GestureDetector(
            onTap: () => dataGridCell.columnName == 'details' ? toggleDetails!(row.getCells()[1].value) : null,
            child: Text(
              dataGridCell.value.toString(),
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.openSans(fontWeight: dataGridCell.columnName == 'status' ? FontWeight.w600 : FontWeight.w700, color: const Color(0xFF001E3B)),
            ),
          ));
    }).toList());
  }
}

class Complaint {
  Complaint(this.id, this.complaintNumber, this.date, this.timeElapsed, this.status);

  final int id;
  final String complaintNumber;
  final String date;
  final String timeElapsed;
  final String status;
  final String details = 'Details';
}
