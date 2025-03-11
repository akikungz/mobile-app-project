import { Elysia, t } from "elysia";
import { jwt } from "@elysiajs/jwt";
import { cookie } from "@elysiajs/cookie";

import { env } from "./env";

export const middleware = new Elysia()
  .use(jwt({
    secret: env.JWT_SECRET,
    schema: t.Object({
      id: t.Integer(),
    }),
  }))
  .use(cookie())

export const expTime = {
  accessToken: 60 * 60,
  refreshToken: 60 * 60 * 24 * 30,
}