// import 'package:rive/rive.dart';
//
// class RiveUtils {
//   static SMIBool getRiveInput(Artboard artboard,
//       {required String stateMachineName}) {
//     print("ssdsd");
//     StateMachineController? controller =
//         StateMachineController.fromArtboard(artboard, stateMachineName);
//     print(controller);
//
//     artboard.addController(controller!);
//
//     return controller.findInput<bool>("active") as SMIBool;
//   }
//
//   static void chnageSMIBoolState(SMIBool input) {
//     input.change(true);
//     Future.delayed(
//       const Duration(seconds: 1),
//       () {
//         input.change(false);
//       },
//     );
//   }
// }
