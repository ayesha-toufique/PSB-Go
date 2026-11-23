
const User = require('../models/User');
const Bus = require('../models/Bus');
const Route = require('../models/Route');
const Trip = require('../models/Trip');
const LiveLocation = require('../models/LiveLocation');

// Driver verification status
exports.getVerificationStatus = async (req, res) => {
  res.json({
    verificationStatus:
      req.user.driverDetails?.verificationStatus || 'pending',
    rejectionReason:
      req.user.driverDetails?.rejectionReason || '',
    verifiedAt:
      req.user.driverDetails?.verifiedAt || null
  });
};

// Get buses assigned to the logged-in driver
exports.getMyBuses = async (req, res, next) => {
  try {
    const buses = await Bus.find({
      driver: req.user._id
    }).populate('currentRoute', 'name description');

    res.json({ buses });
  } catch (error) {
    next(error);
  }
};

// Get driver's current ongoing trip
exports.getActiveTrip = async (req, res, next) => {
  try {
    const trip = await Trip.findOne({
      driver: req.user._id,
      status: 'ongoing'
    }).populate('bus route');

    res.json({ trip });
  } catch (error) {
    next(error);
  }
};

// Start a new bus journey
exports.startJourney = async (req, res, next) => {
  try {
    const { busId, routeId } = req.body;

    // Check assigned bus
    const bus = await Bus.findOne({
      _id: busId,
      driver: req.user._id
    });

    if (!bus) {
      return res.status(404).json({
        message: 'Bus not found or not assigned to you.'
      });
    }

    // Check route
    const route = await Route.findById(routeId);

    if (!route) {
      return res.status(404).json({
        message: 'Route not found.'
      });
    }

    // A driver can only operate one journey at a time
    const activeTrip = await Trip.findOne({
      driver: req.user._id,
      status: 'ongoing'
    });

    if (activeTrip) {
      return res.status(409).json({
        message: 'You already have an ongoing journey.',
        trip: activeTrip
      });
    }

    // A bus cannot have two ongoing journeys
    const busActiveTrip = await Trip.findOne({
      bus: busId,
      status: 'ongoing'
    });

    if (busActiveTrip) {
      return res.status(409).json({
        message: 'This bus already has an ongoing journey.'
      });
    }

    // Set selected route on bus
    bus.currentRoute = routeId;
    await bus.save();

    // Create ongoing trip
    const trip = await Trip.create({
      bus: busId,
      driver: req.user._id,
      route: routeId,
      status: 'ongoing',
      startedAt: new Date()
    });

    const populatedTrip = await Trip.findById(trip._id)
      .populate('bus route');

    res.status(201).json({
      message: 'Journey started successfully.',
      trip: populatedTrip
    });
  } catch (error) {
    next(error);
  }
};

// End the ongoing journey
exports.endJourney = async (req, res, next) => {
  try {
    const trip = await Trip.findOne({
      _id: req.params.tripId,
      driver: req.user._id,
      status: 'ongoing'
    });

    if (!trip) {
      return res.status(404).json({
        message: 'Active journey not found.'
      });
    }

    trip.status = 'completed';
    trip.endedAt = new Date();

    await trip.save();

    // Stop sharing the last bus location
    await LiveLocation.deleteOne({
      busId: trip.bus
    });

    res.json({
      message: 'Journey completed successfully.',
      trip
    });
  } catch (error) {
    next(error);
  }
};
