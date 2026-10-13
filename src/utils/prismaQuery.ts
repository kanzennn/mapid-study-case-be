import { z } from 'zod';

// Helpers that turn URL query params into Prisma query arguments.

export type SortDirection = 'asc' | 'desc';

export interface SortItem<TField extends string = string> {
  field: TField;
  direction: SortDirection;
}

export interface PaginationInput {
  page?: number;
  limit?: number;
}

export interface Pagination {
  page: number;
  limit: number;
  skip: number;
  take: number;
}

export interface PaginationMeta {
  page: number;
  limit: number;
  total: number;
  total_pages: number;
}

const DATE_ONLY = /^\d{4}-\d{2}-\d{2}$/;

// Accepts both `?a=x,y` and `?a=x&a=y`.
const toList = (value: unknown) => {
  if (value === undefined || value === '') return undefined;
  const raw = Array.isArray(value) ? value : [value];
  return raw
    .flatMap((item) => String(item).split(','))
    .map((item) => item.trim())
    .filter(Boolean);
};

// Uses the first value when a param is repeated (`?page=1&page=2`).
const first = (value: unknown) => (Array.isArray(value) ? value[0] : value);

export const queryParam = {
  search: () =>
    z.preprocess(
      (value) => {
        const v = first(value);
        return typeof v === 'string' && v.trim() ? v.trim() : undefined;
      },
      z.string().max(100, 'Search term is too long').optional(),
    ),

  enumList: <T extends Record<string, string>>(values: T) =>
    z.preprocess(toList, z.array(z.enum(values)).min(1).optional()),

  boolean: () => z.preprocess(first, z.stringbool().optional()),

  // With `endOfDay`, a date-only value like `2026-10-13` is extended to 23:59:59.999
  // so the whole day is included.
  date: ({ endOfDay = false }: { endOfDay?: boolean } = {}) =>
    z.preprocess(
      (value) => {
        const v = first(value);
        if (typeof v !== 'string' || !v) return undefined;
        const date = new Date(v);
        if (endOfDay && DATE_ONLY.test(v)) date.setUTCHours(23, 59, 59, 999);
        return date;
      },
      z.date({ error: 'Invalid date, use ISO format (YYYY-MM-DD)' }).optional(),
    ),

  positiveInt: (max?: number) => {
    let schema = z.coerce.number().int().positive();
    if (max) schema = schema.max(max);
    return z.preprocess(first, schema.optional());
  },

  // `?sort=-created_at,name`, where a `-` prefix means descending.
  sort: <TField extends string>(allowed: readonly [TField, ...TField[]]) =>
    z.preprocess(
      toList,
      z
        .array(z.string())
        .transform((items, ctx) => {
          const result: SortItem<TField>[] = [];
          for (const item of items) {
            const direction: SortDirection = item.startsWith('-') ? 'desc' : 'asc';
            const field = item.replace(/^[-+]/, '');
            if (!(allowed as readonly string[]).includes(field)) {
              ctx.addIssue({
                code: 'custom',
                message: `Cannot sort by "${field}". Allowed: ${allowed.join(', ')}`,
              });
              return z.NEVER;
            }
            result.push({ field: field as TField, direction });
          }
          return result;
        })
        .optional(),
    ),
};

export const buildSearch = <TField extends string>(
  term: string | undefined,
  fields: readonly TField[],
) => {
  if (!term) return undefined;
  return {
    OR: fields.map(
      (field) =>
        ({ [field]: { contains: term, mode: 'insensitive' } }) as {
          [K in TField]: { contains: string; mode: 'insensitive' };
        },
    ),
  };
};

export const buildIn = <T>(values: T[] | undefined) =>
  values && values.length > 0 ? { in: values } : undefined;

export const buildDateRange = (from?: Date, to?: Date) => {
  if (!from && !to) return undefined;
  return {
    ...(from ? { gte: from } : {}),
    ...(to ? { lte: to } : {}),
  };
};

export const buildOrderBy = <TField extends string>(
  sort: SortItem<TField>[] | undefined,
  fallback: SortItem<TField>[],
) => {
  const items = sort && sort.length > 0 ? sort : fallback;
  return items.map(({ field, direction }) => ({ [field]: direction }) as Record<TField, SortDirection>);
};

// Pagination only kicks in when `page` or `limit` is sent, so existing clients
// that fetch the whole list keep working.
export const buildPagination = (
  { page, limit }: PaginationInput,
  defaultLimit = 10,
): Pagination | null => {
  if (page === undefined && limit === undefined) return null;
  const resolvedPage = page ?? 1;
  const resolvedLimit = limit ?? defaultLimit;
  return {
    page: resolvedPage,
    limit: resolvedLimit,
    skip: (resolvedPage - 1) * resolvedLimit,
    take: resolvedLimit,
  };
};

export const buildPaginationMeta = (total: number, pagination: Pagination): PaginationMeta => ({
  page: pagination.page,
  limit: pagination.limit,
  total,
  total_pages: Math.ceil(total / pagination.limit),
});

export const compact = <T extends Record<string, unknown>>(obj: T) =>
  Object.fromEntries(Object.entries(obj).filter(([, value]) => value !== undefined)) as T;
