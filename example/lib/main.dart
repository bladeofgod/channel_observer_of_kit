import 'package:channel_observer_of_kit/channel_observer_of_kit.dart';
import 'package:flutter/material.dart';

import 'test_channel.dart';

void main() {
  //runApp(const MyApp());
  //ChannelObserverOfKit.runApp(const MyApp());
  ChannelObserverOfKit.customZone(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool hasInsert = false;

  @override
  void initState() {
    super.initState();
  }

  void doTest() async {
    await Future.delayed(const Duration(seconds: 2));
    await TestChannel.testInt;
    //await TestChannel.testNull;w

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('channel observer of kit'),
        ),
        body: Builder(
          builder: (BuildContext context) {
            if(!hasInsert) {
              hasInsert = true;
              WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                OverlayEntry entry = OverlayEntry(builder: (_) => const ChannelObserverWidget());
                Overlay.of(context)?.insert(entry);

              });
            }
            return Center(
              child: ElevatedButton(onPressed: () {
                doTest();
              }, child: const Text('测试')),
            );
          },),
      ),
    );
  }
}
