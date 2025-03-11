import { serve } from "bun";
import app from "./src";
import { env } from "@/libs/env";

serve({
  port: env.PORT,
  fetch(request) {
    console.log(request.url);
    return app.handle(request);
  }
});

console.log(env);