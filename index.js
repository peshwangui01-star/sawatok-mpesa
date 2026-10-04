const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 10000;

// --- YOUR DARAJA CREDENTIALS - YOU WILL PUT IN RENDER ENV ---
// Leave empty here, we will set in Render dashboard

app.get('/', (req, res) => {
  res.send('SawaTok M-Pesa API is LIVE! Use /stkpush');
});

// Daraja Token
async function getToken() {
  const consumerKey = process.env.MPESA_CONSUMER_KEY;
  const consumerSecret = process.env.MPESA_CONSUMER_SECRET;
  const auth = Buffer.from(`${consumerKey}:${consumerSecret}`).toString('base64');
  
  const response = await axios.get(
    'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials',
    { headers: { Authorization: `Basic ${auth}` } }
  );
  return response.data.access_token;
}

// STK Push
app.post('/stkpush', async (req, res) => {
  try {
    const { phone, amount } = req.body;
    if (!phone || !amount) return res.status(400).json({ error: 'phone and amount required' });

    const token = await getToken();
    const timestamp = new Date().toISOString().replace(/[^0-9]/g, '').slice(0, -3);
    const shortcode = process.env.MPESA_SHORTCODE; // e.g 174379
    const passkey = process.env.MPESA_PASSKEY;
    const password = Buffer.from(shortcode + passkey + timestamp).toString('base64');

    let formattedPhone = phone.replace(/^0/, '254').replace(/\+/, '');

    const payload = {
      BusinessShortCode: shortcode,
      Password: password,
      Timestamp: timestamp,
      TransactionType: 'CustomerPayBillOnline',
      Amount: amount,
      PartyA: formattedPhone,
      PartyB: shortcode,
      PhoneNumber: formattedPhone,
      CallBackURL: process.env.CALLBACK_URL,
      AccountReference: 'SawaTok',
      TransactionDesc: 'SawaTok Payment'
    };

    const response = await axios.post(
      'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest',
      payload,
      { headers: { Authorization: `Bearer ${token}` } }
    );

    res.json(response.data);
  } catch (error) {
    console.error(error.response?.data || error.message);
    res.status(500).json({ error: error.response?.data || error.message });
  }
});

// Callback
app.post('/callback', (req, res) => {
  console.log('M-Pesa Callback:', JSON.stringify(req.body));
  res.json({ ResultCode: 0, ResultDesc: 'Success' });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});
