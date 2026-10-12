import { NextFunction, Request, Response } from 'express';
import { logger } from '../config/logger';
import { userRepository } from '../repositories/user.repository';
import { AppError } from '../utils/AppError';
import { catchAsync } from '../utils/catchAsync';
import { extractBearerToken, verifyToken } from '../utils/jwt';

export const requireAuth = catchAsync(
  async (req: Request, _res: Response, next: NextFunction) => {
    const token = extractBearerToken(req.headers.authorization);

    if (!token) {
      return next(new AppError('Authentication required', 401));
    }

    let payload;
    try {
      payload = verifyToken(token);
    } catch {
      logger.warn({ event: 'token_verification_failed' }, 'Rejected invalid or expired token');
      return next(new AppError('Invalid or expired token', 401));
    }

    const user = await userRepository.findById(payload.userId);
    if (!user) {
      logger.warn({ event: 'token_verification_failed', userId: payload.userId, reason: 'user_not_found' }, 'Rejected token for non-existent user');
      return next(new AppError('User no longer exists', 401));
    }

    if (!user.is_active) {
      logger.warn({ event: 'token_verification_failed', userId: user.id, reason: 'inactive' }, 'Rejected token for deactivated account');
      return next(new AppError('Your account has been deactivated', 401));
    }

    req.userId = user.id;
    req.userRole = user.role;
    next();
  },
);
