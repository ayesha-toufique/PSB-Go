const Bus = require('../models/Bus');

exports.getAllBuses = async (req, res, next) => {
  try {
    const buses = await Bus.find().populate('currentRoute').populate('driver', 'name email');
    res.json({ buses });
  } catch (error) { next(error); }
};

exports.createBus = async (req, res, next) => {
  try {
    const { registrationNumber, capacity, currentRoute, driver } = req.body;
    const bus = await Bus.create({ registrationNumber, capacity, currentRoute, driver });
    res.status(201).json({ message: 'Bus created.', bus });
  } catch (error) { next(error); }
};

exports.updateBus = async (req, res, next) => {
  try {
    const bus = await Bus.findByIdAndUpdate(req.params.id, req.body, { new: true, runValidators: true });
    if (!bus) return res.status(404).json({ message: 'Bus not found.' });
    res.json({ message: 'Bus updated.', bus });
  } catch (error) { next(error); }
};

exports.deleteBus = async (req, res, next) => {
  try {
    const bus = await Bus.findByIdAndDelete(req.params.id);
    if (!bus) return res.status(404).json({ message: 'Bus not found.' });
    res.json({ message: 'Bus deleted.' });
  } catch (error) { next(error); }
};
