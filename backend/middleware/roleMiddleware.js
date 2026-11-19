const allowRoles = (...roles) => (req, res, next) => {
  if (!req.user || !roles.includes(req.user.role)) {
    return res.status(403).json({ message: 'You do not have permission to perform this action.' });
  }
  next();
};

const requireApprovedDriver = (req, res, next) => {
  if (req.user?.role !== 'driver') {
    return res.status(403).json({ message: 'Driver access only.' });
  }
  if (req.user.driverDetails?.verificationStatus !== 'approved') {
    return res.status(403).json({
      message: 'Your driver account is awaiting admin verification.',
      verificationStatus: req.user.driverDetails?.verificationStatus || 'pending'
    });
  }
  next();
};

module.exports = { allowRoles, requireApprovedDriver };
