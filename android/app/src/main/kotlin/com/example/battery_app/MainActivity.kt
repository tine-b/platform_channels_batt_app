package tine.dev.battery_app

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES

class MainActivity: FlutterActivity() {
  private val CHANNEL = "tine.dev/battery"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
        // This method is invoked on the main thread.
        call, result ->
        if (call.method == "getBatteryDetails") {
          val batteryDetails = getBatteryDetails()
  
          if (batteryDetails.size > 0) {
            result.success(batteryDetails)
          } else {
            result.error("UNAVAILABLE", "Battery status unavailable", null)
          }
        } else {
          result.notImplemented()
        }
      }
  }

  private fun getBatteryDetails(): HashMap<String, Any?> {
    
    val resultData: HashMap<String, Any?> = HashMap<String, Any?>()
    val batteryLevel: Int
    val batteryState: String 

    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
      val state = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_STATUS);

      when(state){
        BatteryManager.BATTERY_STATUS_UNKNOWN -> batteryState = "Your battery status is unknown"
        BatteryManager.BATTERY_STATUS_CHARGING -> batteryState = "Your phone is charging"
        BatteryManager.BATTERY_STATUS_DISCHARGING -> batteryState = "Your phone is unplugged"
        BatteryManager.BATTERY_STATUS_NOT_CHARGING -> batteryState = "Your phone is not charging"
        BatteryManager.BATTERY_STATUS_FULL -> batteryState = "Your phone is fully-charged"
        else -> batteryState = "Battery status unavailable"
      }

      resultData.put("level", batteryLevel)  
      resultData.put("status", batteryState)    
    } else {
      val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
      batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
      val state = intent!!.getIntExtra(BatteryManager.EXTRA_STATUS, -1);
      when(state){
        BatteryManager.BATTERY_STATUS_UNKNOWN -> batteryState = "Your battery status is unknown"
        BatteryManager.BATTERY_STATUS_CHARGING -> batteryState = "Your phone is charging"
        BatteryManager.BATTERY_STATUS_DISCHARGING -> batteryState = "Your phone is unplugged"
        BatteryManager.BATTERY_STATUS_NOT_CHARGING -> batteryState = "Your phone is not charging"
        BatteryManager.BATTERY_STATUS_FULL -> batteryState = "Your phone is fully-charged"
        else -> batteryState = "Battery status unavailable"
      }

      resultData.put("level", batteryLevel)  
      resultData.put("status", batteryState) 
    }
    return resultData
  }

}