import {onCallGenkit} from "firebase-functions/v2/https";
import {defineSecret} from "firebase-functions/params";
import {initChatFlow, sendMessagesFlow, deleteSessionFlow} from "./flows.js";

const githubToken = defineSecret("GITHUB_TOKEN");

export const initChatSession = onCallGenkit({
  secrets: [githubToken],
}, initChatFlow);
export const sendMessagesToChat = onCallGenkit({
  secrets: [githubToken],
}, sendMessagesFlow);
export const deleteSession = onCallGenkit({
  secrets: [githubToken],
}, deleteSessionFlow);
