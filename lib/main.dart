import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './features/appointments_sessions/presentation/widgets/main_section.dart';

void main() async {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return const ProviderScope(
      child: MaterialApp(
        title: "Clinic Management System",
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: AppointmentsMainSection(),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
