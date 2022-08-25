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
// app.use(limiter); //TODO:PROD ONLY

var port = process.env.PORT || 5000;
var bodyParser = require("body-parser");

const config = require("./config.js");

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use(cookieParser());

const routes = require("./routes");
app.use("/", routes);

// Image upload
const multer = require("multer");
const db = require("./services/db");
const UserService = require("./services/user_service");
var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads");
  },
  filename: function (req, file, cb) {
    cb(null, new Date().toISOString() + file.originalname);
  },
});
var upload = multer({ storage: storage });
app.use("/uploads", express.static(__dirname + "/uploads"));
app.post("/file/upload", upload.single("myFile"), async (req, res, next) => {
  const file = req.file;
  if (!file) {
    const error = new Error("Please provide a file");
    error.httpStatusCode = 400;
    return next("Please provide a file");
  }
  var userId = await UserService.verifyTokenExport(req, res);
  if (!userId) {
    return res.status(401).json({
      message: "Unauthorized",
      success: false,
    });
  }
  var user = await db.query("SELECT * FROM user WHERE id = ?", [userId]);
  if (!user) {
    return res.status(401).json({
      message: "Unauthorized",
      success: false,
    });
  }
  var uploadedFile = await db.query(
    "INSERT INTO product_images (user_fk, origFilename, genFilename, timestamp) VALUES (?, ?, ?, current_timestamp())",
    [userId, file.originalname, file.path]
  );
  if (!uploadedFile) {
    return res.status(500).json({
      message: "ERROR",
      success: false,
    });
  }
  //     db.query("INSERT INTO docs (name, path, uploadedName, type, size, user_fk, customer_fk) VALUES (?, ?, ?, ?, ?, ?, ?)", [file.originalname, file.path, file.filename,file.mimetype, file.size, username, req.body.customer_fk]);
  res.status(200).send({
    message: "File uploaded successfully",
    success: true,
    fileId: uploadedFile.insertId,
  });
});

var http = require("http").Server(app);
// Start the server
http.listen(port, function () {
  console.log("Server started on port " + port);
});
