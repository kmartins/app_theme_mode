import 'package:app_theme_mode/app_theme_mode.dart';
import 'package:example/preferences_theme_mode_adapter.dart';
import 'package:example/theme_mode_adapter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    MyApp(
      themeModeAdapter: PreferencesThemeModeAdapter(sharedPreferences),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({required this.themeModeAdapter, super.key});

  final ThemeModeAdapter themeModeAdapter;

  @override
  Widget build(BuildContext context) {
    return AppThemeMode(
      initialThemeMode: themeModeAdapter.read(),
      onChangeThemeMode: (themeMode) => themeModeAdapter.write(themeMode),
      builder: (_, themeMode) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        themeMode: themeMode,
        darkTheme: ThemeData.dark(),
        theme: ThemeData.light(),
        home: const MyHomePage(
          title: 'Flutter Demo Home Page',
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.access_time_sharp),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const AppThemeModeDialog(),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Theme Mode:',
            ),
            const ShowThemeMode(),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ShowThemeMode extends StatelessWidget {
  const ShowThemeMode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Text(AppThemeMode.of(context).themeMode.name.toUpperCase());
}
