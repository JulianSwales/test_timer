import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'riverpod/booking_riverpod.dart';
import 'riverpod/timer_riverpod.dart';

void main() {
  runApp(ProviderScope(observers: [Logger()] ,child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text('Test Timer')),
      body: Column(
        children: [
          Text('View Data'),
          Row(
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      ref.read(bookingOn.notifier).state = !ref.read(bookingOn);
                    },
                    icon: ref.watch(bookingOn)
                        ? Icon(Icons.remove)
                        : Icon(Icons.add),
                  ),
                  ref.read(bookingOn)
                      ? Text('Stop Booking')
                      : Text('Start Booking'),
                ],
              )
            ],
          ),
          Row(
            children: [
              Column(
                children: [
                  IconButton(
                      tooltip: ref.watch(screenTypeProvider) == ScreenType.edit
                          ? 'Update Booking'
                          : ref.watch(screenTypeProvider) == ScreenType.add ||
                                  ref.watch(screenTypeProvider) ==
                                      ScreenType.tableAdd
                              ? 'Add Booking'
                              : 'Edit Booking',
                      icon: ref.watch(screenTypeProvider) == ScreenType.view
                          ? Icon(Icons.edit)
                          : Icon(Icons.save),
                      onPressed: () {
                        if (ref.watch(screenTypeProvider) == ScreenType.view) {
                          ref.read(screenTypeProvider.notifier).state =
                              ScreenType.edit;
                        } else {}
                      }),
                  ref.watch(screenTypeProvider) == ScreenType.edit
                      ? Text('Update')
                      : ref.watch(screenTypeProvider) == ScreenType.add ||
                              ref.watch(screenTypeProvider) ==
                                  ScreenType.tableAdd
                          ? Text('Book')
                          : Text('Edit'),
                ],
              ),
              ref.watch(bookingGood) &&
                      ref.watch(screenTypeProvider) != ScreenType.view
                  ? Column(
                      children: [
                        Text('Booking'),
                        Text('Time Remaining'),
                        TimerTextWidget(),
                      ],
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    ));
  }
}

class TimerTextWidget extends ConsumerWidget {
  const TimerTextWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeLeft = ref.watch(timeLeftProvider);
    return Text(timeLeft);
  }
}

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    //provider.
    print('''{
      "provider": "${provider.name ?? provider.runtimeType}", 
      "previousValue": "$previousValue",
      "newValue": "$newValue",
      "container": "${container.toString()}",
      }''');
  }
}
