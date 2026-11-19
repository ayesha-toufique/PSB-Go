const Route = require('../models/Route');

exports.getAllRoutes = async (req, res, next) => {
  try {
    const routes = await Route.find().populate('stops.stopId').sort({ name: 1 });
    res.json({ routes });
  } catch (error) { next(error); }
};

exports.createRoute = async (req, res, next) => {
  try {
    const route = await Route.create(req.body);
    res.status(201).json({ message: 'Route created.', route });
  } catch (error) { next(error); }
};

exports.updateRoute = async (req, res, next) => {
  try {
    const route = await Route.findByIdAndUpdate(req.params.id, req.body, { new: true, runValidators: true });
    if (!route) return res.status(404).json({ message: 'Route not found.' });
    res.json({ message: 'Route updated.', route });
  } catch (error) { next(error); }
};

exports.deleteRoute = async (req, res, next) => {
  try {
    const route = await Route.findByIdAndDelete(req.params.id);
    if (!route) return res.status(404).json({ message: 'Route not found.' });
    res.json({ message: 'Route deleted.' });
  } catch (error) { next(error); }
};
