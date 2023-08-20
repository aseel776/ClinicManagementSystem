import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/features/sidebar/data/models/rive_model.dart';
import 'package:clinic_management_system/features/sidebar/presentation/widgets/rive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:rive/rive.dart';

import 'custom_painter.dart';

class NavBarItem extends ConsumerStatefulWidget {
  final String? text;
  final String? svgPath;
  var onTap;
  final bool? selected;
  NavBarItem({
    super.key,
    this.text,
    this.svgPath,
    this.onTap,
    this.selected,
  });
  @override
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends ConsumerState<NavBarItem>
    with TickerProviderStateMixin {
  AnimationController? _controller1;
  AnimationController? _controller2;

  Animation<double>? _anim1;
  Animation<double>? _anim2;
  Animation<double>? _anim3;
  Animation<Color?>? _color;

  late RiveAnimationController __controller;

  bool hovered = false;

  @override
  void initState() {
    super.initState();
    final width = (WidgetsBinding.instance!.window.physicalSize.width /
        WidgetsBinding.instance!.window.devicePixelRatio);
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 275),
    );

    _anim1 = Tween(begin: width * 0.14, end: 65.0).animate(_controller1!);
    _anim2 = Tween(begin: width * 0.14, end: 15.0).animate(_controller2!);
    _anim3 = Tween(begin: width * 0.14, end: 40.0).animate(_controller2!);
    _color =
        ColorTween(end: const Color(0xff252525), begin: AppColors.lightGrey)
            .animate(_controller2!);

    _controller1!.addListener(() {
      setState(() {});
    });
    _controller2!.addListener(() {
      setState(() {});
    });
    // __controller = SimpleAnimation('idle');
  }

  // void _loadRiveFile() async {
  //   final bytes = await rootBundle.load('assets/RiveAssets/dollar4.riv');
  //   final file = RiveFile.import(bytes);
  //   print(file);
  //   if (file != null) {
  //     setState(() {
  //       _artboard = file.mainArtboard;
  //       __controller = SimpleAnimation('your_animation_name');
  //       __controller.isActive = true;
  //     });
  //   }
  // }

  // void _onEnter(PointerEnterEvent event) {
  //   setState(() {
  //     _isPlaying = true;
  //     if (__controller != null) {
  //       __controller.isActive = true;
  //     }
  //   });
  // }

  // void _onExit(PointerExitEvent event) {
  //   setState(() {
  //     _isPlaying = false;
  //     if (__controller != null) {
  //       __controller.isActive = false;
  //     }
  //   });
  // }

  @override
  void didUpdateWidget(NavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.selected!) {
      Future.delayed(const Duration(milliseconds: 10), () {
        _controller1!.reverse();
      });
      _controller1!.reverse();
      _controller2!.reverse();
    } else {
      _controller1!.forward();
      _controller2!.forward();
      Future.delayed(const Duration(milliseconds: 10), () {
        _controller2!.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hoveredTransform = Matrix4.identity()..scale(1.1);
    final transform = hovered ? hoveredTransform : Matrix4.identity();

    return GestureDetector(
      onTap: widget.onTap!,
      child: MouseRegion(
        onEnter: (value) {
          setState(() {
            hovered = true;
          });
          // ref.read(hovered.notifier).state = true;
        },
        onExit: (value) {
          setState(() {
            hovered = false;
          });
          // ref.read(hovered.notifier).state = false;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          transform: transform,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.14,
            color: hovered && !widget.selected!
                ? Colors.white12
                : Colors.transparent,
            child: Stack(
              children: [
                CustomPaint(
                  painter: CurvePainter(
                      value1: 0,
                      animValue1: _anim3!.value,
                      animValue2: _anim2!.value,
                      animValue3: _anim1!.value,
                      width: MediaQuery.of(context).size.width * 0.14),
                ),
                SizedBox(
                  height: 80.0,
                  width: MediaQuery.of(context).size.width * 0.14,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.text!,
                          style: TextStyle(
                            color: _color!.value,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        // SizedBox(
                        //   width: 40,
                        //   height: 40,
                        //   child: RiveAnimation.asset(
                        //     'assets/RiveAssets/little-icons.riv',
                        //     controllers: [__controller],
                        //     fit: BoxFit.contain,
                        //     onInit: (p0) => setState(() {}),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
