const mongoose = require('mongoose');

const routeSchema = new mongoose.Schema({
  name: { type: String, required: true, unique: true, trim: true },
  description: { type: String, default: '' },
  stops: [{
    stopId: { type: mongoose.Schema.Types.ObjectId, ref: 'Stop' },
    order: { type: Number, required: true }
  }],
  path: {
    type: { type: String, enum: ['LineString'], default: 'LineString' },
    coordinates: { type: [[Number]], default: [] }
  }
}, { timestamps: true });

// routeSchema.index({ path: '2dsphere' });
module.exports = mongoose.model('Route', routeSchema);
