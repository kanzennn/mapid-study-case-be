import { NextFunction, Request, Response } from 'express';
import { userRepository } from '../repositories/user.repository';
import { AppError } from '../utils/AppError';
import { catchAsync } from '../utils/catchAsync';
import { verifyToken } from '../utils/jwt';

export const requireAuth = catchAsync(
  async (req: Request, _res: Response, next: NextFunction) => {
    const header = req.headers.authorization;

    if (!header || !header.startsWith('Bearer ')) {
      return next(new AppError('Authentication required', 401));
    }

    const token = header.split(' ')[1];

    let payload;
    try {
      payload = verifyToken(token);
    } catch {
      return next(new AppError('Invalid or expired token', 401));
    }

    const user = await userRepository.findById(payload.userId);
    if (!user) {
      return next(new AppError('User no longer exists', 401));
    }

    if (!user.is_active) {
      return next(new AppError('Your account has been deactivated', 401));
    }

    req.userId = user.id;
    req.userRole = user.role;
    next();
  },
);
