import { Prisma, Report, REPORT_STATUS } from '@prisma/client';
import { prisma } from '../config/prisma';

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

  findAll(where?: Prisma.ReportWhereInput): Promise<Report[]> {
    return prisma.report.findMany({
      where,
      orderBy: { created_at: 'desc' },
      include: {
        reporter: {
          select: {
            id: true,
            name: true,
            email: true,
            picture_url: true
          }
        },
      }
    });
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
