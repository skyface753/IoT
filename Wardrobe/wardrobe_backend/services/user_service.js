var jwt = require("jsonwebtoken");
const config = require("../config");
var cors = require("cors");
// jwt 30 Tage
const jwtExpirySeconds = 60 * 60 * 24 * 30;
const jwtKey = config.jwt.secret;
const saltRounds = config.jwt.rounds;
const bycrypt = require("bcrypt");
const db = require("./db");

console.log("Secret: " + config.jwt.secret);
console.log("Rounds: " + saltRounds);

var failures = {};
function onLoginFail(remoteIp) {
  var f = (failures[remoteIp] = failures[remoteIp] || {
    count: 0,
    nextTry: new Date(),
  });
  ++f.count;
  if (f.count % 3 == 0) {
    f.nextTry.setTime(Date.now() + 1000 * 60 * 1); // 2 minutes
    // f.nextTry.setTime(Date.now() + 1000 * f.count); // Wait another two seconds for every failed attempt
  }
}

function onLoginSuccess(remoteIp) {
  delete failures[remoteIp];
}

// Clean up people that have given up
var MINS10 = 600000,
  MINS30 = 3 * MINS10;
setInterval(function () {
  for (var ip in failures) {
    if (Date.now() - failures[ip].nextTry > MINS10) {
      delete failures[ip];
    }
  }
}, MINS30);

let UserService = {
  logout: (req, res) => {
    res.clearCookie("jwt");
    res.json({
      success: true,
      message: "Logged out",
    });
  },
  login: async (req, res) => {
    let username = req.body.username;
    let password = req.body.password;
    if (!username || !password) {
      res.json({
        success: false,
        message: "No Username or Password provided",
      });
      return;
    }
    const remoteIp = req.ip;
    var f = failures[remoteIp];
    if (f && Date.now() < f.nextTry) {
      // Throttled. Can't try yet.
      return res.json({
        success: false,
        message:
          "Too many failed attempts. Try again in " +
          Math.round((f.nextTry - Date.now()) / 1000 / 60) +
          " minutes.",
      });
    }
    let user = await db.query("SELECT * FROM user WHERE username = ?", [
      username,
    ]);

    if (user.length == 0) {
      res.json({
        success: false,
        message: "User not found",
      });
      return;
    }
    user = user[0];
    if (!user.password) {
      res.json({
        success: false,
        message: "User not found",
      });
      return;
    }
    if (!bycrypt.compareSync(password, user.password)) {
      onLoginFail(remoteIp);
      res.json({
        success: false,
        message: "Wrong password",
      });
      return;
    }
    onLoginSuccess(remoteIp);
    var token = signToken(user.id);
    //Clear password
    user.password = undefined;
    res.cookie("jwt", token, {
      httpOnly: true,
      maxAge: 1000 * 60 * 60 * 24 * 7,
      sameSite: "Strict",
    });
    res.json({
      success: true,
      message: "User found",
      token: token,
      user: user,
    });
  },
  register: async (req, res) => {
    let username = req.body.username;
    let password = req.body.password;
    if (!username || !password) {
      res.json({
        success: false,
        message: "No Username or Password provided",
      });
      return;
    }
    let user = await db.query("SELECT * FROM user WHERE username = ?", [
      username,
    ]);
    if (user.length > 0) {
      res.json({
        success: false,
        message: "User already exists",
      });
      return;
    }
    let hash = bycrypt.hashSync(password, saltRounds);
    let result = await db.query(
      "INSERT INTO user (username, password) VALUES (?, ?)",
      [username, hash]
    );
    res.json({
      success: true,
      message: "User created",
    });
  },
  signTokenExport: signToken,
  verifyTokenExport: verifyToken,
};

module.exports = UserService;

function getUserIdFromToken(req) {
  var token = getToken(req);
  if (!token) {
    return false;
  }
  var payload;
  try {
    payload = jwt.verify(token, jwtKey);
  } catch (e) {
    return false;
  }
  var userId = payload.user_id;
  return userId;
}

// function getToken(req) {
//   var token = req.headers.authorization;
//   if (!token) {
//     if (req.cookies.token) {
//       token = req.cookies.token;
//     } else {
//       return false;
//     }
//   }
//   return token;
// }

function signToken(user_id) {
  const token = jwt.sign({ user_id }, jwtKey, {
    algorithm: "HS256",
    expiresIn: jwtExpirySeconds,
  });
  return token;
}

function verifyToken(req) {
  // var tokenFromCookie = req.cookies.jwt
  // console.log("FromCookie" + tokenFromCookie)
  var token = getToken(req);
  if (!token) {
    return false;
  }
  var payload;
  try {
    payload = jwt.verify(token, jwtKey);
  } catch (e) {
    return false;
  }
  var userId = payload.user_id;
  // console.log("Token from request: " + token);
  if (token) {
    return userId;
  } else {
    return false;
  }
}

function getToken(req) {
  var token = req.headers.authorization;
  if (!token) {
    if (req.cookies.token) {
      console.log("Token from cookie: " + req.cookies.token);
      token = req.cookies.token;
    } else {
      return false;
    }
  }
  console.log("Token from request: " + token);
  return token;
}
