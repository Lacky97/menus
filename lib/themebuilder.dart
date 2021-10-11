import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, Brightness brightness) builder;
  final Brightness defaultBrightness;

  ThemeBuilder({required this.builder, required this.defaultBrightness});

  @override
  _ThemeBuilderState createState() => _ThemeBuilderState();

  static _ThemeBuilderState? of(BuildContext context) {
    return context.findAncestorStateOfType<_ThemeBuilderState>();
  }
}

class _ThemeBuilderState extends State<ThemeBuilder> {
  late Brightness _brightness;

  @override
  void initState() {
    super.initState();
    _brightness = Brightness.light;
    setTheme();
  }

  Future<void> setTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final color = prefs.getInt("Theme3");
    print(color.toString());
    if (color == 1) {
      setState(() {
        _brightness = Brightness.dark;
      });
    } else if (color == 0) {
      setState(() {
        _brightness = Brightness.light;
      });
    } else {
      await prefs.setInt("Theme3", 0);
      _brightness = Brightness.light;
    }
  }

  Future<void> changeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final color = prefs.getInt("Theme3");
    print(color.toString());
    if (color == 1) {
      await prefs.setInt("Theme3", 0);
      setState(() {
        _brightness = Brightness.dark;
      });
    } else {
      await prefs.setInt("Theme3", 1);
      setState(() {
        _brightness = Brightness.light;
      });
    }
    setState(() {
      _brightness =
          _brightness == Brightness.dark ? Brightness.light : Brightness.dark;
    });
  }

  Brightness getCurrentTheme() {
    return _brightness;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _brightness);
  }
}
