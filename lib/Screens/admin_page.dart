import 'package:admin/Constants/design.dart';
import 'package:admin/Screens/add_product.dart';
import 'package:admin/Screens/add_tech.dart';
import 'package:admin/Screens/complaints.dart';
import 'package:admin/Screens/dashboard.dart';
import 'package:admin/Screens/dealers.dart';
import 'package:admin/Screens/sign_in.dart';
import 'package:admin/Screens/tech_success.dart';
import 'package:admin/Screens/technicians.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Widget? display;

  final List<NavigationRailDestination> _destinations = [
    const NavigationRailDestination(
        icon: Icon(Icons.dashboard),
        label: Text('Dashboard'),
        padding: EdgeInsets.zero),
    const NavigationRailDestination(
        icon: Icon(Icons.assignment_outlined),
        label: Text('Complaints'),
        padding: EdgeInsets.zero),
    const NavigationRailDestination(
        icon: Icon(Icons.people),
        label: Text('Technicians'),
        padding: EdgeInsets.zero),
    const NavigationRailDestination(
        icon: Icon(Icons.person),
        label: Text('Dealers'),
        padding: EdgeInsets.zero),
    const NavigationRailDestination(
        icon: Icon(Icons.qr_code),
        label: Text('Add QR Codes'),
        padding: EdgeInsets.zero),
    const NavigationRailDestination(
        icon: Icon(Icons.logout),
        label: Text('Logout'),
        padding: EdgeInsets.zero),
  ];

  List<Widget> screens = [
    const Dashboard(),
    const Complaints(),
    const Tech(),
    const Dealers(),
    const AddProduct(),
    loader,
    const AddTech(),
    const TechSuccess(),
  ];
  SelectedIndex displayIndex = SelectedIndex();
  SelectedIndex selectionIndex = SelectedIndex();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectedIndex>(
      create: (_) => displayIndex,
      child: Consumer<SelectedIndex>(builder: (_, indexUser, __) {
        if (indexUser.index.value == 5) {
          Future.microtask(() => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SignIn()),
                  (route) => false));
          return loader;
        } else {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: kToolbarHeight,
                    child: MoveWindow(),
                  ),
                  backgroundColor: const Color(0xFFFDFDFD),
                  elevation: 0,
                  actions: [
                    MinimizeWindowButton(),
                    MaximizeWindowButton(),
                    CloseWindowButton(),
                  ],
                ),
                body: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 80,
                          width: 80,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height*0.8,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            borderRadius:
                            BorderRadius.only(topRight: Radius.circular(40)),
                          ),
                          child: NavigationRail(
                            unselectedLabelTextStyle:
                            const TextStyle(fontWeight: FontWeight.w600),
                            selectedIconTheme: IconThemeData(color: Colors.blue[900]),
                            selectedLabelTextStyle: TextStyle(
                                color: Colors.blue[900], fontWeight: FontWeight.w800),
                            destinations: _destinations,
                            selectedIndex: selectionIndex.index.value,
                            extended: true,
                            onDestinationSelected: (int index) {
                              setState(() {
                                selectionIndex.setValue(index);
                                displayIndex.setValue(index);
                              });
                            },
                            backgroundColor: Colors.grey[300],
                            minExtendedWidth: 200,
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.03),
                          child: screens[indexUser.index.value]
                      ),
                    ),
                  ],
                ),
              ),
              logo
            ],
          );
        }
      },)
    );
    // final user = context.read<User>();
  }
}


class SelectedIndex with ChangeNotifier {
  ValueNotifier<int> index = ValueNotifier<int>(0);

  void setValue (int val) {
    index.value = val;
    notifyListeners();
  }

  void increment () {
    index.value++;
    notifyListeners();
  }
}