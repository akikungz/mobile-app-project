import { Elysia } from "elysia";
import { swagger } from "@elysiajs/swagger";
import { cors } from "@elysiajs/cors";

import { users } from "@/routes/users";
import { todos } from "@/routes/todos";

import { env } from "@/libs/env";

export const app = new Elysia()
  .use(swagger())
  .use(cors({
    origin: "*",
    credentials: true,
  }))
  .onAfterResponse((ctx) => console.log(`[${ctx.request.method}] ${ctx.path} ${ctx.set.status} ${ctx.request.body?.toString()}`))
  .use(users)
  .use(todos)

env.NODE_ENV == "development" && app.listen(env.PORT, ({ port }) => console.log(`Server is running on ${port}`));

export type App = typeof app;

export default app;
