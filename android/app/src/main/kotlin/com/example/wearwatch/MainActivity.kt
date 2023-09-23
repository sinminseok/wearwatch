package com.example.wearwatch

import android.Manifest
import android.content.pm.PackageManager
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Build
import android.os.Bundle
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.heart_rate_sensor"
    private val SENSOR_PERMISSION_CODE = 101 // 임의로 선택한 권한 요청 코드
    private var flutterResult: MethodChannel.Result? = null // 추가: 결과를 보관할 변수
    private var sensorManager: SensorManager? = null
    private var heartRateSensor: Sensor? = null
    private var sensorEventListener: SensorEventListener? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        sensorManager = getSystemService(SENSOR_SERVICE) as SensorManager
        heartRateSensor = sensorManager?.getDefaultSensor(Sensor.TYPE_HEART_RATE)

        // Flutter와 통신할 MethodChannel 설정
        val channel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)

        channel.setMethodCallHandler { call, result ->
            if (call.method == "getHeartRate") {
                requestSensorPermission()
                // 결과를 보관하는 flutterResult 변수 초기화
                flutterResult = result
            } else {
                result.notImplemented()
            }
        }
    }

    private fun requestSensorPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (ContextCompat.checkSelfPermission(
                    this,
                    Manifest.permission.BODY_SENSORS
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                ActivityCompat.requestPermissions(
                    this,
                    arrayOf(Manifest.permission.BODY_SENSORS),
                    SENSOR_PERMISSION_CODE
                )
            } else {
                registerHeartRateListener()
            }
        }
    }

    private fun registerHeartRateListener() {
        if (heartRateSensor != null) {
            sensorEventListener = object : SensorEventListener {
                override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
                    // 센서 정확도 변경 처리 (필요한 경우)
                }

                override fun onSensorChanged(event: SensorEvent?) {
                    if (event?.sensor?.type == Sensor.TYPE_HEART_RATE && event.values.isNotEmpty()) {
                        val heartRateValue = event.values[0]
                        // Flutter로 심박수 데이터 전송
                        // 확인을 위한 로그

                        sendHeartRateToFlutter(heartRateValue)
                    }
                }
            }
            sensorManager?.registerListener(
                sensorEventListener,
                heartRateSensor,
                SensorManager.SENSOR_DELAY_NORMAL
            )
        }
    }

    private fun sendHeartRateToFlutter(heartRateValue: Float) {
        val channel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
        Log.d("HeartRateSensor", "Sending heart rate value: $heartRateValue")

        // flutterResult 변수가 null이 아닌 경우에만 응답을 보냅니다.
        flutterResult?.success(heartRateValue)

        // 응답을 보낸 후에 flutterResult 변수를 null로 초기화합니다.
        flutterResult = null
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == SENSOR_PERMISSION_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // 사용자가 권한을 승인한 경우 센서 리스너를 등록합니다.
                registerHeartRateListener()
            } else {
                // 사용자가 권한을 거부한 경우에 대한 처리를 여기에 추가하세요.
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        // 액티비티가 종료될 때 센서 리스너를 해제합니다.
        sensorEventListener?.let {
            sensorManager?.unregisterListener(it)
        }
    }
}