import { REPORT_STATUS, USER_ROLE } from '@prisma/client';
import {
  buildReportListQuery,
  reportRepository,
} from '../repositories/report.repository';
import { AppError } from '../utils/AppError';
import { buildPaginationMeta } from '../utils/prismaQuery';
import {
  CreateReportInput,
  ListReportsQuery,
  UpdateReportInput,
} from '../validations/report.validation';

interface ReportActor {
  id: string;
  role: USER_ROLE;
}

// Reporters only ever see their own reports, whatever reporter_id they send.
const scopeToActor = <T extends { reporter_id?: string }>(query: T, actor: ReportActor): T =>
  actor.role === USER_ROLE.REPORTER ? { ...query, reporter_id: actor.id } : query;

export const reportService = {
  async getAll(actor: ReportActor, query: ListReportsQuery = {}) {
    const listQuery = buildReportListQuery(scopeToActor(query, actor));
    const [reports, total] = await Promise.all([
      reportRepository.findMany(listQuery),
      listQuery.pagination ? reportRepository.count(listQuery.where) : undefined,
    ]);

    return {
      reports,
      meta:
        listQuery.pagination && total !== undefined
          ? buildPaginationMeta(total, listQuery.pagination)
          : undefined,
    };
  },

  async getById(id: string, actor: ReportActor) {
    const report = await reportRepository.findById(id);
    if (!report) {
      throw new AppError('Report not found', 404);
    }

    if (actor.role === USER_ROLE.REPORTER && report.reporter_id !== actor.id) {
      throw new AppError('You do not have permission to view this report', 403);
    }

    return report;
  },

  async create(input: CreateReportInput, reporterId: string) {
    return reportRepository.create({
      title: input.title,
      description: input.description,
      reporter_id: reporterId,
    });
  },

  async update(id: string, input: UpdateReportInput, requestedBy: string) {
    const report = await reportRepository.findById(id);
    if (!report) {
      throw new AppError('Report not found', 404);
    }

    if (report.reporter_id !== requestedBy) {
      throw new AppError('You do not have permission to edit this report', 403);
    }

    if (report.status !== REPORT_STATUS.PENDING) {
      throw new AppError('Report can only be edited while it is pending', 400);
    }

    return reportRepository.update(id, input);
  },

  async remove(id: string, requestedBy: string) {
    const report = await reportRepository.findById(id);
    if (!report) {
      throw new AppError('Report not found', 404);
    }

    if (report.reporter_id !== requestedBy) {
      throw new AppError('You do not have permission to delete this report', 403);
    }

    if (report.status !== REPORT_STATUS.PENDING) {
      throw new AppError('Report can only be deleted while it is pending', 400);
    }

    await reportRepository.delete(id);
  },

  async approve(id: string, approverId: string) {
    const report = await reportRepository.findById(id);
    if (!report) {
      throw new AppError('Report not found', 404);
    }

    if (report.status === REPORT_STATUS.APPROVED) {
      throw new AppError('This report has already been approved', 400);
    }

    return reportRepository.setStatus(id, REPORT_STATUS.APPROVED, approverId);
  },

  async reject(id: string, approverId: string) {
    const report = await reportRepository.findById(id);
    if (!report) {
      throw new AppError('Report not found', 404);
    }

    if (report.status === REPORT_STATUS.REJECTED) {
      throw new AppError('This report has already been rejected', 400);
    }

    return reportRepository.setStatus(id, REPORT_STATUS.REJECTED, approverId);
  },
};
