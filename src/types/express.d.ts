import { USER_ROLE } from '@prisma/client';

declare global {
  namespace Express {
    export interface Request {
      userId?: string;
      userRole?: USER_ROLE;
    }
  }
}

export {};
