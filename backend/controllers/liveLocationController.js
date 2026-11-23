
const LiveLocation = require('../models/LiveLocation');
const Bus = require('../models/Bus');
const Trip = require('../models/Trip');

exports.updateMyBusLocation = async (req, res, next) => {
  try {
    const {
      busId,
      routeId,
      latitude,
      longitude,
      speed = 0,
      heading = 0
    } = req.body;

    const bus = await Bus.findOne({
      _id: busId,
      driver: req.user._id
    });

    if (!bus) {
      return res.status(404).json({
        message: 'Bus not found or not assigned to you.'
      });
    }

    // Only allow location updates during an active journey
    const trip = await Trip.findOne({
      bus: busId,
      driver: req.user._id,
      route: routeId,
      status: 'ongoing'
    });

    if (!trip) {
      return res.status(403).json({
        message: 'Start your journey before sharing location.'
      });
    }

    const location = await LiveLocation.findOneAndUpdate(
      { busId },
      {
        busId,
        routeId,
        driverId: req.user._id,
        location: {
          type: 'Point',
          coordinates: [
            Number(longitude),
            Number(latitude)
          ]
        },
        speed: Number(speed),
        heading: Number(heading),
        lastUpdated: new Date()
      },
      {
        new: true,
        upsert: true,
        runValidators: true,
        setDefaultsOnInsert: true
      }
    );

    // Notify passengers subscribed to this route
    const io = req.app.get('io');

    io?.to(String(routeId)).emit('busLocationUpdate', {
      busId: String(busId),
      routeId: String(routeId),
      latitude: Number(latitude),
      longitude: Number(longitude),
      speed: Number(speed),
      heading: Number(heading),
      lastUpdated: location.lastUpdated
    });

    res.json({
      message: 'Location updated successfully.',
      location
    });
  } catch (error) {
    next(error);
  }
};
