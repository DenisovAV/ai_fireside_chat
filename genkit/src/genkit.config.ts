import {genkit} from "genkit/beta";
import {github} from "genkitx-github";
import {googleAI} from "@genkit-ai/googleai";

// Plugins will read from process.env.GITHUB_TOKEN and process.env.GOOGLE_GENAI_API_KEY
// These are injected by Firebase when secrets are declared in index.ts
export const ai = genkit({
  plugins: [
    github(), // Reads GITHUB_TOKEN from env
    googleAI(), // Reads GOOGLE_GENAI_API_KEY from env
  ],
});
