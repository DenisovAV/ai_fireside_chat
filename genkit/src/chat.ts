// chat.ts - dual AI system for streaming
import {SessionStore, SessionData, GenkitBeta} from "genkit/beta";
import {metaLlama38bInstruct, mistralSmall} from "genkitx-github";
import {gemini15Flash, gemini15Pro} from "@genkit-ai/googleai";
import {promises as fs} from "fs";
import {unlink} from "fs/promises";

type ModelType = "deepseek" | "llama";

// GitHub Models (for regular requests)
const githubModelMap: Record<ModelType, any> = {
  deepseek: mistralSmall,
  llama: metaLlama38bInstruct,
};

// Google AI Models (for streaming)
const googleModelMap: Record<ModelType, any> = {
  deepseek: gemini15Flash,
  llama: gemini15Pro,
};

export class JsonSessionStore<S = any> implements SessionStore<S> {
  async get(sessionId: string): Promise<SessionData<S> | undefined> {
    try {
      const s = await fs.readFile(`sessions/${sessionId}.json`, "utf8");
      return JSON.parse(s);
    } catch {
      return undefined;
    }
  }

  async save(sessionId: string, sessionData: SessionData<S>): Promise<void> {
    await fs.mkdir("sessions", {recursive: true});
    const s = JSON.stringify(sessionData);
    await fs.writeFile(`sessions/${sessionId}.json`, s, "utf8");
  }
}

export async function createChatSession(
  ai: GenkitBeta,
  modelType: ModelType,
  systemInstructions: string,
  maxTokens?: number,
  temperature?: number,
  stopSequences?: string[],
  streaming?: boolean,
): Promise<string> {
  try {
    console.log(`Creating chat session for model: ${modelType}, streaming: ${streaming}`);
    const store = new JsonSessionStore();
    const session = ai.createSession({store});

    // Choose model map based on streaming preference  
    const modelMap = streaming ? googleModelMap : githubModelMap;
    const modelRef = modelMap[modelType];

    const modelConfig: any = {
      maxOutputTokens: maxTokens ?? 256,
      temperature: temperature ?? 0.7,
      stopSequences: stopSequences ?? [],
    };

    // Override model names for GitHub Models API compatibility (only for GitHub models)
    if (!streaming) {
      if (modelType === "llama") {
        modelConfig.version = "Meta-Llama-3.1-8B-Instruct";
      } else if (modelType === "deepseek") {
        modelConfig.version = "Mistral-Small";
      }
    }

    console.log(`Model config:`, modelConfig);
    console.log(`Model reference:`, modelRef);

    session.chat({
      model: modelRef,
      system: systemInstructions,
      config: modelConfig,
    });

    console.log(`Session created with ID: ${session.id}`);
    return session.id;
  } catch (error) {
    console.error(`Error creating session:`, error);
    throw new Error(`Failed to create chat session: ${error}`);
  }
}

export async function sendMessagesToSession(
  ai: GenkitBeta,
  modelType: ModelType,
  sessionId: string,
  messages: string[],
  systemInstructions: string,
  maxTokens?: number,
  temperature?: number,
  stopSequences?: string[],
  sendChunk?: (chunk: string) => void,
  streaming?: boolean,
): Promise<string> {
  try {
    console.log(`Loading session: ${sessionId} for model: ${modelType}, streaming: ${streaming}`);
    const store = new JsonSessionStore();
    const session = await ai.loadSession(sessionId, {store});

    // Choose model map based on streaming preference  
    const modelMap = streaming ? googleModelMap : githubModelMap;
    const modelRef = modelMap[modelType];

    const modelConfig: any = {
      maxOutputTokens: maxTokens ?? 256,
      temperature: temperature ?? 0.7,
      stopSequences: stopSequences ?? [],
    };

    // Override model names for GitHub Models API compatibility (only for GitHub models)
    if (!streaming) {
      if (modelType === "llama") {
        modelConfig.version = "Meta-Llama-3.1-8B-Instruct";
      } else if (modelType === "deepseek") {
        modelConfig.version = "Mistral-Small";
      }
    }

    console.log(`Creating chat instance with model:`, modelRef);
    const chatInstance = session.chat({
      model: modelRef,
      system: systemInstructions,
      config: modelConfig,
    });

    let responseText = "";
    for (const msg of messages) {
      console.log(`Sending message: ${msg}`);
      
      if (sendChunk) {
        // Streaming mode
        console.log(`Using streaming mode`);
        const streamResult = await chatInstance.sendStream(msg);
        for await (const chunk of streamResult.stream) {
          if (chunk.text) {
            console.log(`Chunk: "${chunk.text}"`);
            sendChunk(chunk.text);
            responseText += chunk.text;
          }
        }
        // Get final response
        const finalResult = await streamResult.response;
        const finalText = finalResult.text || "";
        if (finalText && !responseText.includes(finalText)) {
          responseText += finalText;
        }
      } else {
        // Non-streaming mode
        console.log(`Using non-streaming mode`);
        const response = await chatInstance.send(msg);
        console.log(`Response received:`, response);
        const text = response.text || "";
        console.log(`Text extracted: "${text}"`);
        responseText += text + "\n";
      }
    }

    console.log(`Final response: "${responseText.trim()}"`);
    return responseText.trim();
  } catch (error) {
    console.error(`Error in sendMessagesToSession:`, error);
    throw new Error(`Failed to send messages: ${error}`);
  }
}

export async function deleteSession(sessionId: string): Promise<void> {
  try {
    await unlink(`sessions/${sessionId}.json`);
    console.log(`Session ${sessionId} deleted`);
  } catch (err) {
    console.error(`Error delete session ${sessionId}:`, err);
  }
}
