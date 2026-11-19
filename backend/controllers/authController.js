const authService = require('../services/authService');

const publicUser = (user) => ({
  _id: user._id,
  name: user.name,
  email: user.email,
  role: user.role,
  driverDetails: user.role === 'driver' ? user.driverDetails : undefined
});

exports.registerUser = async (req, res, next) => {
  try {
    const { name, email, password, role, cnic, licenseNo } = req.body;

    // Public signup intentionally supports passengers and drivers only.
    if (!['passenger', 'driver'].includes(role || 'passenger')) {
      return res.status(400).json({ message: 'Role must be passenger or driver. Admin accounts are created privately.' });
    }

    const normalizedRole = role || 'passenger';
    if (normalizedRole === 'driver' && (!cnic || !licenseNo)) {
      return res.status(400).json({ message: 'CNIC and driving licence number are required for driver registration.' });
    }

    const result = await authService.register({
      name, email, password, role: normalizedRole, cnic, licenseNo
    });

    return res.status(201).json({
      message: normalizedRole === 'driver'
        ? 'Driver registration submitted. Your account is pending admin verification.'
        : 'Passenger account created successfully.',
      token: result.token,
      user: publicUser(result.user)
    });
  } catch (error) {
    next(error);
  }
};

exports.loginUser = async (req, res, next) => {
  try {
    const result = await authService.login(req.body);
    const user = result.user;
    return res.json({
      message: 'Login successful.',
      token: result.token,
      user: publicUser(user),
      nextStep: user.role === 'driver' && user.driverDetails?.verificationStatus !== 'approved'
        ? 'driver_verification'
        : user.role === 'admin' ? 'admin_dashboard' : user.role === 'driver' ? 'driver_dashboard' : 'passenger_home'
    });
  } catch (error) {
    next(error);
  }
};

exports.getMe = async (req, res) => {
  res.json({ user: publicUser(req.user) });
};
