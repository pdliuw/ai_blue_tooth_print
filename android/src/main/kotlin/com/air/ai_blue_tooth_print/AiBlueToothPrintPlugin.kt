package com.air.ai_blue_tooth_print

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull;
import com.air.ai_blue_tooth_print.zebra.PrinterSettingActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** AiBlueToothPrintPlugin */
public class AiBlueToothPrintPlugin : FlutterPlugin, Activity(), MethodCallHandler {

    lateinit var context: Context;

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "ai_blue_tooth_print")

        var plugin = AiBlueToothPrintPlugin()
        plugin.setContextCallback(flutterPluginBinding.applicationContext)
        channel.setMethodCallHandler(plugin)
    }

    /**
     * setContextCallback
     */
    fun setContextCallback(flutterPluginBinding: Context) {
        this.context = flutterPluginBinding;
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "ai_blue_tooth_print")
            var plugin = AiBlueToothPrintPlugin();
            plugin.setContextCallback(registrar.activity());
            channel.setMethodCallHandler(plugin)
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "search") {

        } else if (call.method == "print") {
            val arrayList: ArrayList<String> = call.argument("info")!!;
            showPrintView(arrayList);
        } else if (call.method == "printZebra") {
            val arrayListZebra: ArrayList<String> = call.argument("info")!!;
            showPrintZebraView(arrayListZebra);
        } else {
            result.notImplemented()
        }
    }

    private fun showPrintView(printInfoList: ArrayList<String>) {
        val bundle: Bundle = Bundle();
        bundle.putStringArrayList(SearchPrintActivity.INFOLIST, printInfoList);
        bundle.putBoolean(SearchPrintActivity.ISPRINT, true)


        val intent = Intent(context, SearchPrintActivity::class.java)

        intent.putExtras(bundle);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent);
    }

    private fun showPrintZebraView(printInfoList: ArrayList<String>) {
        val bundle: Bundle = Bundle();
        bundle.putStringArrayList(PrinterSettingActivity.BUNDLE_KEY_PRINT_INFO_LIST, printInfoList);

        val intent = Intent(context, PrinterSettingActivity::class.java)

        intent.putExtras(bundle);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent);
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }
}
