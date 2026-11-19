const mongoose = require('mongoose');

const stopSchema = new mongoose.Schema({
  name: { type: String, required: true, trim: true },
  location: {
    type: { type: String, enum: ['Point'], default: 'Point' },
    coordinates: {
      type: [Number],
      required: true,
      validate: {
        validator: value => Array.isArray(value) && value.length === 2 &&
          value.every(Number.isFinite) && value[0] >= -180 && value[0] <= 180 &&
          value[1] >= -90 && value[1] <= 90,
        message: 'Coordinates must be [longitude, latitude]'
      }
    }
  }
}, { timestamps: true });

stopSchema.index({ location: '2dsphere' });
module.exports = mongoose.model('Stop', stopSchema);
