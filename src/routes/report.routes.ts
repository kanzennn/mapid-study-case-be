import { Router } from 'express';
import {
  approveReport,
  createReport,
  deleteReport,
  getAllReports,
  getReportById,
  rejectReport,
  updateReport,
} from '../controllers/report.controller';
import { requireAuth } from '../middlewares/auth.middleware';
import { requireRole } from '../middlewares/role.middleware';
import { validate } from '../middlewares/validate.middleware';
import {
  createReportSchema,
  reportIdParamSchema,
  updateReportSchema,
} from '../validations/report.validation';

const router = Router();

router.use(requireAuth);

router.get('/', requireRole('REPORTER', 'APPROVER'), getAllReports);

router.get(
  '/:id',
  requireRole('REPORTER', 'APPROVER'),
  validate({ params: reportIdParamSchema }),
  getReportById,
);

router.post('/', requireRole('REPORTER'), validate({ body: createReportSchema }), createReport);

router.patch(
  '/:id',
  requireRole('REPORTER'),
  validate({ params: reportIdParamSchema, body: updateReportSchema }),
  updateReport,
);

router.delete(
  '/:id',
  requireRole('REPORTER'),
  validate({ params: reportIdParamSchema }),
  deleteReport,
);

router.patch(
  '/:id/approve',
  requireRole('APPROVER'),
  validate({ params: reportIdParamSchema }),
  approveReport,
);

router.patch(
  '/:id/reject',
  requireRole('APPROVER'),
  validate({ params: reportIdParamSchema }),
  rejectReport,
);

export default router;
