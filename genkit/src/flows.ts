import {z} from "genkit/beta";
import {createChatSession, sendMessagesToSession, deleteSession} from "./chat.js";
import {ai} from "./genkit.config.js";

export const initChatFlow = ai.defineFlow(
  {
    name: "initChatSession",
    inputSchema: z.object({
      modelType: z.enum(["deepseek", "llama"]),
      systemInstructions: z.string().default("You are friendly and helpful."),
      maxTokens: z.number().optional(),
      temperature: z.number().optional(),
      stopSequences: z.array(z.string()).optional(),
      streaming: z.boolean().optional(),
    }),
    outputSchema: z.object({
      sessionId: z.string(),
    }),
  },
  async ({modelType, systemInstructions, maxTokens, temperature, stopSequences, streaming}) => {
    const sessionId = await createChatSession(modelType, systemInstructions, maxTokens, temperature, stopSequences, streaming);
    return {sessionId};
  }
);

export const sendMessagesFlow = ai.defineFlow(
  {
    name: "sendMessagesToChat",
    inputSchema: z.object({
      sessionId: z.string(),
      modelType: z.enum(["deepseek", "llama"]),
      messages: z.array(z.string()),
      systemInstructions: z.string().default("You are friendly and helpful."),
      maxTokens: z.number().optional(),
      temperature: z.number().optional(),
      stopSequences: z.array(z.string()).optional(),
      streaming: z.boolean().optional(),
    }),
    outputSchema: z.object({
      response: z.string(),
    }),
    streamSchema: z.string(),
  },
  async ({sessionId, modelType, messages, systemInstructions, maxTokens, temperature, stopSequences, streaming}, {sendChunk}) => {
    const response = await sendMessagesToSession(
      modelType, sessionId, messages,
      systemInstructions, maxTokens, temperature, stopSequences,
      streaming && sendChunk ? (chunk: string) => { sendChunk(chunk); } : undefined,
      streaming
    );
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
