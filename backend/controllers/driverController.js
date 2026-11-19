const User = require('../models/User');

exports.getVerificationStatus = async (req, res) => {
  res.json({
    verificationStatus: req.user.driverDetails?.verificationStatus || 'pending',
    rejectionReason: req.user.driverDetails?.rejectionReason || '',
    verifiedAt: req.user.driverDetails?.verifiedAt || null
  });
};
