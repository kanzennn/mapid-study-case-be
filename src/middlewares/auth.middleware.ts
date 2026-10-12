import { NextFunction, Request, Response } from 'express';
import { AppError } from '../utils/AppError';
import { verifyToken } from '../utils/jwt';

export const requireAuth = (req: Request, _res: Response, next: NextFunction) => {
  const header = req.headers.authorization;

  if (!header || !header.startsWith('Bearer ')) {
    return next(new AppError('Authentication required', 401));
  }

  const token = header.split(' ')[1];

  try {
    const payload = verifyToken(token);
    req.userId = payload.userId;
    next();
  } catch {
    next(new AppError('Invalid or expired token', 401));
  }
};
