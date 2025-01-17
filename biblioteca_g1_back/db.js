const mysql = require('mysql2');

const connection = mysql.createConnection({
  host: 'localhost', // Cambia si usas otro host
  user: 'root', // Tu usuario de MySQL
  password: '123', // Tu contraseña
  database: 'biblioteca', // El nombre de tu base de datos
});

connection.connect((err) => {
  if (err) {
    console.error('Error al conectar a MySQL:', err);
    process.exit(1);
  }
  console.log('Conectado a MySQL');
});

module.exports = connection;
