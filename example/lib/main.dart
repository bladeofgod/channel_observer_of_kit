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


  @override
  void initState() {
    super.initState();
    doTest();
    ChannelObserverOfKit.errorStream.listen((event) {
      debugPrint('类型错误，捡出调用队列');
      ChannelObserverOfKit.getBindingInstance()?.popChannelRecorders().forEach((element) {
        debugPrint(element.getPackage().toString());
      });
    });
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
          title: const Text('Plugin example app'),
        ),
        body: const Text('Plugin example app'),
      ),
    );
  }
}
