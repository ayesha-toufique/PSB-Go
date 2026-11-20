require('dotenv').config();
const mongoose = require('mongoose');
const Route = require('../models/Route');
const Stop = require('../models/Stop');

const MONGO_URI = process.env.MONGO_URI;

const routeData = [
  {
    name: "Route 1",
    length: "28km",
    terminals: "Khokrapar to Dockyard",
    stops: ["Khokrapar", "Saudabd", "RCD Ground", "Kalaboard", "Malir Halt", "Colony Gate", "Nata Khan Bridge", "Drigh Road Station", "PAF Base Faisal", "Laal Kothi", "Karsaz", "Nursery", "FTC", "Regent Plaza", "Metropole", "Fawwara Chowk", "Arts Council", "Shaheen Complex", "I.I.Chundrigar", "Tower", "Fisheries", "Dockyard"]
  },
  {
    name: "Route 2",
    length: "30km",
    terminals: "Power House to Indus Hospital",
    stops: ["Power House", "UP Mor", "Nagan Chowrangi", "Shafiq Morr", "Sohrab Goth", "Gulshan Chowrangi", "NIPA", "Johar Morr", "COD", "Drigh Road Station", "Colony Gate", "Shah Faisal Colony", "Singer Chowrangi", "Khaddi Stop", "Indus Hospital"]
  },
  {
    name: "Route 3",
    length: "31km",
    terminals: "Power House to Nasir Jump",
    stops: ["Power House", "UP More", "Nagan Chowrangi", "Sakhi Hasan", "5 Star Chowrangi", "KDA Chowrangi", "Board Office", "Nazimabad Eid Gah Ground", "Liaquatabad 10 Number", "Essa Nagri", "Civic Centre", "National stadium", "Karsaz", "Nursery", "FTC", "Korangi Road", "KPT Interchange", "Shan Chowrangi", "Nasir Jump"]
  },
  {
    name: "Route 4",
    length: "21km",
    terminals: "Power House to Keamari",
    stops: ["Power House", "UP Mor", "Nagan Chowrangi", "Shafiq Mor", "Sohrab Goth", "Water Pump", "Ayesha Manzil", "Karimabad", "Liaqautabad 10", "Laloo Khait", "Teen Hati", "Jehangir Road", "Numaish", "Mobile Market", "Urdu Bazar", "Civil Hospital", "City Court", "Light House", "Bolton Market", "Tower", "Keamari"]
  },
  {
    name: "Route 8",
    length: "17km",
    terminals: "Yousuf Goth to Tower",
    stops: ["Yousuf Goth", "Naval Colony", "Baldia", "Sher Shah", "Gulbai", "Agra Taj Colony", "Daryabad", "Jinnah Brige", "Tower"]
  },
  {
    name: "Route 9",
    length: "42km",
    terminals: "Gulshan e Hadeed to Tower",
    stops: ["Gulsahan e Hadeed", "Salah Uddin Ayubi Road", "Allah Wali Chowrangi", "National Highway 5", "Steel Mill More", "Port Bin Qasim More", "Razzakabad", "Abdullah Goth", "Chowkundi More", "Fast University", "Bhains Colony More", "Manzil Pump", "Quaidabad", "Murghi Khana", "Prince Aly Boys School", "Nadra Center Malir", "Malir Session Court", "Malir 15", "Kalaboard", "Malir Halt", "Colony Gate", "Nata Khan Bridge", "Drigh Road Station", "PAF Base Faisal", "Laal Kothi", "Karsaz", "Nursery", "FTC", "Regent Plaza", "Metropole", "Fawwara Chowk", "Arts Council", "Shaheen Complex", "I.I.Chundrigar", "Tower"]
  },
  {
    name: "Route 10",
    length: "28km",
    terminals: "Numaish Chowrangi to Ibrahim Hyderi",
    stops: ["Numaish Chowrangi", "Mobile Market", "Metropole", "Frere Hall", "Teen Talwar", "Do Talwar", "Abdullah Shah Ghazi", "Dolmen Mall", "Clock Tower DHA", "26 Street", "Masjid-e-Ayesha", "Rahat Park", "KPT Inter change", "Korangi Crossing", "CBM University", "Parco", "Ibrahim Hyderi"]
  },
  {
    name: "Route 11",
    length: "19km",
    terminals: "Miran Nakka to Shireen Jinnah Colony",
    stops: ["Miran Nakka", "Gulistan Colony", "Bihar Colony", "Agra Taj", "Daryabad", "Jinnah Brige", "Bahria Complex", "M.T.Khan Road", "PICD", "Submarine Chowk", "Bahria Complex 3", "Khadda Market", "Abdullah Shah Ghazi", "Bilawal Chowrangi", "Ziauddin Hospital", "Shireen Jinnah Colony"]
  },
  {
    name: "Route 12",
    length: "31km",
    terminals: "Naddi Kinara to Lucky Star",
    stops: ["Naddi Kinara", "Khokhrapar", "Saudabad Chowrangi", "RCD Ground", "Kalaboard", "Malir 15", "Malir Mandir", "Malir Session Court", "Murghi Khana", "Quaidabad", "Dawood Chowrangi", "Babar Market", "Landhi Road", "Nasir Jump", "Indus Hospital", "Korangi Crossing", "Qayyumabad", "Defence Mor", "National Medical Center", "Gora Qabristan", "FTC", "Jutt Land", "Lines Area", "Army Public School", "Lucky Star Saddar"]
  },
  {
    name: "Route 13",
    length: "20km",
    terminals: "Hawksbay to Tower",
    stops: ["Hawksbay", "Mauripur", "Gulbai", "Agra Taj", "Daryabad", "Jinnah Brige", "Tower"]
  },
  {
    name: "EV-1",
    length: "28km",
    terminals: "Malir Cantt to Dolmen Mall Clifton",
    stops: ["CMH Malir Cantt", "Tank Chowk", "Model Colony Mor", "Jinnah Ave", "Airport", "Colony Gate", "Nata Khan Bridge", "Drigh Road Station", "PAF Base Faisal", "Laal Kothi", "Karsaz", "Nursery", "FTC", "Korangi Road", "DHA Phase 1", "Masjid e Ayesha", "Clock Tower DHA", "Dolmen Mall Clifton"]
  },
  {
    name: "EV-2",
    length: "30km",
    terminals: "Bahria Town to Malir Halt",
    stops: ["Bahria Town", "Dumba Goth", "Toll Plaza", "Baqai University", "Malir Cantt Gate 5", "Malir Cantt Gate 6", "Tank Chowk", "Model Mor", "Jinnah Ave", "Malir Halt"]
  },
  {
    name: "EV-3",
    length: "20km",
    terminals: "Malir Cantt Check Post 5 to Numaish",
    stops: ["Malir Cantt Check Post 5", "Rim Jhim Tower", "Safoora Chowrangi", "Mausamiyat Chowrangi", "Kamran Chowrangi", "Darul Sehat Hospital", "Johar Chowrangi", "Johar Mor", "Millennium Mall", "Dalmia Road", "Bahria University", "National Stadium", "Aga Khan Hospital", "Liaquat National Hospital", "PIB Colony", "Jail Chowrangi", "Dawood Engineering University", "Islamia College", "People Secretariat Chowrangi", "Numaish"]
  }
];


