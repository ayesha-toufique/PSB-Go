const LiveLocation = require('../models/LiveLocation');
const Bus = require('../models/Bus');

exports.updateMyBusLocation = async (req, res, next) => {
  try {
    const { busId, routeId, latitude, longitude, speed = 0, heading = 0 } = req.body;
    const bus = await Bus.findById(busId);
    if (!bus) return res.status(404).json({ message: 'Bus not found.' });
    if (String(bus.driver) !== String(req.user._id)) {
      return res.status(403).json({ message: 'This bus is not assigned to your driver account.' });
    }
    const location = await LiveLocation.findOneAndUpdate(
      { busId },
      {
        busId, routeId, driverId: req.user._id,
        location: { type: 'Point', coordinates: [Number(longitude), Number(latitude)] },
        speed: Number(speed), heading: Number(heading), lastUpdated: new Date()
      },
      { new: true, upsert: true, runValidators: true, setDefaultsOnInsert: true }
    );
    const io = req.app.get('io');
    io?.to(String(routeId)).emit('busLocationUpdate', {
      busId, routeId, driverId: req.user._id,
      latitude: Number(latitude), longitude: Number(longitude),
      speed: Number(speed), heading: Number(heading), lastUpdated: location.lastUpdated
    });
    res.json({ message: 'Location updated.', location });
  } catch (error) { next(error); }
};
