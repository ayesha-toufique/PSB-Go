const bcrypt = require('bcryptjs');
const User = require('../models/User');
const generateToken = require('../utils/generateToken');

const register = async ({ name, email, password, role, cnic, licenseNo }) => {
  const normalizedEmail = email.trim().toLowerCase();
  if (await User.findOne({ email: normalizedEmail })) {
    const error = new Error('An account with this email already exists.');
    error.statusCode = 409;
    throw error;
  }

  if (role === 'driver') {
    const [cnicExists, licenseExists] = await Promise.all([
      User.findOne({ 'driverDetails.cnic': cnic }),
      User.findOne({ 'driverDetails.licenseNo': licenseNo })
    ]);
    if (cnicExists) {
      const error = new Error('This CNIC is already registered.');
      error.statusCode = 409;
      throw error;
    }
    if (licenseExists) {
      const error = new Error('This driving licence number is already registered.');
      error.statusCode = 409;
      throw error;
    }
  }

  const hashedPassword = await bcrypt.hash(password, 12);
  const userData = {
    name: name.trim(),
    email: normalizedEmail,
    password: hashedPassword,
    role
  };

  if (role === 'driver') {
    userData.driverDetails = {
      cnic,
      licenseNo: licenseNo.trim(),
      verificationStatus: 'pending'
    };
  }

  const user = await User.create(userData);
  const token = generateToken(user);
  return { user, token };
};

const login = async ({ email, password }) => {
  const user = await User.findOne({ email: email.trim().toLowerCase() }).select('+password');
  if (!user || !(await bcrypt.compare(password, user.password))) {
    const error = new Error('Invalid email or password.');
    error.statusCode = 401;
    throw error;
  }
  if (!user.isActive) {
    const error = new Error('This account has been disabled. Contact the administrator.');
    error.statusCode = 403;
    throw error;
  }
  return { user, token: generateToken(user) };
};

module.exports = { register, login };
