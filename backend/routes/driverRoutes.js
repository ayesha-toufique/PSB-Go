const express = require('express');
const router = express.Router();
const { protect } = require('../middleware/authMiddleware');
const { allowRoles } = require('../middleware/roleMiddleware');
const { getVerificationStatus } = require('../controllers/driverController');

router.get('/verification-status', protect, allowRoles('driver'), getVerificationStatus);

module.exports = router;
