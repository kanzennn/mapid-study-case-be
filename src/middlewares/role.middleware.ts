import { USER_ROLE } from '@prisma/client';
import { NextFunction, Request, Response } from 'express';
import { AppError } from '../utils/AppError';

export const requireRole = (...roles: USER_ROLE[]) => {
  return (req: Request, _res: Response, next: NextFunction) => {
    if (!req.userRole || !roles.includes(req.userRole)) {
      return next(new AppError('You do not have permission to perform this action', 403));
    }
    next();
  };
};
