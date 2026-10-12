import { Request, Response } from 'express';
import { authService } from '../services/auth.service';
import { userService } from '../services/user.service';
import { catchAsync } from '../utils/catchAsync';
import { sendSuccess } from '../utils/response';

export const login = catchAsync(async (req: Request, res: Response) => {
  const result = await authService.login(req.body);
  sendSuccess(res, result);
});

export const getProfile = catchAsync(async (req: Request, res: Response) => {
  const user = await userService.getById(req.userId as string);
  sendSuccess(res, user);
});

export const updateProfile = catchAsync(async (req: Request, res: Response) => {
  const user = await authService.updateProfile(req.userId as string, req.body);
  sendSuccess(res, user);
});

export const updatePassword = catchAsync(async (req: Request, res: Response) => {
  await authService.updatePassword(req.userId as string, req.body);
  sendSuccess(res, null);
});
