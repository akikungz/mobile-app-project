import { Elysia } from "elysia";
import { swagger } from "@elysiajs/swagger";
import { node } from "@elysiajs/node";

import { users } from "@/routes/users";
import todos from "@/routes/todos";

import { env } from "@/libs/env";

export const app = new Elysia({ adapter: node() })
  .use(swagger())
  .use(users)
  .use(todos)
  .listen(env.PORT, ({ port }) => console.log(`Server is running on ${port}`));

export type App = typeof app;

export default app;
