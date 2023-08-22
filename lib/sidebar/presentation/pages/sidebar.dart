import 'package:clinic_management_system/features/appointments_sessions/presentation/widgets/apps_main_section.dart';
import 'package:clinic_management_system/features/diseases_badHabits/presentation/pages/general.dart';
import 'package:clinic_management_system/features/lab_feature/presentation/pages/lab_screen.dart';
import 'package:clinic_management_system/features/medicine/data/model/active_materials.dart';
import 'package:clinic_management_system/features/medicine/presentation/Pages/medicine_page.dart';
import 'package:clinic_management_system/features/patients_management/presentation/pages/patients.dart';
import 'package:clinic_management_system/features/patients_management/presentation/pages/patients_index.dart';
import 'package:clinic_management_system/features/repository_feature/presentation/pages/repository.dart';
import 'package:clinic_management_system/features/treatments_feature/presentation/sections/main_section.dart';
import 'package:flutter/material.dart';
import '../../../features/active_materials_feature/presentation/widgets/main_section.dart';
import '../widgets/navbar_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageProvider = StateProvider<Widget>((ref) => AppointmentsMainSection());
final SelectedPageProvider =
    StateProvider<List<bool>>((ref) => [true, false, false, false, false]);

class Sidebar extends ConsumerStatefulWidget {
  const Sidebar({super.key});

  @override
  _SidebarState createState() => _SidebarState();
}

class NavBarData {
  String? pageName;
  String? svgIconPath;
  NavBarData({this.pageName, this.svgIconPath});
}

// List<bool> selected = [false, false, false, false, false];

class _SidebarState extends ConsumerState<Sidebar> {
  Map<NavBarData, Widget> nameToRoute = {
    NavBarData(pageName: "المواعيد", svgIconPath: "assets/svgs/dashboard.svg"):
        AppointmentsMainSection(),
    NavBarData(
        pageName: "المرضى",
        svgIconPath: "assets/svgs/appointment.svg"): PatientIndex(),
    NavBarData(pageName: "المخابر", svgIconPath: "assets/svgs/patients.svg"):
        LabsScreen(),
    NavBarData(pageName: "المستودع", svgIconPath: "assets/svgs/patients.svg"):
    RepositoryScreen(),
    NavBarData(pageName: "المعالجات", svgIconPath: "assets/svgs/patients.svg"):
    TreatmentsMainSection(),
  };

  void select(int n, WidgetRef ref) {
    for (int i = 0; i < 5; i++) {
      if (i == n) {
        ref.read(SelectedPageProvider.notifier).state[i] = true;

        // selected[i] = true;
      } else {
        ref.read(SelectedPageProvider.notifier).state[i] = false;
        // selected[i] = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.1, right: 8, left: 8),
          child: Container(
            margin: const EdgeInsets.all(8.0),
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.14,
            decoration: BoxDecoration(
              color: const Color(0xff252525),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Stack(
              children: [
                Column(
                  children: nameToRoute.keys.map((NavBarData key) {
                    return NavBarItem(
                      text: key.pageName,
                      svgPath: key.svgIconPath,
                      selected:
                          // selected[nameToRoute.keys.toList().indexOf(key)],
                          ref.watch(SelectedPageProvider)[
                              nameToRoute.keys.toList().indexOf(key)],
                      onTap: () {
                        ref.read(pageProvider.notifier).state =
                            nameToRoute[key]!;
                        setState(() {
                          select(nameToRoute.keys.toList().indexOf(key), ref);
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
