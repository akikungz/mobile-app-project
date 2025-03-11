import { Elysia, t } from "elysia";
import { eq, and } from "drizzle-orm"; 

import { db } from "@/db";
import { todosTable } from "@/db/schema";

import { middleware } from "@/libs/jwt";
import { omit } from "@/libs/function";

export const todos = new Elysia({ prefix: "/todos" })
  .use(middleware)
  .get("/", async ({ jwt, cookie: { accessToken }, error }) => {
    const data = await jwt.verify(accessToken.value);
    if (!data) {
      return error("Unauthorized", 401);
    }

    return db.select().from(todosTable).where(eq(todosTable.user_id, data.id));
  })
  .post("/", async ({ body, jwt, cookie: { accessToken }, error }) => {
    const data = await jwt.verify(accessToken.value);
    if (!data) {
      return error("Unauthorized", 401);
    }

    const newTodo = await db.insert(todosTable).values({
      ...body,
      user_id: data.id,
    }).returning();

    return omit(newTodo[0], ["user_id"]);
  }, {
    body: t.Object({
      title: t.String(),
      description: t.String(),
    }),
  })
  .put("/:id", async ({ params, body, jwt, cookie: { accessToken }, error }) => {
    const data = await jwt.verify(accessToken.value);
    if (!data) {
      return error("Unauthorized", 401);
    }

    const updatedTodo = await db.update(todosTable).set(body).where(
      and(eq(todosTable.id, params.id), eq(todosTable.user_id, data.id))
    ).returning();
    return omit(updatedTodo[0], ["user_id"]);
  }, {
    body: t.Object({
      title: t.String(),
      description: t.String(),
      completed: t.Boolean(),
    }),
    params: t.Object({
      id: t.Integer(),
    }),
  })
  .patch("/:id", async ({ params, body, jwt, cookie: { accessToken }, error }) => {
    const data = await jwt.verify(accessToken.value);
    if (!data) {
      return error("Unauthorized", 401);
    }

    const patchedTodo = await db.update(todosTable).set(body).where(
      and(eq(todosTable.id, params.id), eq(todosTable.user_id, data.id))
    ).returning();

    return omit(patchedTodo[0], ["user_id"]);
  }, {
    body: t.Object({
      completed: t.Boolean(),
    }),
    params: t.Object({
      id: t.Integer(),
    }),
  })
