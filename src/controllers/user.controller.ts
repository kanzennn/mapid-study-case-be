import { Request, Response } from 'express';
import { userService } from '../services/user.service';
import { catchAsync } from '../utils/catchAsync';
import { sendSuccess } from '../utils/response';

export const getAllUsers = catchAsync(async (_req: Request, res: Response) => {
  const users = await userService.getAll();
  sendSuccess(res, users);
});

export const getUserById = catchAsync(
  async (req: Request<{ id: string }>, res: Response) => {
    const user = await userService.getById(req.params.id);
    sendSuccess(res, user);
  },
);

export const createUser = catchAsync(async (req: Request, res: Response) => {
  const user = await userService.create(req.body, req.userId as string);
  sendSuccess(res, user, 201);
});

export const updateUser = catchAsync(
  async (req: Request<{ id: string }>, res: Response) => {
    const user = await userService.update(req.params.id, req.body);
    sendSuccess(res, user);
  },
);

export const deleteUser = catchAsync(
  async (req: Request<{ id: string }>, res: Response) => {
    await userService.remove(req.params.id);
    res.status(204).send();
  },
);

export const activateUser = catchAsync(
  async (req: Request<{ id: string }>, res: Response) => {
    const user = await userService.setActiveStatus(req.params.id, true);
    sendSuccess(res, user);
  },
);

export const deactivateUser = catchAsync(
  async (req: Request<{ id: string }>, res: Response) => {
    const user = await userService.setActiveStatus(req.params.id, false);
    sendSuccess(res, user);
  },
);
