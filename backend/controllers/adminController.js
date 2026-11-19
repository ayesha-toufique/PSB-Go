const User = require('../models/User');

exports.getPendingDrivers = async (req, res, next) => {
  try {
    const drivers = await User.find({
      role: 'driver',
      'driverDetails.verificationStatus': 'pending'
    }).select('-password').sort({ createdAt: 1 });
    res.json({ count: drivers.length, drivers });
  } catch (error) { next(error); }
};

exports.reviewDriver = async (req, res, next) => {
  try {
    const { status, rejectionReason } = req.body;
    if (!['approved', 'rejected'].includes(status)) {
      return res.status(400).json({ message: 'Status must be approved or rejected.' });
    }
    if (status === 'rejected' && !String(rejectionReason || '').trim()) {
      return res.status(400).json({ message: 'Please provide a rejection reason.' });
    }

    const driver = await User.findOne({ _id: req.params.id, role: 'driver' });
    if (!driver) return res.status(404).json({ message: 'Driver not found.' });

    driver.driverDetails.verificationStatus = status;
    driver.driverDetails.verifiedBy = req.user._id;
    driver.driverDetails.verifiedAt = new Date();
    driver.driverDetails.rejectionReason = status === 'rejected' ? rejectionReason.trim() : '';
    await driver.save();

    res.json({
      message: `Driver ${status} successfully.`,
      driver: await User.findById(driver._id).select('-password')
    });
  } catch (error) { next(error); }
};

exports.getDrivers = async (req, res, next) => {
  try {
    const drivers = await User.find({ role: 'driver' }).select('-password').sort({ createdAt: -1 });
    res.json({ count: drivers.length, drivers });
  } catch (error) { next(error); }
};
