const express = require('express');
const router = express.Router();
const { protect } = require('../middleware/authMiddleware');
const { allowRoles } = require('../middleware/roleMiddleware');
const passengerController = require('../controllers/passengerController');

router.use(protect, allowRoles('passenger'));
router.get('/dashboard', passengerController.getDashboardData);
router.get('/live-locations', passengerController.getLiveLocations);

module.exports = router;
