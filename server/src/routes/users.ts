import { password as Password } from "bun";
import { Elysia, t } from "elysia";
import { eq } from "drizzle-orm"; 
// import argon2 from "argon2";

import { db } from "@/db";
import { usersTable } from "@/db/schema";

import { expTime, middleware } from "@/libs/jwt";
import { omit } from "@/libs/function";

export const users = new Elysia({ prefix: "/users" })
  .use(middleware)
  .get("/me", async ({ cookie: { accessToken, refreshToken }, jwt, error }) => {
    if (!accessToken.value) {
      // refresh token
      if (refreshToken.value) {
        const data = await jwt.verify(refreshToken.value);
        
        if (data) {
          // resign access token
          const newAccessToken = await jwt.sign({
            id: data.id,
            exp: expTime.accessToken,
          });
          const newRefreshToken = await jwt.sign({
            id: data.id, 
            exp: expTime.refreshToken,
          });

          accessToken.set({ 
            value: newAccessToken, 
            expires: new Date(Date.now() + expTime.accessToken * 1000) 
          });
          refreshToken.set({ 
            value: newRefreshToken, 
            expires: new Date(Date.now() + expTime.refreshToken * 1000) 
          });

          const user = await getUser(data.id);
          return omit(user[0], ["password", "created_at", "updated_at"]);
        }
      } else {
        return error("Unauthorized", 401);
      }
    }

    const data = await jwt.verify(accessToken.value);
    if (!data) {
      return error("Unauthorized", 401);
    }

    try {
      const user = await getUser(data.id);
      return omit(user[0], ["password", "created_at", "updated_at"]);
    } catch (e) {
      console.log(e);
      return error("Internal Server Error", 500);
    }
  })
  .post("/sign-in", async ({ body, jwt, cookie: { accessToken, refreshToken }, error }) => {
    try {
      const user = await db.select().from(usersTable).where(eq(usersTable.email, body.email));
      
      if (user.length === 0) {
        return error("Unauthorized", 401);
      }

      if (!verifyPassword(body.password, user[0].password)) {
        return error("Unauthorized", 401);
      }

      const newAccessToken = await jwt.sign({
        id: user[0].id,
        exp: expTime.accessToken,
      });

      const newRefreshToken = await jwt.sign({
        id: user[0].id,
        exp: expTime.refreshToken,
      });

      accessToken.set({ 
        value: newAccessToken, 
        expires: new Date(Date.now() + expTime.accessToken * 1000) 
      });

      refreshToken.set({ 
        value: newRefreshToken, 
        expires: new Date(Date.now() + expTime.refreshToken * 1000) 
      });

      return omit(user[0], ["password", "created_at", "updated_at"]);
    } catch (e) {
      console.log(e);
      return error("Internal Server Error", 500);
    }
  }, {
    body: t.Object({
      email: t.String(),
      password: t.String(),
    })
  })
  .post("/sign-up", async ({ body, error }) => {
    try {
      const user = await db.select().from(usersTable).where(eq(usersTable.email, body.email));
      
      if (user.length > 0) {
        return error("Conflict", 409);
      }
    } catch (e) {
      console.log(e);
      return error("Internal Server Error", 500);
    }

    try {
      const newUser = await db.insert(usersTable).values({
        email: body.email,
        password: hashPassword(body.password),
      }).returning();

      return omit(newUser[0], ["password", "created_at", "updated_at"]);
    } catch (e) {
      console.log(e);
      return error("Internal Server Error", 500);
    }
  }, {
    body: t.Object({
      email: t.String(),
      password: t.String(),
    })
  })

export const getUser = (id: number) => {
  try {
    return db.select().from(usersTable).where(eq(usersTable.id, id));
  } catch (e) {
    console.log(e);
    return [];
  }
}

export const hashPassword = (password: string) => {
  return Password.hashSync(password);
  // return argon2.hash(password);
}

export const verifyPassword = (password: string, hash: string) => {
  // return argon2.verify(hash, password);
  return Password.verifySync(password, hash);
}
