const app = require('./app.js');
const dotenv = require('dotenv');
const mongoose = require('mongoose');

// Load environment variables
dotenv.config({ path: './.env' });

// handling uncaught exception
process.on("uncaughtException", (err) => {
    console.log(`Error : ${err.message}`);
    console.log("Shutting down the server due to uncaught exception");

    server.close(() => {
        process.exit(1);
    });
});

const port = process.env.PORT;
const mongoURI = process.env.MONGODB_URL;

// Connect to MongoDB
const connectToMongo = async () => {
    try {
        await mongoose.connect(mongoURI, {
            useNewUrlParser: true,
            useUnifiedTopology: true,
        });
        console.log("Connected to MongoDB successfully");
    } catch (error) {
        console.error(`MongoDB connection error: ${error.message}`);
        process.exit(1);
    }
};

connectToMongo();

// creating server
const server = app.listen(port, () => {
    console.log(`Backend Server is working on http://localhost:${port}`);
});

// handling unhandled promise rejection
process.on("unhandledRejection", (err) => {
    console.log(`Error : ${err.message}`);
    console.log("Shutting down the server due to unhandled Promise Rejection");

    server.close(() => {
        process.exit(1);
    });
});