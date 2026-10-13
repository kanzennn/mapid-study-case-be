import { NextFunction, Request, Response } from 'express';
import { ZodType } from 'zod';

interface ValidationSchemas {
  body?: ZodType;
  params?: ZodType;
  query?: ZodType;
}

export const validate = (schemas: ValidationSchemas) => {
  return (req: Request, _res: Response, next: NextFunction) => {
    if (schemas.body) req.body = schemas.body.parse(req.body);
    if (schemas.params) req.params = schemas.params.parse(req.params) as typeof req.params;
    if (schemas.query) {
      // Express 5 exposes `req.query` as a read-only getter, so it can't be reassigned.
      Object.defineProperty(req, 'query', {
        value: schemas.query.parse(req.query),
        writable: true,
        configurable: true,
        enumerable: true,
      });
    }
    next();
  };
};
