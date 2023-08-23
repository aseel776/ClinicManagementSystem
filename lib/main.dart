import 'package:clinic_management_system/features/appointments_sessions/presentation/widgets/apps_main_section.dart';
import 'package:clinic_management_system/features/diseases_badHabits/presentation/pages/general.dart';
import 'package:clinic_management_system/features/medicine/presentation/Pages/medicine_page.dart';
import 'package:clinic_management_system/sidebar/presentation/pages/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinic_management_system/features/treatments_feature/presentation/sections/main_section.dart';

import 'core/app_colors.dart';
import 'core/primaryText.dart';

void main() async {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return ProviderScope(
      child: MaterialApp(
        title: "Clinic Management System",
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: MainPage1(),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainPage1 extends ConsumerWidget {
  MainPage1({super.key});
  final List<Page> pages = [
    Page('الأدوية', MedicinePage()),
    Page('المعالجات ', TreatmentsMainSection()),
    Page('الأمراض ومشاكل الأسنان ', General()),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.black.withOpacity(0.9),
        elevation: 10,
        toolbarHeight: MediaQuery.of(context).size.height * 0.07,
        title: Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Row(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                  // width: MediaQuery.of(context).size.width * .04
                  child: Image.asset("assets/images/logo2.png", fit: BoxFit.fill,)
              ),
             // AssetImage("assets/images/logo.png"),
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: PrimaryText(
                  text: "مرحباً د.إحسان",
                ),
              )
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.notification_add)),
          const SizedBox(
            width: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
                onPressed: () {
                  PopupMenuButton<String>(
                    itemBuilder: (context) {
                      return pages.map((page) {
                        return PopupMenuItem<String>(
                          value: page.name,
                          child: Text(page.name),
                        );
                      }).toList();
                    },
                    onSelected: (selectedPageName) {
                      final selectedPage = pages.firstWhere(
                        (page) => page.name == selectedPageName,
                        orElse: () => pages.first,
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => selectedPage.widget),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.settings_rounded)),
          )
        ],
      ),
      body: Stack(
        children: [
          // WindowTitleBarBox(
          //   child: Row(
          //     children: [Expanded(child: Container()), WindowButtons()],
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Sidebar(),
              Expanded(child: ref.watch(pageProvider))
            ],
          ),
        ],
      ),
    );
  }
}

class Page {
  final String name;
  final Widget widget;

  Page(this.name, this.widget);
}
