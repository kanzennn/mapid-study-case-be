import { NextFunction, Request, Response } from 'express';

type AsyncHandler<Req extends Request = Request> = (
  req: Req,
  res: Response,
  next: NextFunction,
) => Promise<unknown>;

export const catchAsync = <Req extends Request = Request>(fn: AsyncHandler<Req>) => {
  return (req: Req, res: Response, next: NextFunction) => {
    fn(req, res, next).catch(next);
  };
};
