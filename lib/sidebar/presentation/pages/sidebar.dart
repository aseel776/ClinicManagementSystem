import 'package:clinic_management_system/features/medicine/presentation/Pages/medicine_page.dart';
import 'package:clinic_management_system/features/patients_management/presentation/pages/patients.dart';
import 'package:clinic_management_system/features/patients_management/presentation/pages/patients_index.dart';
import 'package:clinic_management_system/features/repository_feature/presentation/pages/repository.dart';
import 'package:flutter/material.dart';
import '../../../diseases_badHabits_teeth/presentation/pages/badHabits.dart';
import '../../../diseases_badHabits_teeth/presentation/pages/diseases.dart';
import '../../../diseases_badHabits_teeth/presentation/pages/general.dart';
import '../../../diseases_badHabits_teeth/presentation/widgets/content_view.dart';
import '../../../diseases_badHabits_teeth/presentation/widgets/custom_tab.dart';
import '../../../patients_management/presentation/pages/patient_profile.dart';
import '../widgets/navbar_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageProvider = StateProvider<Widget>((ref) => General());
final SelectedPageProvider =
    StateProvider<List<bool>>((ref) => [false, false, false, false, false]);

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
    NavBarData(pageName: "Dashboard", svgIconPath: "assets/svgs/dashboard.svg"):
        MedicinePage(),
    NavBarData(
        pageName: "Appointments",
        svgIconPath: "assets/svgs/appointment.svg"): General(),
    NavBarData(pageName: "Patients", svgIconPath: "assets/svgs/patients.svg"):
        CreatePatients(),
    NavBarData(
        pageName: "Repository",
        svgIconPath: "assets/svgs/repository.svg"): PatientIndex(),
    NavBarData(pageName: "Payments", svgIconPath: "assets/svgs/payments.svg"):
        RepositoryScreen()
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
