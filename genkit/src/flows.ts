import {genkit, z} from "genkit/beta";
import {github} from "genkitx-github";
import {googleAI} from "@genkit-ai/googleai";
import {createChatSession, sendMessagesToSession, deleteSession} from "./chat.js";

const githubAI = genkit({
  plugins: [
    github(),
  ],
});

const googleAI_instance = genkit({
  plugins: [
    googleAI(),
  ],
});

export const initChatFlow = githubAI.defineFlow(
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
    const aiInstance = streaming ? googleAI_instance : githubAI;
    const sessionId = await createChatSession(aiInstance, modelType, systemInstructions, maxTokens, temperature, stopSequences, streaming);
    return {sessionId};
  }
);

export const sendMessagesFlow = githubAI.defineFlow(
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
    const aiInstance = streaming ? googleAI_instance : githubAI;
    const response = await sendMessagesToSession(
      aiInstance, modelType, sessionId, messages,
      systemInstructions, maxTokens, temperature, stopSequences,
      streaming && sendChunk ? (chunk: string) => { sendChunk(chunk); } : undefined,
      streaming
    );
    return {response};
  }
);


export const deleteSessionFlow = githubAI.defineFlow(
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
