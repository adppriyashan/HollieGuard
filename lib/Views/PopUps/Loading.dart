import 'package:flutter/material.dart';
import 'package:hollieguard/Models/Utils/Colors.dart';

class Loading extends StatefulWidget {
  String? message;

  Loading({this.message});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => LoadingState(message: message);
}

class LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  String? message;

  LoadingState({required this.message});

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));

    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            alignment: Alignment.center,
            child: Center(
              child: (message != null)
                  ? Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                      direction: Axis.vertical,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Text(
                            message!,
                            style: TextStyle(fontSize: 14.0, color: color6),
                          ),
                        ),
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(colorPrimary),
                        )
                      ],
                    )
                  : CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(colorPrimary),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
