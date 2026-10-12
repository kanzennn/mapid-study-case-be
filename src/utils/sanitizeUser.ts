import { User } from '@prisma/client';

export const sanitizeUser = (user: User) => ({
  id: user.id,
  name: user.name,
  email: user.email,
  role: user.role,
  is_active: user.is_active,
  createdAt: user.createdAt,
});
