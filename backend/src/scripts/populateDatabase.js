const mongoose = require('mongoose');
const News = require('../models/newsModel');
const Ads = require('../models/adsModel');
const Shorts = require('../models/shortsModel');
require('dotenv').config();

const mongoURI = process.env.MONGODB_URL;

const sampleNews = [
  { title: 'Breaking News 1', description: 'Description for breaking news 1', editor: '63b2f1e8e4b0f1a2b3c4d5e6', createdAt: new Date() },
  { title: 'Breaking News 2', description: 'Description for breaking news 2', editor: '63b2f1e8e4b0f1a2b3c4d5e6', createdAt: new Date() },
  { title: 'Breaking News 3', description: 'Description for breaking news 3', editor: '63b2f1e8e4b0f1a2b3c4d5e6', createdAt: new Date() },
];

const sampleAds = [
  { title: 'Ad 1', description: 'Description for ad 1', category: 'Electronics', createdAt: new Date() },
  { title: 'Ad 2', description: 'Description for ad 2', category: 'Fashion', createdAt: new Date() },
  { title: 'Ad 3', description: 'Description for ad 3', category: 'Automotive', createdAt: new Date() },
];

const sampleShorts = [
  {
    title: 'Short 1',
    videoUrl: 'http://example.com/short1.mp4',
    videoMimeType: 'video/mp4', // Ensure MIME type is correct
    editor: '63b2f1e8e4b0f1a2b3c4d5e6',
    createdAt: new Date(),
  },
  {
    title: 'Short 2',
    videoUrl: 'http://example.com/short2.mp4',
    videoMimeType: 'video/mp4', // Ensure MIME type is correct
    editor: '63b2f1e8e4b0f1a2b3c4d5e6',
    createdAt: new Date(),
  },
  {
    title: 'Short 3',
    videoUrl: 'http://example.com/short3.mp4',
    videoMimeType: 'video/mp4', // Ensure MIME type is correct
    editor: '63b2f1e8e4b0f1a2b3c4d5e6',
    createdAt: new Date(),
  },
];

const populateDatabase = async () => {
  try {
    await mongoose.connect(mongoURI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log('Connected to MongoDB');

    // Clear existing data
    await News.deleteMany({});
    await Ads.deleteMany({});
    await Shorts.deleteMany({});
    console.log('Cleared existing data');

    // Populate news collection
    await News.insertMany(sampleNews);
    console.log('News collection populated');

    // Populate ads collection
    await Ads.insertMany(sampleAds);
    console.log('Ads collection populated');

    // Populate shorts collection
    await Shorts.insertMany(sampleShorts);
    console.log('Shorts collection populated');

    mongoose.connection.close();
    console.log('Database connection closed');
  } catch (error) {
    console.error('Error populating database:', error);
    mongoose.connection.close();
    process.exit(1);
  }
};

populateDatabase();