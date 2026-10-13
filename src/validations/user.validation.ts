import { USER_ROLE } from '@prisma/client';
import { z } from 'zod';
import { queryParam } from '../utils/prismaQuery';

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

export const USER_SORTABLE_FIELDS = ['name', 'email', 'role', 'is_active', 'created_at', 'updated_at'] as const;
export type UserSortableField = (typeof USER_SORTABLE_FIELDS)[number];

export const listUsersQuerySchema = z
  .object({
    search: queryParam.search(),
    role: queryParam.enumList(USER_ROLE),
    is_active: queryParam.boolean(),
    created_from: queryParam.date(),
    created_to: queryParam.date({ endOfDay: true }),
    sort: queryParam.sort(USER_SORTABLE_FIELDS),
    page: queryParam.positiveInt(),
    limit: queryParam.positiveInt(100),
  })
  .refine((q) => !q.created_from || !q.created_to || q.created_from <= q.created_to, {
    message: 'created_from must be before created_to',
    path: ['created_from'],
  });

export type CreateUserInput = z.infer<typeof createUserSchema>;
export type UpdateUserInput = z.infer<typeof updateUserSchema>;
export type ListUsersQuery = z.infer<typeof listUsersQuerySchema>;
