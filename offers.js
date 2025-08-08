import { Router } from 'express';
import { v4 as uuid } from 'uuid';
import { db } from '../index.js';

export const router = Router();

// Provider submits offer
router.post('/', (req, res) => {
  const { token } = req.headers;
  const provider = db.users.find(u => u.id === token);
  if(!provider) return res.status(401).json({ error: 'unauthorized' });
  if(provider.role !== 'provider') return res.status(403).json({ error: 'not provider' });

  const { requestId, price, note, etaMinutes } = req.body;
  const r = db.requests.find(x => x.id === requestId);
  if(!r) return res.status(404).json({ error: 'request not found' });

  const offer = {
    id: uuid(),
    requestId,
    providerId: provider.id,
    price,
    note: note || '',
    etaMinutes: etaMinutes || 60,
    createdAt: new Date().toISOString(),
    status: 'sent' // sent | accepted | rejected
  };
  db.offers.push(offer);
  res.json(offer);
});

// Customer: list offers for a request
router.get('/by-request/:requestId', (req, res) => {
  const { requestId } = req.params;
  const list = db.offers.filter(o => o.requestId === requestId);
  res.json(list);
});

// Customer accepts an offer
router.post('/:id/accept', (req, res) => {
  const { token } = req.headers;
  const customer = db.users.find(u => u.id === token);
  if(!customer) return res.status(401).json({ error: 'unauthorized' });

  const offer = db.offers.find(o => o.id === req.params.id);
  if(!offer) return res.status(404).json({ error: 'offer not found' });
  const r = db.requests.find(x => x.id === offer.requestId);
  if(!r || r.customerId != customer.id) return res.status(403).json({ error: 'forbidden' });

  offer.status = 'accepted';
  r.status = 'assigned';
  r.assignedProviderId = offer.providerId;
  res.json({ ok: true, request: r, offer });
});
