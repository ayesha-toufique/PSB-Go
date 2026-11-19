const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const { protect } = require('../middleware/authMiddleware');
const { allowRoles } = require('../middleware/roleMiddleware');
const validateRequest = require('../middleware/validateRequest');
const { updateMyBusLocation } = require('../controllers/liveLocationController');

router.post('/update', protect, allowRoles('driver'), (req, res, next) => {
  if (req.user.driverDetails?.verificationStatus !== 'approved') {
    return res.status(403).json({ message: 'Admin verification is required before sharing driver location.' });
  }
  next();
}, [
  body('busId').isMongoId(),
  body('routeId').isMongoId(),
  body('latitude').isFloat({ min: -90, max: 90 }),
  body('longitude').isFloat({ min: -180, max: 180 }),
  body('speed').optional().isFloat({ min: 0 }),
  body('heading').optional().isFloat({ min: 0, max: 360 })
], validateRequest, updateMyBusLocation);

module.exports = router;
