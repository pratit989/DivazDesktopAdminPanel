import 'dart:async';

import 'package:admin/BLoC/firestore_bloc.dart';
import 'package:admin/Constants/design.dart';
import 'package:admin/Screens/admin_page.dart';
import 'package:admin/Screens/complaint_details.dart';
import 'package:admin/Screens/technicians.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:time_elapsed/time_elapsed.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late final StreamSubscription _streamSubscription;
  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();
  bool details = false;
  String complaintId = '';
  List<ChartData>? chartData;
  List<Technician> technicians = [];
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
    final _index = context.read<SelectedIndex>();
    ValueNotifier<List<ChartData>?> chart = ValueNotifier(chartData);
    if (!details) {
      return Row(
        children: [
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Complaints',
                      style: GoogleFonts.openSans(color: const Color(0xFF002E56), fontWeight: FontWeight.w700, fontSize: MediaQuery.of(context).size.height * 0.04)),
                  GestureDetector(
                      onTap: () => _index.setValue(1),
                      child: Text(
                        'See All',
                        style: GoogleFonts.openSans(color: const Color(0xFF002E56), fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.25,
                child: StreamBuilder<List<Document>>(
                    stream: DataService().firestore.collection('Complaints').stream,
                    builder: (context, AsyncSnapshot<List<Document>> snapshot) {
                      List<Document> data = [];
                      int completed = 0;
                      int pending = 0;
                      int assigned = 0;
                      if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                        for (var element in snapshot.data!) {
                          if (element['Status'] == 3) {
                            completed++;
                            data.add(element);
                          } else if (element['Status'] == 2) {
                            assigned++;
                            data.add(element);
                          } else if (element['Status'] == 1) {
                            pending++;
                            data.add(element);
                          }
                        }
                        Future.microtask(() => chart.value = [
                              ChartData('Completed', completed, Colors.grey),
                              ChartData('Assigned', assigned, Colors.blue),
                              ChartData('Pending', pending, Colors.indigo),
                            ]);
                        return Scrollbar(
                            isAlwaysShown: true,
                            controller: controller,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                controller: controller,
                                itemCount: data.length,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.18,
                                      decoration: BoxDecoration(
                                        gradient: backgroundGradient,
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context).size.width * 0.01,
                                            vertical: MediaQuery.of(context).size.height * 0.020),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Complaint UID',
                                              style: GoogleFonts.openSans(color: Colors.white),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.015),
                                              child: Text(
                                                data[index].id,
                                                style: GoogleFonts.openSans(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: MediaQuery.of(context).size.height * 0.02),
                                              ),
                                            ),
                                            const Divider(
                                              color: Colors.white,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(children: [
                                                    WidgetSpan(
                                                      child: Icon(Icons.date_range,
                                                          color: Colors.white, size: MediaQuery.of(context).size.width * 0.012),
                                                    ),
                                                    TextSpan(
                                                        text: Jiffy(data[index]['DateTime']).format('do MMM').toString(),
                                                        style: GoogleFonts.openSans(fontSize: MediaQuery.of(context).size.width * 0.008))
                                                  ]),
                                                ),
                                                RichText(
                                                    text: TextSpan(children: [
                                                  WidgetSpan(
                                                      child: Icon(Icons.timer, color: Colors.white, size: MediaQuery.of(context).size.width * 0.012)),
                                                  TextSpan(
                                                      text: TimeElapsed.fromDateTime(data[index]['DateTime']),
                                                      style: GoogleFonts.openSans(fontSize: MediaQuery.of(context).size.width * 0.008))
                                                ])),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () => setState(() {
                                                details = !details;
                                                complaintId = data[index].id;
                                              }),
                                              child: Text(
                                                'Details',
                                                style: GoogleFonts.openSans(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: MediaQuery.of(context).size.height * 0.02),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }));
                      }
                      return const SizedBox();
                    }),
              ),
              Card(
                elevation: 5,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Technicians',
                                style: GoogleFonts.openSans(color: const Color(0xFF002E56), fontWeight: FontWeight.w700, fontSize: MediaQuery.of(context).size.height * 0.04),
                              ),
                              GestureDetector(
                                onTap: () => _index.setValue(2),
                                child: Text(
                                  'See All',
                                  style: GoogleFonts.openSans(color: const Color(0xFF002E56), fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: SingleChildScrollView(
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
                          ),
                        )
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width * 0.25,
              child: Column(
                children: [
                  Expanded(
                    child: ValueListenableBuilder(
                        valueListenable: chart,
                        builder: (BuildContext context, List<ChartData>? chartList, Widget? widget) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[300],
                              ),
                              child: SfCircularChart(
                                  title: ChartTitle(
                                      text: 'Complaint Stats', textStyle: GoogleFonts.openSans(color: Colors.blue[900], fontWeight: FontWeight.w800)),
                                  legend: Legend(
                                    orientation: LegendItemOrientation.horizontal,
                                    position: LegendPosition.bottom,
                                    isVisible: true,
                                    isResponsive: true,
                                  ),
                                  series: <CircularSeries>[
                                    DoughnutSeries<ChartData, String>(
                                        dataSource: chartList,
                                        xValueMapper: (ChartData data, _) => data.x,
                                        yValueMapper: (ChartData data, _) => data.y,
                                        pointColorMapper: (ChartData data, _) => data.color,
                                        enableTooltip: true,
                                        dataLabelSettings: const DataLabelSettings(isVisible: true, labelPosition: ChartDataLabelPosition.outside))
                                  ]),
                            ),
                          );
                        }),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          image: const DecorationImage(image: AssetImage('assets/images/add_tech_graphic.png'), fit: BoxFit.cover),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Add Technicians',
                                  style: GoogleFonts.openSans(color: Colors.blue[900], fontSize: 20, fontWeight: FontWeight.w800),
                                ),
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: 'Click here',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            _index.setValue(6);
                                          },
                                        style: GoogleFonts.openSans(color: Colors.blue)),
                                    TextSpan(text: ' to add', style: GoogleFonts.openSans(color: Colors.black))
                                  ]),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ],
      );
    }
    return ComplaintDetails(toggleDetails: () => setState(() {
      details = false;
    }), complaintId: complaintId,);
  }
}

class ChartData extends ChangeNotifier {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final int y;
  final Color? color;
}
