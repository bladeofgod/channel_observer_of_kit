

import 'package:channel_observer_of_kit/model/package_model.dart';
import 'package:flutter/material.dart';

import '../channel_observer_of_kit.dart';

class ChannelObserverWidget extends StatefulWidget{
  const ChannelObserverWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChannelObserverWidgetState();
  }

}

class ChannelObserverWidgetState extends State<ChannelObserverWidget> {

  final List<ChannelModel> _cacheBucket = [];

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
              await Navigator.push(context, MaterialPageRoute(builder: (_) => RecentChannelRecordPage(records: tem,)));
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
















