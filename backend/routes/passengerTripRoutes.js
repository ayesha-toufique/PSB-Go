
const express = require('express');
const router = express.Router();

const { protect } = require('../middleware/authMiddleware');
const { allowRoles } = require('../middleware/roleMiddleware');

const controller = require(
  '../controllers/passengerTripController'
);

// Every endpoint requires passenger login
router.use(protect, allowRoles('passenger'));

router.post(
  '/start',
  controller.startPassengerTrip
);

router.get(
  '/active',
  controller.getActivePassengerTrip
);

router.get(
  '/history',
  controller.getPassengerTripHistory
);

router.patch(
  '/:id/end',
  controller.endPassengerTrip
);

module.exports = router;
