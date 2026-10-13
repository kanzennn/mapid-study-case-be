import { Prisma, Report, REPORT_STATUS } from '@prisma/client';
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
import { ListReportsQuery, ReportStatsQuery } from '../validations/report.validation';

export interface ReportListQuery {
  where: Prisma.ReportWhereInput;
  orderBy: Prisma.ReportOrderByWithRelationInput[];
  pagination: Pagination | null;
}

// Shared by the list and the stats endpoint.
export const buildReportWhere = (
  query: ReportStatsQuery & Pick<ListReportsQuery, 'status'>,
): Prisma.ReportWhereInput => {
  const search = buildSearch(query.search, ['title', 'description'] as const);
  const reporterSearch = buildSearch(query.search, ['name', 'email'] as const);

  return compact({
    // Matches the report title/description or the reporter's name/email.
    OR:
      search && reporterSearch
        ? [...search.OR, ...reporterSearch.OR.map((condition) => ({ reporter: condition }))]
        : undefined,
    status: buildIn(query.status),
    reporter_id: query.reporter_id,
    created_at: buildDateRange(query.created_from, query.created_to),
  });
};

export const buildReportListQuery = (query: ListReportsQuery): ReportListQuery => ({
  where: buildReportWhere(query),
  // `id` as a tie-breaker keeps the order stable across pages.
  orderBy: [...buildOrderBy(query.sort, [{ field: 'created_at', direction: 'desc' }]), { id: 'asc' }],
  pagination: buildPagination(query),
});

export const reportRepository = {
  create(data: Prisma.ReportUncheckedCreateInput): Promise<Report> {
    return prisma.report.create({ data });
  },

  findById(id: string) {
    return prisma.report.findUnique({
      where: { id },
      include: {
        reporter: {
          select: {
            id: true,
            name: true,
            email: true,
            picture_url: true
          }
        },
        report_status_histories: {
          orderBy: {
            created_at: 'desc'
          },
          include: {
            approver: {
              select: {
                id: true,
                name: true,
                email: true,
                picture_url: true
              }
            }
          }
        },
      },
    });
  },

  findMany({ where, orderBy, pagination }: ReportListQuery) {
    return prisma.report.findMany({
      where,
      orderBy,
      ...(pagination ? { skip: pagination.skip, take: pagination.take } : {}),
      include: {
        reporter: {
          select: {
            id: true,
            name: true,
            email: true,
            picture_url: true
          }
        },
        report_status_histories: {
          orderBy: {
            created_at: 'desc'
          },
          take: 1,
          include: {
            approver: {
              select: {
                id: true,
                name: true,
                email: true,
                picture_url: true
              }
            }
          }
        },
      }
    });
  },

  count(where: Prisma.ReportWhereInput): Promise<number> {
    return prisma.report.count({ where });
  },

  countByStatus(where: Prisma.ReportWhereInput) {
    return prisma.report.groupBy({ by: ['status'], where, _count: { _all: true } });
  },

  update(id: string, data: Prisma.ReportUpdateInput): Promise<Report> {
    return prisma.report.update({ where: { id }, data });
  },

  delete(id: string): Promise<Report> {
    return prisma.report.delete({ where: { id } });
  },

  setStatus(id: string, status: REPORT_STATUS, approverId: string): Promise<Report> {
    return prisma.$transaction(async (tx) => {
      const report = await tx.report.update({
        where: { id },
        data: { status },
      });

      await tx.reportStatusHistory.create({
        data: {
          report_id: id,
          status,
          approver_id: approverId,
        },
      });

      return report;
    });
  },
};
