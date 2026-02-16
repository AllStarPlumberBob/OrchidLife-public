package com.orchidlife.orchidlife

import android.content.Intent
import android.net.Uri
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.orchidlife.orchidlife/share"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "shareImageToPackage") {
                    val filePath = call.argument<String>("filePath")
                    val mimeType = call.argument<String>("mimeType") ?: "image/*"
                    val text = call.argument<String>("text") ?: ""
                    val packageName = call.argument<String>("packageName")

                    if (filePath == null || packageName == null) {
                        result.error("INVALID_ARGS", "filePath and packageName are required", null)
                        return@setMethodCallHandler
                    }

                    try {
                        val file = File(filePath)
                        val contentUri: Uri = FileProvider.getUriForFile(
                            this,
                            "${applicationInfo.packageName}.fileprovider",
                            file
                        )

                        val intent = Intent(Intent.ACTION_SEND).apply {
                            type = mimeType
                            putExtra(Intent.EXTRA_STREAM, contentUri)
                            if (text.isNotEmpty()) {
                                putExtra(Intent.EXTRA_TEXT, text)
                            }
                            setPackage(packageName)
                            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        }

                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}
