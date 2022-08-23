const UserService = require("./services/user_service.js");
const db = require("./services/db.js");

const Middleware = {
  getUserIfCookie: async (req, res, next) => {
    var userId = UserService.verifyTokenExport(req);
    // console.log("UserId: " + userId);
    if (!userId) {
      next();
    } else {
      // console.log("UserId: " + userId);
      var user = await db.query("SELECT * FROM user WHERE id = ?", [userId]);
      req.user = user;
      next();
    }
  },
  authUser: async (req, res, next) => {
    var userId = UserService.verifyTokenExport(req);
    // console.log("UserId: " + userId);
    if (!userId) {
      // console.log("Unauthorized in Router");
      res.status(401).json({
        message: "Unauthorized",
      });
      return;
    }
    // console.log("Authorized in Router");
    var user = await db.query("SELECT * FROM user WHERE id = ?", [userId]);
    req.user = user;
    next();
  },
};

module.exports = Middleware;
