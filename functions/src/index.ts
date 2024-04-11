import * as functions from "firebase-functions/v2";
import {VertexAI} from "@google-cloud/vertexai";
import {CallableRequest} from "firebase-functions/v2/https";

interface Part {
    text: string;
}

interface Content {
    role: string;
    parts: Part[];
}

exports.geminiCall = functions.https.onCall(async (request: CallableRequest<{contents: Content[], stopSequences: string[], maxTokens: number, temperature: number}> ) => {
  const vertexai = new VertexAI({project: process.env.GCLOUD_PROJECT ?? "", location: "us-central1"});

  const model = "gemini-pro";

  const generativeModel = vertexai.preview.getGenerativeModel({
    model: model,
    generation_config: {
      "max_output_tokens": request.data.maxTokens,
      "stop_sequences": request.data.stopSequences,
      "temperature": request.data.temperature,
    },
  });

  const req = {
    contents: request.data.contents,
  };

  try {
    const content = await generativeModel.generateContent(req);
    if (!content.response.candidates.length) {
      throw new Error("No candidates found in the response.");
    }

    const firstCandidate = content.response.candidates.at(0);
    if (!firstCandidate || !firstCandidate.content.parts.length) {
      throw new Error("No content parts found in the first candidate.");
    }

    const firstPartText = firstCandidate.content.parts.at(0)?.text;
    if (typeof firstPartText === "undefined") {
      throw new Error("First part of the first candidate does not contain text.");
    }

    return {result: firstPartText};
  } catch (error) {
    console.error("Error generating content:", error);
    // Return a generic error message or you might choose to return the actual error message for debugging
    return {result: `An error occurred while generating content. ${error}`};
  }
});
