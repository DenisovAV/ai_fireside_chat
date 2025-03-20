import {genkit, z} from "genkit/beta";
import {anthropic} from "genkitx-anthropic";
import {github} from "genkitx-github";
import {createChatSession, sendMessagesToSession, deleteSession} from "./chat";

const ai = genkit({
  plugins: [
    anthropic(),
    github(),
  ],
});

export const initChatFlow = ai.defineFlow(
  {
    name: "initChatSession",
    inputSchema: z.object({
      modelType: z.enum(["claude", "llama"]),
      systemInstructions: z.string().default("You are friendly and helpful."),
      maxTokens: z.number().optional(),
      temperature: z.number().optional(),
      stopSequences: z.array(z.string()).optional(),
    }),
    outputSchema: z.object({
      sessionId: z.string(),
    }),
  },
  async ({modelType, systemInstructions, maxTokens, temperature, stopSequences}) => {
    const sessionId = await createChatSession(ai, modelType, systemInstructions, maxTokens, temperature, stopSequences);
    return {sessionId};
  }
);

export const sendMessagesFlow = ai.defineFlow(
  {
    name: "sendMessagesToChat",
    inputSchema: z.object({
      sessionId: z.string(),
      modelType: z.enum(["claude", "llama"]),
      messages: z.array(z.string()),
      systemInstructions: z.string().default("You are friendly and helpful."),
      maxTokens: z.number().optional(),
      temperature: z.number().optional(),
      stopSequences: z.array(z.string()).optional(),
    }),
    outputSchema: z.object({
      response: z.string(),
    }),
  },
  async ({sessionId, modelType, messages, systemInstructions, maxTokens, temperature, stopSequences}) => {
    const response = await sendMessagesToSession(
      ai, modelType, sessionId, messages,
      systemInstructions, maxTokens, temperature, stopSequences);
    return {response};
  }
);

export const deleteSessionFlow = ai.defineFlow(
  {
    name: "deleteChatSession",
    inputSchema: z.object({
      sessionId: z.string(),
    }),
    outputSchema: z.void(),
  },
  async ({sessionId}) => {
    await deleteSession(sessionId);
    return;
  }
);
