import { Router } from 'express';
import { v4 as uuid } from 'uuid';
import { db } from '../index.js';

export const router = Router();

// Mock OTP login
router.post('/otp/request', (req, res) => {
  const { phone } = req.body;
  if(!phone) return res.status(400).json({ error: 'phone required' });
  // Always "1234" in MVP
  return res.json({ sent: true, code: '1234' });
});

router.post('/otp/verify', (req, res) => {
  const { phone, code, role } = req.body; // role: 'customer' | 'provider'
  if(code !== '1234') return res.status(400).json({ error: 'invalid code' });
  let user = db.users.find(u => u.phone === phone);
  if(!user) {
    user = { id: uuid(), phone, role: role || 'customer', name: 'مستخدم' };
    db.users.push(user);
  }
  return res.json({ token: user.id, user });
});
