import { Router } from 'express';
import {
  activateUser,
  createUser,
  deactivateUser,
  deleteUser,
  getAllUsers,
  getUserById,
  updateUser,
} from '../controllers/user.controller';
import { requireAuth } from '../middlewares/auth.middleware';
import { requireRole } from '../middlewares/role.middleware';
import { validate } from '../middlewares/validate.middleware';
import {
  createUserSchema,
  listUsersQuerySchema,
  updateUserSchema,
  userIdParamSchema,
} from '../validations/user.validation';

const router = Router();

router.use(requireAuth, requireRole('ADMIN'));

/**
 * @openapi
 * /users:
 *   get:
 *     tags: [Users]
 *     summary: Get all users (with search, filter, sort & optional pagination)
 *     parameters:
 *       - in: query
 *         name: search
 *         description: Case-insensitive match on name or email
 *         schema: { type: string, example: reporter }
 *       - in: query
 *         name: role
 *         description: One or more roles, comma separated (or repeat the param)
 *         schema: { type: string, example: 'REPORTER,APPROVER' }
 *       - in: query
 *         name: is_active
 *         schema: { type: boolean }
 *       - in: query
 *         name: created_from
 *         description: Inclusive lower bound. Date-only values are read as UTC; send a full ISO date-time with offset (e.g. 2026-10-13T00:00:00+07:00) for local time.
 *         schema: { type: string, format: date, example: '2026-10-01' }
 *       - in: query
 *         name: created_to
 *         description: Inclusive upper bound. A date without time covers the whole day.
 *         schema: { type: string, format: date, example: '2026-10-31' }
 *       - in: query
 *         name: sort
 *         description: Comma separated fields, prefix with `-` for descending. Allowed - name, email, role, is_active, created_at, updated_at. Default `-created_at`.
 *         schema: { type: string, example: '-created_at,name' }
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
 *         description: List of users. `meta` is only present when paginated.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status: { type: string, example: success }
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/User'
 *                 meta:
 *                   $ref: '#/components/schemas/PaginationMeta'
 *       400:
 *         description: Invalid query parameter
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       401:
 *         description: Authentication required
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       403:
 *         description: Forbidden, ADMIN role required
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.get('/', validate({ query: listUsersQuerySchema }), getAllUsers);

/**
 * @openapi
 * /users:
 *   post:
 *     tags: [Users]
 *     summary: Create a new user
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [name, email, password]
 *             properties:
 *               name: { type: string, example: Jane Doe }
 *               email: { type: string, format: email, example: jane@example.com }
 *               password: { type: string, format: password, example: password123 }
 *               role: { type: string, enum: [ADMIN, APPROVER, REPORTER], example: REPORTER }
 *     responses:
 *       201:
 *         description: User created
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status: { type: string, example: success }
 *                 data:
 *                   $ref: '#/components/schemas/User'
 *       400:
 *         description: Validation error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       403:
 *         description: Forbidden, ADMIN role required
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       409:
 *         description: Email is already in use
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.post('/', validate({ body: createUserSchema }), createUser);

/**
 * @openapi
 * /users/{id}:
 *   get:
 *     tags: [Users]
 *     summary: Get a user by id
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: string, format: uuid }
 *     responses:
 *       200:
 *         description: User found
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status: { type: string, example: success }
 *                 data:
 *                   $ref: '#/components/schemas/User'
 *       403:
 *         description: Forbidden, ADMIN role required
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       404:
 *         description: User not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.get('/:id', validate({ params: userIdParamSchema }), getUserById);

/**
 * @openapi
 * /users/{id}:
 *   patch:
 *     tags: [Users]
 *     summary: Update a user by id
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: string, format: uuid }
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/UpdateUserRequest'
 *     responses:
 *       200:
 *         description: User updated
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status: { type: string, example: success }
 *                 data:
 *                   $ref: '#/components/schemas/User'
 *       400:
 *         description: Cannot change your own role
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       403:
 *         description: Forbidden, ADMIN role required
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       404:
 *         description: User not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.patch(
  '/:id',
  validate({ params: userIdParamSchema, body: updateUserSchema }),
  updateUser,
);

/**
 * @openapi
 * /users/{id}:
 *   delete:
 *     tags: [Users]
 *     summary: Delete a user by id
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: string, format: uuid }
 *     responses:
 *       204:
 *         description: User deleted
 *       400:
 *         description: Cannot delete your own account
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       403:
 *         description: Forbidden, ADMIN role required
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       404:
 *         description: User not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.delete('/:id', validate({ params: userIdParamSchema }), deleteUser);

/**
 * @openapi
 * /users/{id}/activate:
 *   patch:
 *     tags: [Users]
 *     summary: Activate a user by id
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: string, format: uuid }
 *     responses:
 *       200:
 *         description: User activated
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status: { type: string, example: success }
 *                 data:
 *                   $ref: '#/components/schemas/User'
 *       400:
 *         description: Cannot change the active status of your own account
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       403:
 *         description: Forbidden, ADMIN role required
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       404:
 *         description: User not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.patch('/:id/activate', validate({ params: userIdParamSchema }), activateUser);

/**
 * @openapi
 * /users/{id}/deactivate:
 *   patch:
 *     tags: [Users]
 *     summary: Deactivate a user by id
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: string, format: uuid }
 *     responses:
 *       200:
 *         description: User deactivated
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status: { type: string, example: success }
 *                 data:
 *                   $ref: '#/components/schemas/User'
 *       400:
 *         description: Cannot change the active status of your own account
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       403:
 *         description: Forbidden, ADMIN role required
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       404:
 *         description: User not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.patch('/:id/deactivate', validate({ params: userIdParamSchema }), deactivateUser);

export default router;
