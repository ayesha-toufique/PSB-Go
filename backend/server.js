require('dotenv').config();

const express = require('express');
const cors = require('cors');
const http = require('http');
const jwt = require('jsonwebtoken');
const { Server } = require('socket.io');

const connectDB = require('./config/db');
const User = require('./models/User');
const { notFound, errorHandler } = require('./middleware/errorMiddleware');

const authRoutes = require('./routes/authRoutes');
const adminRoutes = require('./routes/adminRoutes');
const driverRoutes = require('./routes/driverRoutes');
const passengerRoutes = require('./routes/passengerRoutes');
const busRoutes = require('./routes/busRoutes');
const routeRoutes = require('./routes/routeRoutes');
const stopRoutes = require('./routes/stopRoutes');
const tripRoutes = require('./routes/tripRoutes');
const announcementRoutes = require('./routes/announcementRoutes');
const liveLocationRoutes = require('./routes/liveLocationRoutes');

const app = express();
const server = http.createServer(app);

const allowedOrigins = (process.env.CLIENT_URL || 'http://localhost:5173')
  .split(',')
  .map(origin => origin.trim());

app.use(cors({
  origin(origin, callback) {
    // Allow requests without an Origin header (Postman/mobile)
    if (!origin) {
      return callback(null, true);
    }

    // Allow configured origins
    if (allowedOrigins.includes('*') || allowedOrigins.includes(origin)) {
      return callback(null, true);
    }

    // Allow localhost with any port during development
    const isLocalhost =
      /^http:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/.test(origin);

    if (process.env.NODE_ENV !== 'production' && isLocalhost) {
      return callback(null, true);
    }

    return callback(new Error(`Not allowed by CORS: ${origin}`));
  },
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: true }));

const io = new Server(server, {
  cors: {
    origin: allowedOrigins.includes('*') ? '*' : allowedOrigins,
    methods: ['GET', 'POST']
  }
});
app.set('io', io);

// Socket.IO authentication: clients send { auth: { token } }.
io.use(async (socket, next) => {
  try {
    const token = socket.handshake.auth?.token;
    if (!token || !process.env.JWT_SECRET) return next(new Error('Unauthorized'));
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await User.findById(decoded.userId).select('-password');
    if (!user || !user.isActive) return next(new Error('Unauthorized'));
    socket.user = user;
    next();
  } catch (error) {
    next(new Error('Unauthorized'));
  }
});

io.on('connection', socket => {
  socket.on('joinRoute', async routeId => {
    if (typeof routeId === 'string' && routeId.length <= 100) {
      socket.join(routeId);
    }
  });

  // Location writes are handled by authenticated REST endpoint.
  // Socket clients may only subscribe to route rooms.
});

app.get('/', (req, res) => {
  res.json({ message: 'PSB Go API is running.', status: 'ok' });
});
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', database: require('mongoose').connection.readyState === 1 ? 'connected' : 'disconnected' });
});

app.use('/api/auth', authRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/driver', driverRoutes);
app.use('/api/passenger', passengerRoutes);
app.use('/api/buses', busRoutes);
app.use('/api/routes', routeRoutes);
app.use('/api/stops', stopRoutes);
app.use('/api/trips', tripRoutes);
app.use('/api/announcements', announcementRoutes);
app.use('/api/live-location', liveLocationRoutes);

app.use(notFound);
app.use(errorHandler);

const PORT = Number(process.env.PORT) || 5005;

const startServer = async () => {
  try {
    await connectDB();
    server.listen(PORT, '0.0.0.0', () => {
      console.log(`PSB Go backend listening on port ${PORT}`);
    });
  } catch (error) {
    console.error(`Backend startup failed: ${error.message}`);
    process.exit(1);
  }
};

startServer();

module.exports = { app, server };
