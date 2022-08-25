import 'package:flutter/material.dart';
import 'package:wardrobe_flutter/screens/show_all_wardrobes_screen.dart';

void gotoHome(BuildContext context) {
  Navigator.pushReplacementNamed(context, ShowAllWardrobesScreen.routeName);
}
