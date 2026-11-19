const express = require('express');
const router = express.Router();
const { protect } = require('../middleware/authMiddleware');
const { allowRoles } = require('../middleware/roleMiddleware');
const adminController = require('../controllers/adminController');

router.use(protect, allowRoles('admin'));
router.get('/drivers', adminController.getDrivers);
router.get('/drivers/pending', adminController.getPendingDrivers);
router.patch('/drivers/:id/verification', adminController.reviewDriver);

module.exports = router;
