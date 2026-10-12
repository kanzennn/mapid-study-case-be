import { Response } from 'express';

export const sendSuccess = (res: Response, data: unknown, statusCode = 200) => {
  res.status(statusCode).json({ status: 'success', data });
};

export const sendError = (
  res: Response,
  message: string,
  statusCode = 500,
  errors?: Record<string, unknown>,
) => {
  res.status(statusCode).json({
    status: statusCode >= 500 ? 'error' : 'fail',
    message,
    ...(errors ? { errors } : {}),
  });
};
