
import 'package:channel_observer_of_kit/channel_observer_of_kit.dart';
import 'package:clock/src/clock.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  const OptionalMethodChannel channel = OptionalMethodChannel('channel_observer_of_kit');

  ChannelObserverBinding.ensureInitialized() as ChannelObserverBinding;

  channel.invokeMethod('getPlatformVersion');

  test('testCustomChannelBinding', () async {
    expect(ChannelObserverOfKit.getBindingInstance()?.popChannelRecorders().length
        , inInclusiveRange(1, 20));
  });

}
