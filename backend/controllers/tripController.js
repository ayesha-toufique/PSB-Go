const Trip = require('../models/Trip');
const Bus = require('../models/Bus');

exports.getTrips = async (req, res, next) => {
  try {
    const filter = req.user.role === 'admin' ? {} : { driver: req.user._id };
    const trips = await Trip.find(filter).populate('bus route driver', 'registrationNumber name email').sort({ createdAt: -1 });
    res.json({ trips });
  } catch (error) { next(error); }
};

exports.createTrip = async (req, res, next) => {
  try {
    const { busId, routeId, driverId } = req.body;
    const bus = await Bus.findById(busId);
    if (!bus) return res.status(404).json({ message: 'Bus not found.' });
    const trip = await Trip.create({ bus: busId, route: routeId, driver: driverId || req.user._id });
    res.status(201).json({ message: 'Trip scheduled.', trip });
  } catch (error) { next(error); }
};

exports.updateTripStatus = async (req, res, next) => {
  try {
    const { status } = req.body;
    if (!['ongoing', 'completed', 'cancelled'].includes(status)) {
      return res.status(400).json({ message: 'Invalid trip status.' });
    }
    const filter = req.user.role === 'admin'
      ? { _id: req.params.id }
      : { _id: req.params.id, driver: req.user._id };
    const trip = await Trip.findOne(filter);
    if (!trip) return res.status(404).json({ message: 'Trip not found.' });
    trip.status = status;
    if (status === 'ongoing' && !trip.startedAt) trip.startedAt = new Date();
    if (['completed', 'cancelled'].includes(status)) trip.endedAt = new Date();
    await trip.save();
    res.json({ message: 'Trip status updated.', trip });
  } catch (error) { next(error); }
};
