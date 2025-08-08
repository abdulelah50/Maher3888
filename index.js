import express from 'express';
import cors from 'cors';
import morgan from 'morgan';
import { router as authRouter } from './routes/auth.js';
import { router as categoriesRouter } from './routes/categories.js';
import { router as requestsRouter } from './routes/requests.js';
import { router as offersRouter } from './routes/offers.js';

const app = express();
app.use(cors());
app.use(express.json({limit: '10mb'}));
app.use(morgan('dev'));

// in-memory data store (MVP)
export const db = {
  users: [],
  providers: [],
  categories: [
    { id: '1', name: 'سباكة' },
    { id: '2', name: 'كهرباء' },
    { id: '3', name: 'نجارة' },
    { id: '4', name: 'تكييف' },
    { id: '5', name: 'تنظيف' }
  ],
  requests: [],
  offers: [],
  messages: []
};

app.get('/', (req, res) => res.json({ ok: true, name: 'Maher API', version: '0.1.0' }));

app.use('/auth', authRouter);
app.use('/categories', categoriesRouter);
app.use('/requests', requestsRouter);
app.use('/offers', offersRouter);

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => console.log('Maher API running on port', PORT));
