const express = require('express');
const router = express.Router();
const busController = require('../controllers/busController');
const { protect } = require('../middleware/authMiddleware');
const { allowRoles } = require('../middleware/roleMiddleware');

router.get('/', busController.getAllBuses);
router.post('/', protect, allowRoles('admin'), busController.createBus);
router.patch('/:id', protect, allowRoles('admin'), busController.updateBus);
router.delete('/:id', protect, allowRoles('admin'), busController.deleteBus);

module.exports = router;
