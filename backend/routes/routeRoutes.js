const express = require('express');
const router = express.Router();
const routeController = require('../controllers/routeController');
const { protect } = require('../middleware/authMiddleware');
const { allowRoles } = require('../middleware/roleMiddleware');

router.get('/', routeController.getAllRoutes);
router.post('/', protect, allowRoles('admin'), routeController.createRoute);
router.patch('/:id', protect, allowRoles('admin'), routeController.updateRoute);
router.delete('/:id', protect, allowRoles('admin'), routeController.deleteRoute);

module.exports = router;
