const mongoose = require('mongoose');

const liveLocationSchema = new mongoose.Schema({
  busId: { type: mongoose.Schema.Types.ObjectId, ref: 'Bus', required: true, unique: true },
  routeId: { type: mongoose.Schema.Types.ObjectId, ref: 'Route', required: true },
  driverId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  location: {
    type: { type: String, enum: ['Point'], default: 'Point' },
    coordinates: { type: [Number], required: true }
  },
  speed: { type: Number, default: 0, min: 0 },
  heading: { type: Number, default: 0, min: 0, max: 360 },
  lastUpdated: { type: Date, default: Date.now }
}, { timestamps: true });

liveLocationSchema.index({ location: '2dsphere' });
module.exports = mongoose.model('LiveLocation', liveLocationSchema);
