import 'package:flutter/material.dart';
//import 'package:flutter/physics.dart';
import 'package:sprung/sprung.dart';

void main() {
  Paint.enableDithering = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final ValueNotifier<ThemeMode> _theme = ValueNotifier<ThemeMode>(ThemeMode.dark);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: _theme,
        builder: (BuildContext context, ThemeMode value, Widget? child) {
          return MaterialApp(
            title: 'Sprung Easing Visualizer',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              sliderTheme: const SliderThemeData(
                thumbShape: RoundSliderThumbShape(
                  elevation: 4.0,
                  pressedElevation: 12.0,
                ),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
              sliderTheme: const SliderThemeData(
                thumbShape: RoundSliderThumbShape(
                  elevation: 4.0,
                  pressedElevation: 12.0,
                ),
              ),
            ),
            themeMode: value,
            home: const MyHomePage(),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<AlignmentGeometry> _animation, _animation2;
  //late double _massSliderValue = 30, _stiffnessSliderValue = 1, _dampingSliderValue = 1, _initialVelocitySliderValue = 0;
  late double _massSliderValue = 1.0, _stiffnessSliderValue = 180, _dampingSliderValue = 20, _initialVelocitySliderValue = 0;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _animation = _controller.drive(AlignmentTween(begin: Alignment.centerLeft, end: Alignment.centerRight));
    _animation2 = CurvedAnimation(
        parent: _controller,
        curve: Sprung.custom(
          mass: _massSliderValue,
          stiffness: _stiffnessSliderValue,
          damping: _dampingSliderValue,
          velocity: _initialVelocitySliderValue,
        )).drive(AlignmentTween(begin: Alignment.centerLeft, end: Alignment.centerRight));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sprung Easing Visualizer',
          style: TextStyle(color: (MyApp._theme.value == ThemeMode.dark) ? Colors.white : Colors.black),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: <IconButton>[
          IconButton(
            onPressed: () {
              MyApp._theme.value = (MyApp._theme.value == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
              setState(() {});
            },
            icon: Icon(
              (MyApp._theme.value == ThemeMode.dark) ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: (MyApp._theme.value == ThemeMode.dark) ? Colors.white : Colors.black,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                      style: ButtonStyle(shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder())),
                      onPressed:
                          (/*_massSliderValue != 30 ||
                              _stiffnessSliderValue != 1 ||
                              _dampingSliderValue != 1 ||
                              _initialVelocitySliderValue != 0*/
                                  _massSliderValue != 1.0 ||
                                      _stiffnessSliderValue != 180 ||
                                      _dampingSliderValue != 20 ||
                                      _initialVelocitySliderValue != 0)
                              ? () {
                                  setState(() {
                                    /*_massSliderValue = 30;
                                _stiffnessSliderValue = 1;
                                _dampingSliderValue = 1;
                                _initialVelocitySliderValue = 0;*/
                                    _massSliderValue = 1.0;
                                    _stiffnessSliderValue = 180;
                                    _dampingSliderValue = 20;
                                    _initialVelocitySliderValue = 0;
                                  });
                                  _controller.reset();
                                }
                              : null,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Reset to Initial Values')),
                ),
                const SizedBox(height: 8.0),
                Material(
                  elevation: 24.0,
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: ShapeDecoration(
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          Colors.white.withOpacity(0.1),
                          Colors.transparent,
                          Colors.black.withOpacity(/*0.24*/ 0.16),
                        ],
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Center(
                                child: Text('Mass: ${_massSliderValue.toStringAsFixed(1)}',
                                    style: const TextStyle(fontWeight: FontWeight.w600))),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                //style: ButtonStyle(shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder())),
                                onTap: () {
                                  setState(() {
                                    _massSliderValue = 30;
                                  });
                                  _controller.reset();
                                },
                                child: const Icon(Icons.refresh_rounded),
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _massSliderValue,
                          min: 0.1,
                          max: 100,
                          label: _massSliderValue.toStringAsFixed(1),
                          onChanged: (double value) {
                            setState(() {
                              _massSliderValue = value;
                            });
                          },
                        ),
                        const SizedBox(height: 8.0),
                        Stack(
                          children: <Widget>[
                            Center(
                                child: Text('Stiffness: ${_stiffnessSliderValue.toStringAsFixed(1)}',
                                    style: const TextStyle(fontWeight: FontWeight.w600))),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                //style: ButtonStyle(shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder())),
                                onTap: () {
                                  setState(() {
                                    _stiffnessSliderValue = 1;
                                  });
                                  _controller.reset();
                                },
                                child: const Icon(Icons.refresh_rounded),
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _stiffnessSliderValue,
                          min: 0,
                          max: 1000,
                          label: _stiffnessSliderValue.toStringAsFixed(1),
                          onChanged: (double value) {
                            setState(() {
                              _stiffnessSliderValue = value;
                            });
                          },
                        ),
                        const SizedBox(height: 8.0),
                        Stack(
                          children: <Widget>[
                            Center(
                                child: Text('Damping: ${_dampingSliderValue.toStringAsFixed(1)}',
                                    style: const TextStyle(fontWeight: FontWeight.w600))),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                //style: ButtonStyle(shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder())),
                                onTap: () {
                                  setState(() {
                                    _dampingSliderValue = 1;
                                  });
                                  _controller.reset();
                                },
                                child: const Icon(Icons.refresh_rounded),
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _dampingSliderValue,
                          min: 0,
                          max: 1000,
                          label: _dampingSliderValue.toStringAsFixed(1),
                          onChanged: (double value) {
                            setState(() {
                              _dampingSliderValue = value;
                            });
                          },
                        ),
                        const SizedBox(height: 8.0),
                        Stack(
                          children: <Widget>[
                            Center(
                                child: Text('Initial Velocity: ${_initialVelocitySliderValue.toStringAsFixed(1)}',
                                    style: const TextStyle(fontWeight: FontWeight.w600))),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                //style: ButtonStyle(shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder())),
                                onTap: () {
                                  setState(() {
                                    _initialVelocitySliderValue = 0;
                                  });
                                  _controller.reset();
                                },
                                child: const Icon(Icons.refresh_rounded),
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _initialVelocitySliderValue,
                          min: 0,
                          max: 1000,
                          label: _initialVelocitySliderValue.toStringAsFixed(1),
                          onChanged: (double value) {
                            setState(() {
                              _initialVelocitySliderValue = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                if (!_controller.isAnimating) {
                  _animation2 = CurvedAnimation(
                      parent: _controller,
                      curve: Sprung.custom(
                        mass: _massSliderValue,
                        stiffness: _stiffnessSliderValue,
                        damping: _dampingSliderValue,
                        velocity: _initialVelocitySliderValue,
                      )).drive(AlignmentTween(begin: Alignment.centerLeft, end: Alignment.centerRight));
                  if (_controller.status == AnimationStatus.dismissed) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                  /*SpringDescription spring = SpringDescription(
                    mass: _massSliderValue,
                    stiffness: _stiffnessSliderValue,
                    damping: _dampingSliderValue,
                  );
                  final SpringSimulation simulation = SpringSimulation(
                      spring,
                      (_controller.value.roundToDouble() == 1.0) ? 1.0 : 0.0,
                      (_controller.value.roundToDouble() == 1.0) ? 0.0 : 1.0,
                      _initialVelocitySliderValue,
                      tolerance: Tolerance.defaultTolerance);
                  _controller.animateWith(simulation);*/
                }
              },
              child: AnimatedBuilder(
                //animation: _animation,
                animation: _animation2,
                builder: (BuildContext context, Widget? child) {
                  return Align(
                    //alignment: _animation.value,
                    alignment: _animation2.value,
                    child: Material(
                      elevation: 6.0,
                      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                      child: Container(
                        height: 96.0,
                        width: 96.0,
                        decoration: ShapeDecoration(
                          color: Colors.deepOrangeAccent.shade400,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return ElevatedButton.icon(
                    style: ButtonStyle(shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder())),
                    onPressed:
                        (_controller.value.toStringAsFixed(2) != '1.00' && _controller.value.toStringAsFixed(2) != '0.00')
                            ? () {
                                _controller.reset();
                              }
                            : null,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Reset Animation'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
