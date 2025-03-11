import { Elysia } from "elysia";
import { swagger } from "@elysiajs/swagger";

import { users } from "@/routes/users";
import todos from "@/routes/todos";

export const app = new Elysia()
  .use(swagger())
  .use(users)
  .use(todos)
  .listen(3000, ({ port }) => console.log(`Server is running on ${port}`));

export type App = typeof app;

export default app;
