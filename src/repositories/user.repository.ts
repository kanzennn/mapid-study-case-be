import { Prisma, User } from '@prisma/client';
import { prisma } from '../config/prisma';
import {
  buildDateRange,
  buildIn,
  buildOrderBy,
  buildPagination,
  buildSearch,
  compact,
  Pagination,
} from '../utils/prismaQuery';
import { ListUsersQuery } from '../validations/user.validation';

export interface UserListQuery {
  where: Prisma.UserWhereInput;
  orderBy: Prisma.UserOrderByWithRelationInput[];
  pagination: Pagination | null;
}

export const buildUserListQuery = (query: ListUsersQuery): UserListQuery => ({
  where: compact({
    ...buildSearch(query.search, ['name', 'email'] as const),
    role: buildIn(query.role),
    is_active: query.is_active,
    created_at: buildDateRange(query.created_from, query.created_to),
  }),
  // `id` as a tie-breaker keeps the order stable across pages.
  orderBy: [...buildOrderBy(query.sort, [{ field: 'created_at', direction: 'desc' }]), { id: 'asc' }],
  pagination: buildPagination(query),
});

export const userRepository = {
  create(data: Prisma.UserCreateInput): Promise<User> {
    return prisma.user.create({ data });
  },

  findById(id: string): Promise<User | null> {
    return prisma.user.findUnique({ where: { id } });
  },

  findByEmail(email: string): Promise<User | null> {
    return prisma.user.findUnique({ where: { email } });
  },

  findMany({ where, orderBy, pagination }: UserListQuery): Promise<User[]> {
    return prisma.user.findMany({
      where,
      orderBy,
      ...(pagination ? { skip: pagination.skip, take: pagination.take } : {}),
    });
  },

  count(where: Prisma.UserWhereInput): Promise<number> {
    return prisma.user.count({ where });
  },

  update(id: string, data: Prisma.UserUpdateInput): Promise<User> {
    return prisma.user.update({ where: { id }, data });
  },

  delete(id: string): Promise<User> {
    return prisma.user.delete({ where: { id } });
  },
};
