package com.lijiaqi.channel_observer_of_kit_example;

import androidx.annotation.NonNull;

import org.jetbrains.annotations.NotNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * @author LiJiaqi
 * @date 2022/5/2
 * Description:
 */
public class TestChannelPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler {

    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull @NotNull FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getBinaryMessenger(), "test_channel");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull @NotNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onMethodCall(@NonNull @NotNull MethodCall call, @NonNull @NotNull MethodChannel.Result result) {
        if(call.method.equals("test_int")) {
            result.success(1);
        } else if(call.method.equals("test_null")) {
            result.success(null);
        }
    }
}
