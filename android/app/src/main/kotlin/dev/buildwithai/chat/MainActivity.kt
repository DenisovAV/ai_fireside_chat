package dev.buildwithai.chat

import androidx.annotation.NonNull
import dev.buildwithai.chat.InferenceModel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
            super.configureFlutterEngine(flutterEngine)

            val inferenceModel = InferenceModel.getInstance(context)

            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "GEMMA").setMethodCallHandler {
                    call, result ->
                if (call.method == "GEMMA_ANSWER") {
                    val prompt = call.argument<String>("input")!!
                    val answer = inferenceModel.generateResponseAsync(prompt)
                    result.success(answer)
                } else {
                    result.notImplemented()
                }
            }
        }

}
