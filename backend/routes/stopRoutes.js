const express = require('express');
const router = express.Router();
const stopController = require('../controllers/stopController');
const { protect } = require('../middleware/authMiddleware');
const { allowRoles } = require('../middleware/roleMiddleware');

router.get('/', stopController.getAllStops);
router.post('/', protect, allowRoles('admin'), stopController.createStop);
router.patch('/:id', protect, allowRoles('admin'), stopController.updateStop);
router.delete('/:id', protect, allowRoles('admin'), stopController.deleteStop);

module.exports = router;
