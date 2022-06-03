

import 'package:channel_observer_of_kit/model/package_model.dart';
import 'package:flutter/material.dart';

import '../channel_observer_of_kit.dart';
import 'package:flutter_ume/flutter_ume.dart';

///悬浮按钮
/// * 内部监听[ChannelObserverOfKit.errorStream]，并做状态且换。
/// * 在有错误告警的情况下，点击会进去[RecentChannelRecordPage]页面
/// * 展示最近的channel 通信记录。
///
/// * 此功能需基于[ChannelObserverOfKit.customZone(rootWidget)]的接入。
/// * 如果需要自定义，可以参照此类的使用方式进行重定义
class ChannelObserverWidget extends StatefulWidget implements Pluggable{

  ChannelObserverWidget({Key? key}) : super(key: key);

  OverlayEntry? entry;

  bool isOpen = false;

  BuildContext? ctx;

  @override
  State<StatefulWidget> createState() {
    return ChannelObserverWidgetState();
  }


  @override
  Widget buildWidget(BuildContext? context) {
    ctx = context;
    return SizedBox();
  }

  @override
  String get displayName => 'channel_observer';

  @override
  ImageProvider<Object> get iconImageProvider => AssetImage('assets/channel.png', package: 'channel_observer_of_kit');

  @override
  String get name => 'channel_observer';

  @override
  void onTrigger() {
    if(entry == null) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        entry = OverlayEntry(builder: (_) => ChannelObserverWidget());
        Overlay.of(ctx!)?.insert(entry!);
      });
    } else {
      entry?.remove();
      entry = null;
    }

  }

}

class ChannelObserverWidgetState extends State<ChannelObserverWidget> {

  final List<ChannelModel> _cacheBucket = [];

  OverlayEntry? entry;

  bool _showWarning = false;

  double btnLeft = 10;

  double btnTop = 200;

  void _dragUpdate(DragUpdateDetails details) {
    setState(() {
      btnLeft += details.delta.dx;
      btnTop += details.delta.dy;
    });
  }

  @override
  void initState() {
    super.initState();
    ChannelObserverOfKit.errorStream.listen((event) {
      setState(() {
        _showWarning = true;
      });
      _cacheBucket.addAll(ChannelObserverOfKit.getBindingInstance()?.popChannelRecorders() ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    const double btnWidth = 48;
    final Size size = MediaQuery.of(context).size;
    return Positioned(
      left: btnLeft.clamp(0, size.width-btnWidth),
      top: btnTop.clamp(0, size.height-btnWidth),
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () async {
            if(_showWarning && _cacheBucket.isNotEmpty) {
              List<ChannelModel> tem = List.from(_cacheBucket);
              setState(() {
                _showWarning = false;
                _cacheBucket.clear();
              });
              if(entry == null) {
                entry = OverlayEntry(builder: (_) => RecentChannelRecordPage(records: tem, popCallback: () {
                  entry?.remove();
                  entry = null;
                },));
                Overlay.of(context)?.insert(entry!);
              }
            }
          },
          onPanUpdate: _dragUpdate,
          child: Container(
            width: btnWidth, height: btnWidth,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue
            ),
            child: _showWarning ?
            const Icon(Icons.warning_rounded, color: Colors.red, size: 40,)
             : const Icon(Icons.wifi_protected_setup, color: Colors.white, size: 40,),
          ),
        ),
      ),
    );
  }
}
















