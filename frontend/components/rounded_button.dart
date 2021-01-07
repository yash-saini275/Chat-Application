import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({this.buttonColor, @required this.onPress, this.buttonTitle});
  final Color buttonColor;
  final Function onPress;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      child: Material(
        elevation: 5.0,
        color: buttonColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPress,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonTitle,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
