// chat.ts - model names fixed
import {SessionStore, SessionData, GenkitBeta} from "genkit/beta";
import {metaLlama38bInstruct, mistralSmall} from "genkitx-github";
import {promises as fs} from "fs";
import {unlink} from "fs/promises";

type ModelType = "deepseek" | "llama";


const modelMap: Record<ModelType, any> = {
  deepseek: mistralSmall,
  llama: metaLlama38bInstruct,
};

class JsonSessionStore<S = any> implements SessionStore<S> {
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
): Promise<string> {
  const store = new JsonSessionStore();
  const session = ai.createSession({store});

  const modelConfig: any = {
    maxOutputTokens: maxTokens ?? 256,
    temperature: temperature ?? 0.7,
    stopSequences: stopSequences ?? [],
  };

  // Override model names for GitHub Models API compatibility
  if (modelType === "llama") {
    modelConfig.version = "Meta-Llama-3.1-8B-Instruct";
  } else if (modelType === "deepseek") {
    modelConfig.version = "Mistral-Small";
  }

  session.chat({
    model: modelMap[modelType],
    system: systemInstructions,
    config: modelConfig,
  });

  return session.id;
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
): Promise<string> {
  const store = new JsonSessionStore();
  const session = await ai.loadSession(sessionId, {store});

  const modelConfig: any = {
    maxOutputTokens: maxTokens ?? 256,
    temperature: temperature ?? 0.7,
    stopSequences: stopSequences ?? [],
  };

  // Override model names for GitHub Models API compatibility
  if (modelType === "llama") {
    modelConfig.version = "Meta-Llama-3.1-8B-Instruct";
  } else if (modelType === "deepseek") {
    modelConfig.version = "Mistral-Small";
  }

  const chatInstance = session.chat({
    model: modelMap[modelType],
    system: systemInstructions,
    config: modelConfig,
  });

  let responseText = "";
  for (const msg of messages) {
    console.log(`Sending message: ${msg}`);
    const response = await chatInstance.send(msg);
    console.log(`Response received:`, response);
    const text = response.text || "";
    console.log(`Text extracted: "${text}"`);
    responseText += text + "\n";
  }

  console.log(`Final response: "${responseText.trim()}"`);
  return responseText.trim();
}

export async function deleteSession(sessionId: string): Promise<void> {
  try {
    await unlink(`sessions/${sessionId}.json`);
    console.log(`Session ${sessionId} deleted`);
  } catch (err) {
    console.error(`Error delete session ${sessionId}:`, err);
  }
}
