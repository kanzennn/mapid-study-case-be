import { Router } from 'express';
import authRoutes from './auth.routes';
import userRoutes from './user.routes';
import reportRoutes from './report.routes';

const router = Router();

router.use('/auth', authRoutes);
router.use('/users', userRoutes);
router.use('/reports', reportRoutes)

export default router;
