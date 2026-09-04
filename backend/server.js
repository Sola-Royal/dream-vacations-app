const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const axios = require('axios');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

const COUNTRIES_API_BASE_URL = process.env.COUNTRIES_API_BASE_URL || 'https://api.restcountries.com/countries/v5';
const COUNTRIES_API_KEY = process.env.COUNTRIES_API_KEY;

app.get('/api/destinations', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM destinations ORDER BY id DESC');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/api/destinations', async (req, res) => {
  const { country } = req.body;
  try {
    const response = await axios.get(
      `${COUNTRIES_API_BASE_URL}/names.common/${encodeURIComponent(country)}`,
      { headers: { Authorization: `Bearer ${COUNTRIES_API_KEY}` } }
    );
    const countryInfo = response.data.data.objects[0];

    const result = await pool.query(
      'INSERT INTO destinations (country, capital, population, region) VALUES ($1, $2, $3, $4) RETURNING *',
      [
        countryInfo.names.common,
        countryInfo.capitals?.[0]?.name || null,
        countryInfo.population,
        countryInfo.region,
      ]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.delete('/api/destinations/:id', async (req, res) => {
  const { id } = req.params;
  try {
    await pool.query('DELETE FROM destinations WHERE id = $1', [id]);
    res.status(204).send();
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});