
require('dotenv').config();

const mongoose = require('mongoose');

const connectDB = require('../config/db');
const User = require('../models/User');
const Bus = require('../models/Bus');

const seedBuses = async () => {
  try {
    await connectDB();

    // Pass driver email as command-line argument
    const driverEmail = process.argv[2]?.trim().toLowerCase();

    if (!driverEmail) {
      throw new Error(
        'Please provide driver email. Example: node scripts/seedBuses.js driver@gmail.com'
      );
    }

    // Find approved driver
    const driver = await User.findOne({
      email: driverEmail,
      role: 'driver',
      'driverDetails.verificationStatus': 'approved',
      isActive: true
    });

    if (!driver) {
      throw new Error(
        'Approved driver not found. Check email and verification status.'
      );
    }

    console.log('Driver found:', driver.name);
    console.log('Driver ID:', driver._id.toString());

    // Test buses assigned to this driver
    const buses = [
      {
        registrationNumber: 'PSB-001',
        capacity: 40,
        currentRoute: null,
        driver: driver._id,
        isActive: true
      },
      {
        registrationNumber: 'PSB-002',
        capacity: 45,
        currentRoute: null,
        driver: driver._id,
        isActive: true
      },
      {
        registrationNumber: 'PSB-003',
        capacity: 50,
        currentRoute: null,
        driver: driver._id,
        isActive: true
      }
    ];

    for (const busData of buses) {
      const bus = await Bus.findOneAndUpdate(
        {
          registrationNumber: busData.registrationNumber
        },
        {
          $set: {
            capacity: busData.capacity,
            driver: busData.driver,
            isActive: busData.isActive
          },
          $setOnInsert: {
            currentRoute: null
          }
        },
        {
          new: true,
          upsert: true,
          runValidators: true
        }
      );

      console.log(
        `Bus assigned: ${bus.registrationNumber} | ID: ${bus._id}`
      );
    }

    console.log('\nBus seeding completed successfully!');
    console.log('These buses are assigned to:', driver.email);

    process.exit(0);
  } catch (error) {
    console.error('\nBus seeding failed:', error.message);
    process.exit(1);
  }
};

seedBuses();
