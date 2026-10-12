import { z } from 'zod';

export const userIdParamSchema = z.object({
  id: z.string().uuid('Invalid user id'),
});

export const updateUserSchema = z.object({
  name: z.string().min(2).optional(),
  email: z.string().email().optional(),
});

export type UpdateUserInput = z.infer<typeof updateUserSchema>;
