const express = require('express');
const router = express.Router();
const db = require('../db');
const { io } = require('../index');

// Mapa para almacenar los temporizadores de reserva
const reservationTimers = new Map();

// Función para liberar un asiento después del tiempo límite
const liberarAsientoAutomaticamente = async (asientoId, seccionId) => {
  try {
    const [asiento] = await db.promise().query(
      'SELECT estaReservado FROM asientos WHERE id = ?',
      [asientoId]
    );

    if (asiento[0].estaReservado) {
      await db.promise().query(
        'UPDATE asientos SET estaReservado = FALSE WHERE id = ?',
        [asientoId]
      );

      io.to(`seccion-${seccionId}`).emit('asiento-actualizado', {
        asientoId,
        estaReservado: false,
        mensaje: 'Reserva expirada'
      });
    }
  } catch (error) {
    console.error('Error al liberar asiento:', error);
  }
};

// Obtener asientos de una sección
router.get('/:seccionId', async (req, res) => {
  const { seccionId } = req.params;
  try {
    const [asientos] = await db.promise().query(
      'SELECT * FROM asientos WHERE seccion_id = ?',
      [seccionId]
    );
    res.json(asientos);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener los asientos' });
  }
});

// Reservar un asiento
router.put('/:id/reservar', async (req, res) => {
  const { id } = req.params;
  const { seccionId } = req.body;

  try {
    // Verificar si el asiento ya está reservado
    const [asiento] = await db.promise().query(
      'SELECT estaReservado FROM asientos WHERE id = ?',
      [id]
    );

    if (asiento[0].estaReservado) {
      return res.status(400).json({ error: 'El asiento ya está reservado' });
    }

    // Realizar la reserva
    await db.promise().query(
      'UPDATE asientos SET estaReservado = TRUE WHERE id = ?',
      [id]
    );

    // Cancelar el temporizador existente si hay uno
    if (reservationTimers.has(id)) {
      clearTimeout(reservationTimers.get(id));
    }

    // Establecer nuevo temporizador
    const timer = setTimeout(
      () => liberarAsientoAutomaticamente(id, seccionId),
      5 * 60 * 1000 // 5 minutos
    );
    reservationTimers.set(id, timer);

    // Notificar a todos los clientes en la sección
    io.to(`seccion-${seccionId}`).emit('asiento-actualizado', {
      asientoId: id,
      estaReservado: true,
      mensaje: 'Asiento reservado'
    });

    res.json({ message: 'Asiento reservado exitosamente' });
  } catch (error) {
    res.status(500).json({ error: 'Error al reservar el asiento' });
  }
});

// Confirmar una reserva
router.put('/:id/confirmar', async (req, res) => {
  const { id } = req.params;
  const { seccionId } = req.body;

  try {
    // Eliminar el temporizador si existe
    if (reservationTimers.has(id)) {
      clearTimeout(reservationTimers.get(id));
      reservationTimers.delete(id);
    }

    io.to(`seccion-${seccionId}`).emit('asiento-actualizado', {
      asientoId: id,
      estaReservado: true,
      confirmado: true,
      mensaje: 'Reserva confirmada'
    });

    res.json({ message: 'Reserva confirmada exitosamente' });
  } catch (error) {
    res.status(500).json({ error: 'Error al confirmar la reserva' });
  }
});

// Cancelar una reserva
router.put('/:id/cancelar', async (req, res) => {
  const { id } = req.params;
  const { seccionId } = req.body;

  try {
    await db.promise().query(
      'UPDATE asientos SET estaReservado = FALSE WHERE id = ?',
      [id]
    );

    // Eliminar el temporizador si existe
    if (reservationTimers.has(id)) {
      clearTimeout(reservationTimers.get(id));
      reservationTimers.delete(id);
    }

    io.to(`seccion-${seccionId}`).emit('asiento-actualizado', {
      asientoId: id,
      estaReservado: false,
      mensaje: 'Reserva cancelada'
    });

    res.json({ message: 'Reserva cancelada exitosamente' });
  } catch (error) {
    res.status(500).json({ error: 'Error al cancelar la reserva' });
  }
});

module.exports = router;
