import 'package:flutter/material.dart';

class CustomNavigationButton extends StatefulWidget {
  final String? text;
  final Function? fun;
  bool? selected;
  CustomNavigationButton({super.key, this.fun, this.text, this.selected});
  @override
  _CustomNavigationButtonState createState() => _CustomNavigationButtonState();
}

class _CustomNavigationButtonState extends State<CustomNavigationButton> {
  int? duration;
  Color? color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.fun!();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: duration ?? 100),
        decoration: BoxDecoration(
          color: color ?? Colors.black45,
        ),
        height: 30,
        width: 190,
        child: Center(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  widget.text!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.0),
                ),
              ),
              widget.text == "accepted request"
                  ? const SizedBox(
                      width: 5,
                    )
                  : const Spacer(),
              if (widget.selected == true)
                widget.text == "accepted request"
                    ? const Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.check,
                          color: Colors.white54,
                          size: 18,
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.check,
                          color: Colors.white54,
                          size: 18,
                        ),
                      )
            ],
          ),
        ),
      ),
    );
  }
}
