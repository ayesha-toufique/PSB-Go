const express = require('express');
const router = express.Router();
const announcementController = require('../controllers/announcementController');
const { protect } = require('../middleware/authMiddleware');
const { allowRoles } = require('../middleware/roleMiddleware');

router.get('/', announcementController.getAnnouncements);
router.post('/', protect, allowRoles('admin'), announcementController.createAnnouncement);
router.patch('/:id', protect, allowRoles('admin'), announcementController.updateAnnouncement);
router.delete('/:id', protect, allowRoles('admin'), announcementController.deleteAnnouncement);

module.exports = router;
