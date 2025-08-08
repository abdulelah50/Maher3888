import { Router } from 'express';
import { db } from '../index.js';

export const router = Router();

router.get('/', (req, res) => {
  res.json(db.categories);
});
