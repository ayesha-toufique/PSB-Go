const Stop = require('../models/Stop');

exports.getAllStops = async (req, res, next) => {
  try {
    const stops = await Stop.find().sort({ name: 1 });
    res.json({ stops });
  } catch (error) { next(error); }
};

exports.createStop = async (req, res, next) => {
  try {
    const { name, longitude, latitude } = req.body;
    const stop = await Stop.create({
      name,
      location: { type: 'Point', coordinates: [Number(longitude), Number(latitude)] }
    });
    res.status(201).json({ message: 'Stop created.', stop });
  } catch (error) { next(error); }
};

exports.updateStop = async (req, res, next) => {
  try {
    const update = { ...req.body };
    if (update.longitude !== undefined && update.latitude !== undefined) {
      update.location = { type: 'Point', coordinates: [Number(update.longitude), Number(update.latitude)] };
      delete update.longitude; delete update.latitude;
    }
    const stop = await Stop.findByIdAndUpdate(req.params.id, update, { new: true, runValidators: true });
    if (!stop) return res.status(404).json({ message: 'Stop not found.' });
    res.json({ message: 'Stop updated.', stop });
  } catch (error) { next(error); }
};

exports.deleteStop = async (req, res, next) => {
  try {
    const stop = await Stop.findByIdAndDelete(req.params.id);
    if (!stop) return res.status(404).json({ message: 'Stop not found.' });
    res.json({ message: 'Stop deleted.' });
  } catch (error) { next(error); }
};
