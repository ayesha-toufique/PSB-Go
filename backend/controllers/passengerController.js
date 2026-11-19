const Announcement = require('../models/Announcement');
const Route = require('../models/Route');
const Bus = require('../models/Bus');
const LiveLocation = require('../models/LiveLocation');

exports.getDashboardData = async (req, res, next) => {
  try {
    const [announcements, routes, buses] = await Promise.all([
      Announcement.find({ isActive: true }).sort({ createdAt: -1 }).limit(10),
      Route.find().populate('stops.stopId'),
      Bus.find({ isActive: true }).populate('currentRoute')
    ]);
    res.json({ announcements, routes, buses });
  } catch (error) { next(error); }
};

exports.getLiveLocations = async (req, res, next) => {
  try {
    const locations = await LiveLocation.find().populate('busId routeId driverId');
    res.json({ locations });
  } catch (error) { next(error); }
};
