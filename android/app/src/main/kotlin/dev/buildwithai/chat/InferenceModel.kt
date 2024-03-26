package dev.buildwithai.chat

import android.content.Context
import com.google.mediapipe.tasks.genai.llminference.LlmInference
import java.io.File

class InferenceModel private constructor(context: Context) {
    private var llmInference: LlmInference

    private val modelExists: Boolean
        get() = File(MODEL_PATH).exists()

    init {
        if (!modelExists) {
            throw IllegalArgumentException("Model not found at path: $MODEL_PATH")
        }

        val options = LlmInference.LlmInferenceOptions.builder()
            .setModelPath(MODEL_PATH)
            .setMaxTokens(1024)
            .build()

        llmInference = LlmInference.createFromOptions(context, options)
    }

    fun generateResponseAsync(prompt: String): String? {
        return llmInference.generateResponse(prompt)
    }

    companion object {
        private const val MODEL_PATH = "/data/local/tmp/llm/model.bin"
        private var instance: InferenceModel? = null

        fun getInstance(context: Context): InferenceModel {
            return if (instance != null) {
                instance!!
            } else {
                InferenceModel(context).also { instance = it }
            }
        }
    }
}
