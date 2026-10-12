import { Request, Response } from 'express';
import { authService } from '../services/auth.service';
import { catchAsync } from '../utils/catchAsync';
import { sendSuccess } from '../utils/response';

export const login = catchAsync(async (req: Request, res: Response) => {
  const result = await authService.login(req.body);
  sendSuccess(res, result);
});
