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
  listReportsQuerySchema,
  reportIdParamSchema,
  updateReportSchema,
} from '../validations/report.validation';

const router = Router();

router.use(requireAuth);

/**
 * @openapi
 * /reports:
 *   get:
 *     tags: [Reports]
 *     summary: List reports (search, filter, sort & optional pagination). Reporters only see their own reports.
 *     parameters:
 *       - in: query
 *         name: search
 *         description: Case-insensitive match on title, description, or reporter name/email
 *         schema: { type: string, example: jalan }
 *       - in: query
 *         name: status
 *         description: One or more statuses, comma separated (or repeat the param)
 *         schema: { type: string, example: 'PENDING,REJECTED' }
 *       - in: query
 *         name: reporter_id
 *         description: Approvers only. Ignored for reporters, who are always scoped to themselves.
 *         schema: { type: string, format: uuid }
 *       - in: query
 *         name: created_from
 *         description: Inclusive lower bound. Date-only values are read as UTC.
 *         schema: { type: string, format: date, example: '2026-10-01' }
 *       - in: query
 *         name: created_to
 *         description: Inclusive upper bound. A date without time covers the whole day.
 *         schema: { type: string, format: date, example: '2026-10-31' }
 *       - in: query
 *         name: sort
 *         description: Comma separated, prefix `-` for descending. Allowed - title, status, created_at, updated_at. Default `-created_at`.
 *         schema: { type: string, example: '-created_at' }
 *       - in: query
 *         name: page
 *         description: Enables pagination when `page` or `limit` is sent
 *         schema: { type: integer, minimum: 1, example: 1 }
 *       - in: query
 *         name: limit
 *         description: Items per page (default 10, max 100)
 *         schema: { type: integer, minimum: 1, maximum: 100, example: 10 }
 *     responses:
 *       200:
 *         description: List of reports. `meta` is only present when paginated.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status: { type: string, example: success }
 *                 data: { type: array, items: { type: object } }
 *                 meta:
 *                   $ref: '#/components/schemas/PaginationMeta'
 *       400:
 *         description: Invalid query parameter
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.get(
  '/',
  requireRole('REPORTER', 'APPROVER'),
  validate({ query: listReportsQuerySchema }),
  getAllReports,
);

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
