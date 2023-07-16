import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/treatments_feature/presentation/widgets/sections/main_section.dart';

void main() async{
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
          child: TreatmentsMainSection(sectionWidth: screenWidth * 0.8),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );

  }
}
