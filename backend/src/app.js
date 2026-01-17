require("dotenv").config();

const errorMiddleware = require('./middleware/error')
const cookieParser = require('cookie-parser')
const express = require('express')
const cors = require('cors')

// route imports
const news = require("../src/routes/newsRoute")
const users = require("../src/routes/userRoute")
const shorts = require("../src/routes/shortRoute")
const ads = require('../src/routes/adsRoute')

const app = express();
const bodyparser = require('body-parser');

app.use(cors({
    origin: '*', // Allow requests from any origin
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: [
        "Content-Type",
        "Authorization",
        "Cache-Control",
        "Expires",
        "Pragma",
      ],
    credentials: false
}))

// to access req.body
app.use(bodyparser.json()); 
app.use(express.json());
app.use(cookieParser());
app.use(express.urlencoded({ extended: true }));

//available routes
app.get("/",(req,res)=>{
  return res.status(200).json({
    success:true,
    message:"Server Up and Running !!"
  });
})
app.use('/api/v1',news);
app.use('/api/v1',users);
app.use('/api/v1',shorts);
app.use('/api/v1',ads);

// middleware for errors
app.use(errorMiddleware)
module.exports = app