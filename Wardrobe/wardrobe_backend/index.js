var express = require("express");
var cors = require("cors");
csrf = require("csurf");
var app = express();
var cookieParser = require("cookie-parser");

//CORS
app.use(cors());

// app.use(
//   cors({
//     origin: [
//       "http://localhost:3000",
//       "http://localhost:19006",
//       "http://127.0.0.1:3000",
//       "http://skyface.de",
//       "http://skyface.de:3000",
//       process.env.FRONTEND_URL || "https://skyface.de",

//     ],
//     credentials: true,
//   })
// );

// set up rate limiter: maximum of five requests per minute
var RateLimit = require("express-rate-limit");
var limiter = RateLimit({
  windowMs: 1 * 60 * 1000, // 1 minute
  max: 400000,
});

// apply rate limiter to all requests
// app.use(limiter); //PROD ONLY

var port = process.env.PORT || 5000;
var bodyParser = require("body-parser");

const config = require("./config.js");

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use(cookieParser());

const routes = require("./routes");
app.use("/", routes);

var http = require("http").Server(app);
// Start the server
http.listen(port, function () {
  console.log("Server started on port " + port);
});
