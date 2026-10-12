import { USER_ROLE } from '@prisma/client';
import { z } from 'zod';

export const userIdParamSchema = z.object({
  id: z.string().uuid('Invalid user id'),
});

export const createUserSchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters'),
  email: z.string().email('Invalid email address'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
  role: z.nativeEnum(USER_ROLE).optional(),
});

export const updateUserSchema = z.object({
  name: z.string().min(2).optional(),
  email: z.string().email().optional(),
  password: z.string().min(8, 'Password must be at least 8 characters').optional(),
  role: z.nativeEnum(USER_ROLE).optional(),
});

export type CreateUserInput = z.infer<typeof createUserSchema>;
export type UpdateUserInput = z.infer<typeof updateUserSchema>;
