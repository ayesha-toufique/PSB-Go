const Announcement = require('../models/Announcement');

exports.getAnnouncements = async (req, res, next) => {
  try {
    const filter = req.user?.role === 'admin' ? {} : { isActive: true };
    const announcements = await Announcement.find(filter).sort({ createdAt: -1 });
    res.json({ announcements });
  } catch (error) { next(error); }
};

exports.createAnnouncement = async (req, res, next) => {
  try {
    const announcement = await Announcement.create({ ...req.body, createdBy: req.user._id });
    res.status(201).json({ message: 'Announcement published.', announcement });
  } catch (error) { next(error); }
};

exports.updateAnnouncement = async (req, res, next) => {
  try {
    const announcement = await Announcement.findByIdAndUpdate(req.params.id, req.body, { new: true, runValidators: true });
    if (!announcement) return res.status(404).json({ message: 'Announcement not found.' });
    res.json({ message: 'Announcement updated.', announcement });
  } catch (error) { next(error); }
};

exports.deleteAnnouncement = async (req, res, next) => {
  try {
    const announcement = await Announcement.findByIdAndDelete(req.params.id);
    if (!announcement) return res.status(404).json({ message: 'Announcement not found.' });
    res.json({ message: 'Announcement deleted.' });
  } catch (error) { next(error); }
};
