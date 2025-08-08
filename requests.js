import { Router } from 'express';
import { v4 as uuid } from 'uuid';
import { db } from '../index.js';

export const router = Router();

// Create service request
router.post('/', (req, res) => {
  const { token } = req.headers;
  const user = db.users.find(u => u.id === token);
  if(!user) return res.status(401).json({ error: 'unauthorized' });

  const { categoryId, description, location, scheduledAt, attachments } = req.body;
  if(!categoryId || !description) return res.status(400).json({ error: 'categoryId & description required' });

  const r = {
    id: uuid(),
    customerId: user.id,
    categoryId,
    description,
    location: location || null,
    scheduledAt: scheduledAt || null,
    attachments: attachments || [],
    status: 'open', // open | assigned | in_progress | done | cancelled
    createdAt: new Date().toISOString()
  };
  db.requests.push(r);
  res.json(r);
});

// List requests (customer)
router.get('/my', (req, res) => {
  const { token } = req.headers;
  const user = db.users.find(u => u.id === token);
  if(!user) return res.status(401).json({ error: 'unauthorized' });
  const list = db.requests.filter(r => r.customerId === user.id);
  res.json(list);
});

// Public: get request by id
router.get('/:id', (req, res) => {
  const r = db.requests.find(x => x.id === req.params.id);
  if(!r) return res.status(404).json({ error: 'not found' });
  res.json(r);
});

// Provider: browse open requests by category
router.get('/', (req, res) => {
  const { categoryId } = req.query;
  let list = db.requests.filter(r => r.status === 'open');
  if(categoryId) list = list.filter(r => r.categoryId === categoryId);
  res.json(list);
});
