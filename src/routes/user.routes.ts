import { Router } from 'express';
import { deleteUser, getAllUsers, getUserById, updateUser } from '../controllers/user.controller';
import { requireAuth } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { updateUserSchema, userIdParamSchema } from '../validations/user.validation';

const router = Router();

router.use(requireAuth);

router.get('/', getAllUsers);
router.get('/:id', validate({ params: userIdParamSchema }), getUserById);
router.patch(
  '/:id',
  validate({ params: userIdParamSchema, body: updateUserSchema }),
  updateUser,
);
router.delete('/:id', validate({ params: userIdParamSchema }), deleteUser);

export default router;
