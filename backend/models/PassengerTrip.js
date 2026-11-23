
const mongoose = require('mongoose');

const passengerTripSchema = new mongoose.Schema(
  {
    passenger: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true
    },

    route: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Route',
      required: true
    },

    pickupStop: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Stop',
      required: true
    },

    dropoffStop: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Stop',
      required: true
    },

    status: {
      type: String,
      enum: ['ongoing', 'completed', 'cancelled'],
      default: 'ongoing'
    },

    startedAt: {
      type: Date,
      default: Date.now
    },

    endedAt: {
      type: Date,
      default: null
    }
  },
  { timestamps: true }
);

passengerTripSchema.index({
  passenger: 1,
  status: 1
});

module.exports = mongoose.model(
  'PassengerTrip',
  passengerTripSchema
);
