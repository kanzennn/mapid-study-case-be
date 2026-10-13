import { REPORT_STATUS } from '@prisma/client';
import { z } from 'zod';
import { queryParam } from '../utils/prismaQuery';

export const reportIdParamSchema = z.object({
  id: z.string().uuid('Invalid report id'),
});

export const createReportSchema = z.object({
  title: z.string().min(1, 'Title is required'),
  description: z.string().min(1, 'Description is required'),
});

export const updateReportSchema = z.object({
  title: z.string().min(1, 'Title is required').optional(),
  description: z.string().min(1, 'Description is required').optional(),
});

export const REPORT_SORTABLE_FIELDS = ['title', 'status', 'created_at', 'updated_at'] as const;
export type ReportSortableField = (typeof REPORT_SORTABLE_FIELDS)[number];

const reportFilterShape = {
  search: queryParam.search(),
  status: queryParam.enumList(REPORT_STATUS),
  reporter_id: z.preprocess(
    (value) => (Array.isArray(value) ? value[0] : value) || undefined,
    z.string().uuid('Invalid reporter id').optional(),
  ),
  created_from: queryParam.date(),
  created_to: queryParam.date({ endOfDay: true }),
};

const validDateRange = (q: { created_from?: Date; created_to?: Date }) =>
  !q.created_from || !q.created_to || q.created_from <= q.created_to;
const dateRangeIssue = { message: 'created_from must be before created_to', path: ['created_from'] };

export const listReportsQuerySchema = z
  .object({
    ...reportFilterShape,
    sort: queryParam.sort(REPORT_SORTABLE_FIELDS),
    page: queryParam.positiveInt(),
    limit: queryParam.positiveInt(100),
  })
  .refine(validDateRange, dateRangeIssue);

// Same filters as the list minus status (stats are grouped by it), sort and pagination.
export const reportStatsQuerySchema = z
  .object({
    search: reportFilterShape.search,
    reporter_id: reportFilterShape.reporter_id,
    created_from: reportFilterShape.created_from,
    created_to: reportFilterShape.created_to,
  })
  .refine(validDateRange, dateRangeIssue);

export type CreateReportInput = z.infer<typeof createReportSchema>;
export type UpdateReportInput = z.infer<typeof updateReportSchema>;
export type ListReportsQuery = z.infer<typeof listReportsQuerySchema>;
export type ReportStatsQuery = z.infer<typeof reportStatsQuerySchema>;
