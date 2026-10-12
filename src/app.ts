import cors from 'cors';
import express, { Application } from 'express';
import helmet from 'helmet';
import { pinoHttp } from 'pino-http';
import { logger } from './config/logger';
import { errorHandler, notFoundHandler } from './middlewares/error.middleware';
import routes from './routes';

const app: Application = express();

app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(pinoHttp({ logger }));

app.get('/health', (_req, res) => {
  res.status(200).json({ status: 'ok' });
});

app.use('/api/v1', routes);

app.use(notFoundHandler);
app.use(errorHandler);

export default app;