async function seed() {
  try {
    if (!MONGO_URI) {
      throw new Error('MONGO_URI is missing in backend/.env');
    }

    await mongoose.connect(MONGO_URI);
    console.log('Connected to MongoDB...');

    // Temporary coordinates for displaying stops in the app.
    // These are NOT the actual GPS locations of individual stops.
    const defaultCoordinates = [67.0011, 24.8607];

    for (const data of routeData) {
      const stopIds = [];

      for (let i = 0; i < data.stops.length; i++) {
        const stopName = data.stops[i];

        // Find existing stop or create a new one
        const stop = await Stop.findOneAndUpdate(
          { name: stopName },
          {
            $setOnInsert: {
              name: stopName,
              location: {
                type: 'Point',
                coordinates: defaultCoordinates
              }
            }
          },
          {
            new: true,
            upsert: true,
            setDefaultsOnInsert: true
          }
        );

        stopIds.push({
          stopId: stop._id,
          order: i + 1
        });
      }

      // Create route or update it if it already exists
      await Route.findOneAndUpdate(
        { name: data.name },
        {
          $set: {
            description: `${data.terminals} (${data.length})`,
            stops: stopIds
          }
        },
        {
          new: true,
          upsert: true,
          runValidators: true
        }
      );

      console.log(`Seeded/Updated: ${data.name}`);
    }

    console.log('All routes and stops have been saved!');
  } catch (error) {
    console.error('Seeding failed:', error);
  } finally {
    await mongoose.disconnect();
    console.log('MongoDB disconnected.');
  }
}

seed();
