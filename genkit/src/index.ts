import {onCallGenkit} from "firebase-functions/v2/https";
import {defineSecret} from "firebase-functions/params";
import {initChatFlow, sendMessagesFlow, deleteSessionFlow} from "./flows.js";

const githubToken = defineSecret("GITHUB_TOKEN");
const googleApiKey = defineSecret("GOOGLE_GENAI_API_KEY");

export const initChatSession = onCallGenkit({
  secrets: [githubToken, googleApiKey],
}, initChatFlow);

export const sendMessagesToChat = onCallGenkit({
  secrets: [githubToken, googleApiKey],
}, sendMessagesFlow);

export const deleteChatSession = onCallGenkit({
  secrets: [githubToken, googleApiKey],
}, deleteSessionFlow);
