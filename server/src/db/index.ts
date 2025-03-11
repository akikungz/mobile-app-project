import { drizzle } from "drizzle-orm/node-postgres";

import { env } from "@/libs/env";

export const db = drizzle(env.DATABASE_URI);