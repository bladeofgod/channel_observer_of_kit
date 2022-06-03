import 'package:channel_observer_of_kit/channel_observer_of_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'test_channel.dart';
import 'package:flutter_ume_kit_console/flutter_ume_kit_console.dart';
import 'package:flutter_ume_kit_device/flutter_ume_kit_device.dart';
import 'package:flutter_ume_kit_perf/flutter_ume_kit_perf.dart';
import 'package:flutter_ume_kit_show_code/flutter_ume_kit_show_code.dart';
import 'package:flutter_ume_kit_ui/flutter_ume_kit_ui.dart';


void main() {
  //runApp(const MyApp());
  //ChannelObserverOfKit.runApp(const MyApp());
  if(!kReleaseMode) {
    PluginManager.instance                                 // 注册插件
      ..register(WidgetInfoInspector())
      ..register(WidgetDetailInspector())
      ..register(ColorSucker())
      ..register(AlignRuler())
      ..register(ColorPicker())                            // 新插件
      ..register(TouchIndicator())                         // 新插件
      ..register(Performance())
      ..register(ShowCode())
      ..register(MemoryInfoPage())
      ..register(CpuInfoPage())
      ..register(DeviceInfoPanel())
      ..register(ChannelObserverWidget())
      ..register(Console());
    // flutter_ume 0.3.0 版本之后
    ChannelObserverOfKit.customZone(UMEWidget(child: MyApp(), enable: true));
  } else {
    runApp(const MyApp());
  }

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
