import 'package:channel_observer_of_kit/channel_observer_of_kit.dart';
import 'package:flutter/material.dart';

import 'test_channel.dart';

void main() {
  //runApp(const MyApp());
  ChannelObserverOfKit.runApp(const MyApp());
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
  }

  void doTest() async {
    try{
      await TestChannel.testInt;
      await TestChannel.testNull;
    }catch (e) {
      ChannelObserverOfKit.getBindingInstance()?.popChannelRecorders().forEach((element) {
        debugPrint(element.getPackage().toString());
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Center(
          child: Text('Running on: \n'),
        ),
      ),
    );
  }
}
