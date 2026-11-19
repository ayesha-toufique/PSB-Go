const express = require('express');
const router = express.Router();
const tripController = require('../controllers/tripController');
const { protect } = require('../middleware/authMiddleware');
const { allowRoles, requireApprovedDriver } = require('../middleware/roleMiddleware');

router.get('/', protect, allowRoles('admin', 'driver'), tripController.getTrips);
router.post('/', protect, allowRoles('admin'), tripController.createTrip);
router.patch('/:id/status', protect, allowRoles('admin', 'driver'), (req, res, next) => {
  if (req.user.role === 'driver' && req.user.driverDetails?.verificationStatus !== 'approved') {
    return res.status(403).json({ message: 'Driver verification is required before trip operations.' });
  }
  next();
}, tripController.updateTripStatus);

module.exports = router;
