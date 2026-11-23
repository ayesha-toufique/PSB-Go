
const express = require('express');
const router = express.Router();

const { protect } = require('../middleware/authMiddleware');
const {
  allowRoles,
  requireApprovedDriver
} = require('../middleware/roleMiddleware');

const driverController = require('../controllers/driverController');

// All driver endpoints require login and driver role
router.use(protect, allowRoles('driver'));

// Verification status can be checked before approval
router.get(
  '/verification-status',
  driverController.getVerificationStatus
);

// All remaining operational endpoints require admin approval
router.use(requireApprovedDriver);

// Assigned buses
router.get(
  '/my-buses',
  driverController.getMyBuses
);

// Current ongoing journey
router.get(
  '/active-trip',
  driverController.getActiveTrip
);

// Start journey
router.post(
  '/start-journey',
  driverController.startJourney
);

// End journey
router.patch(
  '/end-journey/:tripId',
  driverController.endJourney
);

module.exports = router;
