import 'dart:async';

import 'package:admin/BLoC/firestore_bloc.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

String complaintId = '';

class Tech extends StatefulWidget {
  const Tech({Key? key}) : super(key: key);

  @override
  _TechState createState() => _TechState();
}

class _TechState extends State<Tech> {
  late final StreamSubscription _streamSubscription;
  final ScrollController controller = ScrollController();
  int triggerCount = 0;
  List<Technician> technicians = [];
  bool details = false;
  late TechnicianDataSource _technicianDataSource = TechnicianDataSource(technicians: technicians, function: (iD) {});
  late Map<String, double> columnWidths = {
    'name': double.nan,
    'status': double.nan,
    'details': MediaQuery.of(context).size.width * 0.1,
  };
  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _streamSubscription = DataService().technicians.listen((event) {
      setState(() {
        technicians = [];
        technicians.addAll(event.map((e) {
          Document document = e;
          return Technician(document['Name'], document['Status'] ?? 'offline');
        }));
        _technicianDataSource = TechnicianDataSource(
            technicians: technicians,
            function: (iD) => setState(() {
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
                      'Technicians',
                      style: TextStyle(color: const Color(0xFF002E56), fontWeight: FontWeight.w800, fontSize: MediaQuery.of(context).size.height * 0.04),
                    ),
                  ],
                ),
                Text(
                  'Total Technicians: ${technicians.length}',
                  style: TextStyle(color: Colors.blue[900]),
                )
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.65,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(12)), color: Colors.white, boxShadow: [BoxShadow(color: Color(0x29000000), offset: Offset(0, 3), blurRadius: 3)]),
          child: SfDataGrid(
            source: _technicianDataSource,
            columns: [
              GridColumn(
                  columnWidthMode: ColumnWidthMode.fill,
                  columnName: 'name',
                  width: columnWidths['name']!,
                  label: Container(
                      color: const Color(0xFFF3F3F3),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Name',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.openSans(color: const Color(0xFF828282), fontWeight: FontWeight.w600),
                      ))),
              GridColumn(
                  columnName: 'status',
                  width: columnWidths['status']!,
                  label: Container(
                      color: const Color(0xFFF3F3F3),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Status',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.openSans(color: const Color(0xFF828282), fontWeight: FontWeight.w600),
                      ))),
              // GridColumn(
              //     columnName: 'details',
              //     width: columnWidths['details']!,
              //     label: Container(
              //         color: const Color(0xFFF3F3F3),
              //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //         alignment: Alignment.center,
              //         child: Text(
              //           '',
              //           overflow: TextOverflow.ellipsis,
              //           style: GoogleFonts.openSans(color: const Color(0xFF828282), fontWeight: FontWeight.w600),
              //         ))),
            ],
            columnWidthMode: ColumnWidthMode.fill,
            shrinkWrapRows: true,
          )
        ),
      ],
    );
  }
}

class TechnicianDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  Function(String)? toggleDetails;

  TechnicianDataSource({required List<Technician> technicians, required Function(String) function}) {
    toggleDetails = function;
    dataGridRows = technicians
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
              DataGridCell<String>(columnName: 'status', value: dataGridRow.status),
              // DataGridCell<String>(columnName: 'details', value: dataGridRow.details),
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
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: dataGridCell.columnName == 'status'
              ? RichText(
                  text: TextSpan(children: [
                    WidgetSpan(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.circle,
                        color: dataGridCell.value == 'busy'
                            ? Colors.red[400]
                            : dataGridCell.value == 'idle'
                                ? Colors.green[400]
                                : Colors.grey[400],
                      ),
                    )),
                    TextSpan(text: dataGridCell.value, style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.w600))
                  ]),
                )
              : GestureDetector(
                  onTap: () => dataGridCell.columnName == 'details' ? toggleDetails!(row.getCells()[1].value) : null,
                  child: Text(
                    dataGridCell.value.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.openSans(
                        fontWeight: dataGridCell.columnName == 'status' ? FontWeight.w600 : FontWeight.w700, color: const Color(0xFF001E3B)),
                  ),
                ));
    }).toList());
  }
}

class Technician {
  Technician(this.name, this.status);

  final String name;
  final String status;
  final String details = 'Details';
}
