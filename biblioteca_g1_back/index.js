const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const http = require('http');
const socketIO = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = socketIO(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST", "PUT"]
  }
});

// Middlewares
app.use(cors());
app.use(bodyParser.json());

// Socket.IO connection handling
io.on('connection', (socket) => {
  console.log('Cliente conectado:', socket.id);

  socket.on('join-seccion', (seccionId) => {
    socket.join(`seccion-${seccionId}`);
    console.log(`Cliente ${socket.id} se unió a la sección ${seccionId}`);
  });

  socket.on('leave-seccion', (seccionId) => {
    socket.leave(`seccion-${seccionId}`);
    console.log(`Cliente ${socket.id} dejó la sección ${seccionId}`);
  });

  socket.on('disconnect', () => {
    console.log('Cliente desconectado:', socket.id);
  });
});

// Exportar io para usarlo en otros archivos
module.exports.io = io;

// Puerto para el servidor
const PORT = 3000;

// Iniciar servidor
server.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});

const db = require('./db');
const seccionesRoutes = require('./routes/secciones');
const asientosRoutes = require('./routes/asientos');

app.use('/secciones', seccionesRoutes);
app.use('/asientos', asientosRoutes);
