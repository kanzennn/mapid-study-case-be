import { Request, Response } from 'express';
import { userService } from '../services/user.service';
import { catchAsync } from '../utils/catchAsync';
import { sendSuccess } from '../utils/response';
import { ListUsersQuery } from '../validations/user.validation';

export const getAllUsers = catchAsync(async (req: Request, res: Response) => {
  const { users, meta } = await userService.getAll(req.query as ListUsersQuery);
  sendSuccess(res, users, 200, meta);
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
    const user = await userService.update(req.params.id, req.body, req.userId as string);
    sendSuccess(res, user);
  },
);

export const deleteUser = catchAsync(
  async (req: Request<{ id: string }>, res: Response) => {
    await userService.remove(req.params.id, req.userId as string);
    res.status(204).send();
  },
);

export const activateUser = catchAsync(
  async (req: Request<{ id: string }>, res: Response) => {
    const user = await userService.setActiveStatus(
      req.params.id,
      true,
      req.userId as string,
    );
    sendSuccess(res, user);
  },
);

export const deactivateUser = catchAsync(
  async (req: Request<{ id: string }>, res: Response) => {
    const user = await userService.setActiveStatus(
      req.params.id,
      false,
      req.userId as string,
    );
    sendSuccess(res, user);
  },
);
