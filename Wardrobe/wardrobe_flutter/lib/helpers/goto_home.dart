import 'package:flutter/material.dart';
import 'package:wardrobe_flutter/screens/wardrobes_screen.dart';

void gotoHome(BuildContext context) {
  Navigator.pushReplacementNamed(context, WardrobesScreen.routeName);
}
