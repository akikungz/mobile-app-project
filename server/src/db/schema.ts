import { boolean, integer, pgTable, timestamp, varchar } from "drizzle-orm/pg-core";
import { sql } from "drizzle-orm/sql";

export const todosTable = pgTable("todos", {
  id: integer().primaryKey().generatedAlwaysAsIdentity(),
  title: varchar().notNull(),
  description: varchar(),
  completed: boolean().notNull().default(false),
  created_at: timestamp().notNull().default(sql`now()`),
  updated_at: timestamp().notNull().default(sql`now()`),

  // foreign key
  user_id: integer().notNull(),
});

export const usersTable = pgTable("users", {
  id: integer().primaryKey().generatedAlwaysAsIdentity(),
  email: varchar().notNull().unique(),
  password: varchar().notNull(),
  created_at: timestamp().notNull().default(sql`now()`),
  updated_at: timestamp().notNull().default(sql`now()`),
});
