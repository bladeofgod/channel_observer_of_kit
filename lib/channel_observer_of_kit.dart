
import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'model/package_model.dart';
import 'model/warehouse.dart';

class ChannelObserverOfKit {
  static runApp(Widget app) {
    ChannelObserverBinding.ensureInitialized()
      // ignore: invalid_use_of_protected_member
      ..scheduleAttachRootWidget(app)
      ..scheduleWarmUpFrame();
  }

  static ChannelObserverBinding? getBindingInstance() {
    if(WidgetsBinding.instance is ChannelObserverBinding) {
      return (WidgetsBinding.instance as ChannelObserverBinding);
    }
    return null;
  }

}


class ChannelObserverBinding extends WidgetsFlutterBinding with ChannelObserverServicesBinding{
  static WidgetsBinding ensureInitialized() {
    if(WidgetsBinding.instance == null) {
      ChannelObserverBinding();
    }
    return WidgetsBinding.instance!;
  }
}


///channel表的记录最大长度
const int recorderSize = int.fromEnvironment('recorderSize', defaultValue: 10);

IStorage<ChannelModel> channelRecorder = CommonStorage(maxCount: recorderSize);

mixin ChannelObserverServicesBinding on BindingBase, ServicesBinding{

  late RikiBinaryMessengerProxy _proxy;

  ///弹出队列所有记录
  /// 顺序： [远...近]
  List<ChannelModel> popChannelRecorders() => _proxy.allRecorders;

  @override
  BinaryMessenger createBinaryMessenger() {
    _proxy = RikiBinaryMessengerProxy(super.createBinaryMessenger());
    return _proxy;
  }
}


class RikiBinaryMessengerProxy extends BinaryMessenger{

  RikiBinaryMessengerProxy(this.origin);

  final BinaryMessenger origin;

  final MethodCodec codec = const StandardMethodCodec();

  IStorage<ChannelModel> get recorder => channelRecorder;

  List<ChannelModel> get allRecorders => recorder.getAll();

  ChannelModel _recordChannel(String name, ByteData? data, bool send) {
    ChannelModel model;
    try{
      final MethodCall call = codec.decodeMethodCall(data);
      model = ChannelModel(channelName: name,
          methodName: call.method,
          arguments: call.arguments,
          type: send ? ChannelModel.TYPE_DEV_SEND : ChannelModel.TYPE_DEV_RECEIVE);
    }catch (e) {
      model = ChannelModel.error(channelName: name);
    }
    model.methodCodec = codec;
    recorder.save(model);
    return model;
  }


  void resolveResult(ChannelModel model, ByteData? result) {
    try {
      if (model.methodCodec != null) {
        model.results = model.methodCodec?.decodeEnvelope(result ?? ByteData(1));
        model.receiveTimestamp = DateTime.now().millisecondsSinceEpoch;
      } else {
        model.receiveTimestamp = DateTime.now().millisecondsSinceEpoch;
      }
    } catch (e) {
      debugPrint('Channel resolve exception : ${e.toString()}');
    }
    model.methodCodec = null;
  }


  @override
  Future<void> handlePlatformMessage(String channel, ByteData? data, PlatformMessageResponseCallback? callback) {
    return origin.handlePlatformMessage(channel, data, callback);
  }

  @override
  Future<ByteData?>? send(String channel, ByteData? message) async {
    final ChannelModel model = _recordChannel(channel, message, true);
    if(model.isAbnormal) {
      return origin.send(channel, message);
    }
    final ByteData? result = await origin.send(channel, message);
    resolveResult(model, result);
    return result;
  }

  @override
  void setMessageHandler(String channel, MessageHandler? handler) {
    origin.setMessageHandler(channel, handler);
  }

}
