import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dnd.dart';
import 'cthulhu.dart';
import 'dart:math';

void main() => runApp(const App());

String game = '';

final rng = Random();

int get d6 => rng.nextInt(6) + 1;

extension RNG<T> on List<T> {
  T get random => this[rng.nextInt(length)];
}

extension ContextStuff on BuildContext {
  NavigatorState get _nav => Navigator.of(this);
  void push(Widget widget) => _nav.push(MaterialPageRoute(builder: (_) => widget));
  void goto(String routeName) {
    game = routeName;
    _nav.pushReplacementNamed(routeName);
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const _LaunchScreen(),
      routes: {
        'D&D': (context) => const DnDHome(),
        'CoC': (context) => const CthulhuHome(),
      },
    );
  }
}

class _LaunchScreen extends StatelessWidget {
  const _LaunchScreen();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final direction = size.width > size.height ? Axis.horizontal : Axis.vertical;
    final buttonSize = .75 *
        switch (direction) {
          Axis.horizontal => min(size.width / 2, size.height),
          Axis.vertical => min(size.width, size.height / 2),
        };
    return Scaffold(
      body: Center(
        child: Flex(
          direction: direction,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _LaunchButton.dnd(buttonSize),
            _LaunchButton.coc(buttonSize),
          ],
        ),
      ),
      floatingActionButton: TextButton(
        onPressed: () =>
            launchUrl(Uri.parse('https://github.com/nate-thegrate/character_quickgen')),
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xffddf4ff),
          foregroundColor: const Color(0xff0969da),
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        ),
        child: const Text('source on GitHub'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _LaunchButton extends StatelessWidget {
  const _LaunchButton.dnd(this.size) : dnd = true;
  const _LaunchButton.coc(this.size) : dnd = false;
  final bool dnd;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: dnd
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[900],
                foregroundColor: Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size / 8)),
              ),
              onPressed: () => context.goto('D&D'),
              child: Image.asset('assets/dnd.png'),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[900],
                foregroundColor: Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size / 8)),
              ),
              onPressed: () => context.goto('CoC'),
              child: Image.asset('assets/coc.png'),
            ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.controller, required this.animation});
  final AnimationController controller;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                DrawerHeader(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => controller
                          ..reset()
                          ..forward(),
                        child: RotationTransition(
                          turns: animation,
                          child: const Icon(Icons.casino, size: 75),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          margin: const EdgeInsets.only(bottom: 15),
                          child: const Text('Quick & Easy Character Generation'),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text('D&D 5th Edition'),
                  onTap: () => context.goto('D&D'),
                ),
                ListTile(
                  title: const Text('Call of Cthulhu 7th Edition'),
                  onTap: () => context.goto('CoC'),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 180,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 10),
                      child: const Text('Made using Flutter'),
                    ),
                    const FlutterLogo(),
                  ],
                ),
                Container(height: 10),
                const Text('Thanks to the people of /r/3d6 for some awesome character ideas!'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({super.key, this.appBar, this.drawer, this.body});
  final PreferredSizeWidget? appBar;
  final Widget? drawer, body;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: switch (game) {
        'D&D' => ThemeData(
            iconTheme: const IconThemeData(color: Colors.red),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.red,
              // primary: Colors.red,
              // onPrimary: Colors.red,
              // primaryContainer: Colors.red,
              // onPrimaryContainer: Colors.red,
              // secondary: Colors.grey,
              // onSecondary: Colors.red,
              // secondaryContainer: Colors.red,
              // onSecondaryContainer: Colors.red,
              // tertiary: Colors.red,
              // onTertiary: Colors.red,
              // tertiaryContainer: Colors.red,
              // onTertiaryContainer: Colors.red,
              // error: Colors.red,
              // onError: Colors.red,
              // errorContainer: Colors.red,
              // onErrorContainer: Colors.red,
              // outline: Colors.red,
              // outlineVariant: Colors.red,
              // background: Colors.red,
              // onBackground: Colors.red,
              // surface: Colors.red,
              // onSurface: Colors.red,
              // surfaceVariant: Colors.red,
              // onSurfaceVariant: Colors.red,
              // inverseSurface: Colors.red,
              // onInverseSurface: Colors.red,
              // inversePrimary: Colors.red,
              // shadow: Colors.red,
              // scrim: Colors.red,
              // surfaceTint: Colors.red,
              surface: Colors.grey[900],
            ),
            appBarTheme: const AppBarTheme(foregroundColor: Colors.white),
          ),
        _ => ThemeData(
            iconTheme: const IconThemeData(color: Colors.purple),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.purple[900]!,
              brightness: Brightness.light,
              primary: Colors.purple[900]!,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[900],
                foregroundColor: Colors.yellow[200],
                padding: const EdgeInsets.fromLTRB(24, 9, 24, 11),
              ),
            ),
          ),
      },
      child: Scaffold(appBar: appBar, drawer: drawer, body: body),
    );
  }
}

class DataList extends StatelessWidget {
  const DataList({super.key, required this.left, required this.right, this.subtitle = ''});
  final String left;
  final dynamic right;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double totalWidth = min(screenWidth, 250 + screenWidth / 2);

    final List<Widget> items = [
      if (right is String)
        Text(right)
      else
        for (final s in right)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Text(s),
          ),
      if (subtitle != '')
        Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
    ];
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Container(
              width: totalWidth / 4,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerRight,
              child: Text(
                left,
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: totalWidth * 3 / 4,
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
