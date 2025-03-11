import z from "zod";
import "dotenv/config";

export const envSchema = z.object({
  PORT: z.string().default("3000"),
  NODE_ENV: z.string().default("development"),
  DATABASE_URI: z.string().default("postgres://postgres:password@localhost:5432/elysia"),
  JWT_SECRET: z.string().default("secret"),
});

export type Env = z.infer<typeof envSchema>;

export const env = envSchema.parse(process.env);
