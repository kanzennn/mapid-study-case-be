import { USER_ROLE } from '@prisma/client';
import { Request, Response } from 'express';
import { reportService } from '../services/report.service';
import { catchAsync } from '../utils/catchAsync';
import { sendSuccess } from '../utils/response';
import { ListReportsQuery } from '../validations/report.validation';

const actorOf = (req: Request) => ({ id: req.userId as string, role: req.userRole as USER_ROLE });

export const getAllReports = catchAsync(async (req: Request, res: Response) => {
  const { reports, meta } = await reportService.getAll(actorOf(req), req.query as ListReportsQuery);
  sendSuccess(res, reports, 200, meta);
});

export const getReportById = catchAsync(
  async (req: Request<{ id: string }>, res: Response) => {
    const report = await reportService.getById(req.params.id, {
      id: req.userId as string,
      role: req.userRole as USER_ROLE,
    });
    sendSuccess(res, report);
  },
);

export const createReport = catchAsync(async (req: Request, res: Response) => {
  const report = await reportService.create(req.body, req.userId as string);
  sendSuccess(res, report, 201);
});

export const updateReport = catchAsync(
  async (req: Request<{ id: string }>, res: Response) => {
    const report = await reportService.update(req.params.id, req.body, req.userId as string);
    sendSuccess(res, report);
  },
);

export const deleteReport = catchAsync(
  async (req: Request<{ id: string }>, res: Response) => {
    await reportService.remove(req.params.id, req.userId as string);
    res.status(204).send();
  },
);

export const approveReport = catchAsync(
  async (req: Request<{ id: string }>, res: Response) => {
    const report = await reportService.approve(req.params.id, req.userId as string);
    sendSuccess(res, report);
  },
);

export const rejectReport = catchAsync(
  async (req: Request<{ id: string }>, res: Response) => {
    const report = await reportService.reject(req.params.id, req.userId as string);
    sendSuccess(res, report);
  },
);
