import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../BLoC/firestore_bloc.dart';
import 'add_dealer.dart';

class Dealers extends StatefulWidget {
  const Dealers({Key? key}) : super(key: key);

  @override
  _DealersState createState() => _DealersState();
}

class _DealersState extends State<Dealers> {
  late final StreamSubscription _streamSubscription;
  final ScrollController controller = ScrollController();
  List<Dealer> dealers = [];
  bool newDealer = false;
  late final AddDealer _addDealer = AddDealer(toggle: () => setState(() {
    newDealer = !newDealer;
  }),);
  late DealerDataSource _dealerDataSource = DealerDataSource(dealers: dealers);
  late Map<String, double> columnWidths = {
    'companyName': double.nan,
    'state': MediaQuery.of(context).size.width * 0.1,
    'place': MediaQuery.of(context).size.width * 0.1,
    'phoneNumber': MediaQuery.of(context).size.width * 0.1,
    'name': double.nan,
    'aadharCardNumber': MediaQuery.of(context).size.width * 0.1,
  };
  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _streamSubscription = DataService().dealers.listen((event) {
      setState(() {
        dealers = [];
        dealers.addAll(event.map((document) {
          return Dealer(
            companyName: document['CompanyName'],
            state: document['State'],
            aadharCardNumber: document['AdharCard'],
            place: document['Place'],
            phoneNumber: document['PhoneNumber'],
            name: document['Name'],
          );
        }));
        _dealerDataSource = DealerDataSource(dealers: dealers);
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
    return newDealer ? _addDealer : Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(text: 'Dealers', children: [WidgetSpan(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(onTap: () => setState(() {
                      newDealer = !newDealer;
                    }),child: const Icon(Icons.add_circle)),
                  ), alignment: PlaceholderAlignment.middle)], style: GoogleFonts.openSans(color: const Color(0xFF002E56), fontWeight: FontWeight.w700, fontSize: MediaQuery.of(context).size.height * 0.04),),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              color: Colors.white,
              boxShadow: [BoxShadow(color: Color(0x29000000), offset: Offset(0, 3), blurRadius: 3)]),
          clipBehavior: Clip.antiAlias,
          child: SfDataGrid(
            key: key,
            allowSorting: true,
            allowColumnsResizing: true,
            onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
              setState(() {
                columnWidths[details.column.columnName] = details.width;
              });
              return true;
            },
            source: _dealerDataSource,
            columns: [
              GridColumn(
                  columnWidthMode: ColumnWidthMode.fill,
                  columnName: 'companyName',
                  width: columnWidths['companyName']!,
                  label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      color: const Color(0xFFF3F3F3),
                      alignment: Alignment.center,
                      child: Text(
                        'Company Name',
                        style: GoogleFonts.openSans(color: const Color(0xFF828282), fontWeight: FontWeight.w600),
                      ))),
              GridColumn(
                  columnWidthMode: ColumnWidthMode.fill,
                  columnName: 'state',
                  width: columnWidths['state']!,
                  label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerLeft,
                      color: const Color(0xFFF3F3F3),
                      child: Text(
                        'State',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.openSans(color: const Color(0xFF828282), fontWeight: FontWeight.w600),
                      ))),
              GridColumn(
                  columnName: 'place',
                  width: columnWidths['place']!,
                  label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerLeft,
                      color: const Color(0xFFF3F3F3),
                      child: Text(
                        'Place',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.openSans(color: const Color(0xFF828282), fontWeight: FontWeight.w600),
                      ))),
              GridColumn(
                  columnName: 'phoneNumber',
                  width: columnWidths['phoneNumber']!,
                  label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.center,
                      color: const Color(0xFFF3F3F3),
                      child: Text(
                        'Phone Number',
                        style: GoogleFonts.openSans(color: const Color(0xFF828282), fontWeight: FontWeight.w600),
                      ))),
              GridColumn(
                  columnName: 'name',
                  columnWidthMode: ColumnWidthMode.fill,
                  width: columnWidths['name']!,
                  label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.center,
                      color: const Color(0xFFF3F3F3),
                      child: Text(
                        'Name',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.openSans(color: const Color(0xFF828282), fontWeight: FontWeight.w600),
                      ))),
              GridColumn(
                  columnName: 'aadharCardNumber',
                  width: columnWidths['aadharCardNumber']!,
                  label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.center,
                      color: const Color(0xFFF3F3F3),
                      child: Text(
                        'Aadhar Card Number',
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

class DealerDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];

  DealerDataSource({required List<Dealer> dealers}) {
    dataGridRows = dealers
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'companyName', value: dataGridRow.companyName),
              DataGridCell<String>(columnName: 'state', value: dataGridRow.state),
              DataGridCell<String>(columnName: 'place', value: dataGridRow.place),
              DataGridCell<String>(columnName: 'phoneNumber', value: dataGridRow.phoneNumber),
              DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
              DataGridCell<String>(columnName: 'aadharCardNumber', value: dataGridRow.aadharCardNumber),
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
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          clipBehavior: Clip.antiAlias,
          child: dataGridCell.columnName == 'name'
              ? RichText(
                  text: TextSpan(children: [
                  const WidgetSpan(
                      child: Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.person,
                    ),
                  )),
                  TextSpan(text: dataGridCell.value.toString(), style: GoogleFonts.openSans(color: Colors.blue[900], fontWeight: FontWeight.w600))
                ]))
              : Text(
                  dataGridCell.value.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.openSans(
                      fontWeight: dataGridCell.columnName == 'status' ? FontWeight.w600 : FontWeight.w700, color: const Color(0xFF001E3B)),
                ));
    }).toList());
  }
}

class Dealer {
  Dealer(
      {required this.companyName,
      required this.state,
      required this.place,
      required this.phoneNumber,
      required this.name,
      required this.aadharCardNumber});

  final String companyName;
  final String state;
  final String place;
  final String phoneNumber;
  final String name;
  final String aadharCardNumber;
}
