const mongoose = require('mongoose');

const driverDetailsSchema = new mongoose.Schema({
  cnic: {
    type: String,
    trim: true,
    match: [/^\d{5}-?\d{7}-?\d{1}$/, 'Enter a valid 13-digit CNIC']
  },
  licenseNo: { type: String, trim: true },
  verificationStatus: {
    type: String,
    enum: ['pending', 'approved', 'rejected'],
    default: 'pending'
  },
  verifiedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User', default: null },
  verifiedAt: { type: Date, default: null },
  rejectionReason: { type: String, trim: true, default: '' }
}, { _id: false });

const userSchema = new mongoose.Schema({
  name: { type: String, required: true, trim: true, minlength: 2, maxlength: 80 },
  email: { type: String, required: true, unique: true, lowercase: true, trim: true },
  password: { type: String, required: true, select: false },
  role: { type: String, enum: ['passenger', 'driver', 'admin'], default: 'passenger', immutable: true },
  driverDetails: {
    type: driverDetailsSchema,
    required: function () { return this.role === 'driver'; }
  },
  isActive: { type: Boolean, default: true }
}, { timestamps: true });

userSchema.index(
  { 'driverDetails.cnic': 1 },
  { unique: true, sparse: true, partialFilterExpression: { role: 'driver', 'driverDetails.cnic': { $type: 'string' } } }
);
userSchema.index(
  { 'driverDetails.licenseNo': 1 },
  { unique: true, sparse: true, partialFilterExpression: { role: 'driver', 'driverDetails.licenseNo': { $type: 'string' } } }
);

module.exports = mongoose.model('User', userSchema);
