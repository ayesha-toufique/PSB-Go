const mongoose = require('mongoose');

const busSchema = new mongoose.Schema({
  registrationNumber: { type: String, required: true, unique: true, trim: true, uppercase: true },
  capacity: { type: Number, default: 40, min: 1 },
  currentRoute: { type: mongoose.Schema.Types.ObjectId, ref: 'Route', default: null },
  driver: { type: mongoose.Schema.Types.ObjectId, ref: 'User', default: null },
  isActive: { type: Boolean, default: false }
}, { timestamps: true });

module.exports = mongoose.model('Bus', busSchema);
