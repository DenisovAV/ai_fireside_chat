// chat.ts
import {SessionStore, SessionData, GenkitBeta} from "genkit/beta";
import {claude35Haiku} from "genkitx-anthropic";
import {metaLlama38bInstruct} from "genkitx-github";
import {promises as fs} from "fs";
import {unlink} from "fs/promises";

type ModelType = "claude" | "llama";


const modelMap: Record<ModelType, any> = {
  claude: claude35Haiku,
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

  session.chat({
    model: modelMap[modelType],
    system: systemInstructions,
    config: {
      maxOutputTokens: maxTokens ?? 256,
      temperature: temperature ?? 0.7,
      stopSequences: stopSequences ?? [],
    },
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

  const chatInstance = session.chat({
    model: modelMap[modelType],
    system: systemInstructions,
    config: {
      maxOutputTokens: maxTokens ?? 256,
      temperature: temperature ?? 0.7,
      stopSequences: stopSequences ?? [],
    },
  });

  let responseText = "";
  for (const msg of messages) {
    const {text} = await chatInstance.send(msg);
    responseText += text + "\n";
  }

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
