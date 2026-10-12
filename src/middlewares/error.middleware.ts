import { NextFunction, Request, Response } from 'express';
import { ZodError } from 'zod';
import { AppError } from '../utils/AppError';
import { logger } from '../config/logger';
import { env } from '../config/env';
import { sendError } from '../utils/response';

export const notFoundHandler = (req: Request, _res: Response, next: NextFunction) => {
  next(new AppError(`Route not found: ${req.method} ${req.originalUrl}`, 404));
};

export const errorHandler = (
  err: unknown,
  _req: Request,
  res: Response,
  _next: NextFunction,
) => {
  if (err instanceof ZodError) {
    return sendError(res, 'Validation error', 400, err.flatten().fieldErrors);
  }

  if (err instanceof AppError) {
    return sendError(res, err.message, err.statusCode);
  }

  logger.error(err);

  return sendError(
    res,
    env.NODE_ENV === 'production' ? 'Something went wrong' : (err as Error).message,
    500,
  );
};
