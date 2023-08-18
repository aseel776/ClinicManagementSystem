import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .sizeOf(context)
        .width;

    return ProviderScope(
      child: MaterialApp(
        title: "Clinic Management System",
        home: Directionality(
          textDirection: TextDirection.rtl,
          // child: ActiveMaterialsMainSection(sectionWidth: screenWidth * 0.8),
          child: Placeholder(),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
