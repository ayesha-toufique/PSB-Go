
const PassengerTrip = require('../models/PassengerTrip');
const Route = require('../models/Route');

const populateTrip = (query) => {
  return query
    .populate('route', 'name description stops')
    .populate('pickupStop', 'name location')
    .populate('dropoffStop', 'name location');
};

// Start a passenger trip
exports.startPassengerTrip = async (req, res, next) => {
  try {
    const { routeId, pickupStopId, dropoffStopId } = req.body;

    // Check whether the route exists
    const route = await Route.findById(routeId);

    if (!route) {
      return res.status(404).json({
        message: 'Route not found.'
      });
    }

    // Check whether an active passenger trip already exists
    const activeTrip = await PassengerTrip.findOne({
      passenger: req.user._id,
      status: 'ongoing'
    });

    if (activeTrip) {
      return res.status(409).json({
        message: 'You already have an active trip.',
        trip: activeTrip
      });
    }

    // Find pickup and drop-off positions in route
    const pickupIndex = route.stops.findIndex(
      item => String(item.stopId) === String(pickupStopId)
    );

    const dropoffIndex = route.stops.findIndex(
      item => String(item.stopId) === String(dropoffStopId)
    );

    if (pickupIndex === -1 || dropoffIndex === -1) {
      return res.status(400).json({
        message: 'Selected stops do not belong to this route.'
      });
    }

    if (dropoffIndex <= pickupIndex) {
      return res.status(400).json({
        message: 'Drop-off must be after pickup on this route.'
      });
    }

    const trip = await PassengerTrip.create({
      passenger: req.user._id,
      route: routeId,
      pickupStop: pickupStopId,
      dropoffStop: dropoffStopId,
      status: 'ongoing',
      startedAt: new Date()
    });

    const populatedTrip = await populateTrip(
      PassengerTrip.findById(trip._id)
    );

    res.status(201).json({
      message: 'Passenger trip started successfully.',
      trip: populatedTrip
    });
  } catch (error) {
    next(error);
  }
};

// Get passenger's active trip
exports.getActivePassengerTrip = async (req, res, next) => {
  try {
    const trip = await populateTrip(
      PassengerTrip.findOne({
        passenger: req.user._id,
        status: 'ongoing'
      })
    );

    res.json({ trip });
  } catch (error) {
    next(error);
  }
};

// Get passenger's trip history
exports.getPassengerTripHistory = async (req, res, next) => {
  try {
    const trips = await populateTrip(
      PassengerTrip.find({
        passenger: req.user._id
      }).sort({ createdAt: -1 })
    );

    res.json({ trips });
  } catch (error) {
    next(error);
  }
};

// Complete or cancel passenger trip
exports.endPassengerTrip = async (req, res, next) => {
  try {
    const { status = 'completed' } = req.body;

    if (!['completed', 'cancelled'].includes(status)) {
      return res.status(400).json({
        message: 'Invalid trip status.'
      });
    }

    const trip = await PassengerTrip.findOne({
      _id: req.params.id,
      passenger: req.user._id,
      status: 'ongoing'
    });

    if (!trip) {
      return res.status(404).json({
        message: 'Active passenger trip not found.'
      });
    }

    trip.status = status;
    trip.endedAt = new Date();

    await trip.save();

    res.json({
      message: `Passenger trip ${status} successfully.`,
      trip
    });
  } catch (error) {
    next(error);
  }
};
