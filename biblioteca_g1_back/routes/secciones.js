const express = require('express');
const router = express.Router();
const db = require('../db');

// Obtener todas las secciones
router.get('/', (req, res) => {
  db.query('SELECT * FROM secciones', (err, results) => {
    if (err) {
      res.status(500).json({ error: 'Error al obtener las secciones' });
      return;
    }
    res.json(results);
  });
});

// Agregar una nueva sección
router.post('/', (req, res) => {
  const { nombre } = req.body;
  db.query('INSERT INTO secciones (nombre) VALUES (?)', [nombre], (err, results) => {
    if (err) {
      res.status(500).json({ error: 'Error al agregar la sección' });
      return;
    }
    res.json({ id: results.insertId, nombre });
  });
});

module.exports = router;
