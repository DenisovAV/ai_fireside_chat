import {onCallGenkit} from "firebase-functions/v2/https";
import {defineSecret} from "firebase-functions/params";
import {initChatFlow, sendMessagesFlow, deleteSessionFlow} from "./flows";

const claudeApiKey = defineSecret("ANTHROPIC_API_KEY");
const githubToken = defineSecret("GITHUB_TOKEN");

export const initChatSession = onCallGenkit({
  secrets: [claudeApiKey, githubToken],
}, initChatFlow);
export const sendMessagesToChat = onCallGenkit({
  secrets: [claudeApiKey, githubToken],
}, sendMessagesFlow);
export const deleteSession = onCallGenkit({
  secrets: [claudeApiKey, githubToken],
}, deleteSessionFlow);
