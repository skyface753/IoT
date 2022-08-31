const express = require("express");
const router = express.Router();
const multer = require("multer");
const Middleware = require("./middleware");

const UserService = require("./services/user_service");
const WardrobeService = require("./services/wardrobe_service");
const ProductService = require("./services/product_service");

router.post("/logout", UserService.logout);
router.post("/login", UserService.login);
router.post("/register", UserService.register);

// Set req.user to logged in user if user is logged in
router.use(async (req, res, next) => {
  await Middleware.getUserIfCookie(req, res, next);
});

// router.use(async (req, res, next) => {
//   await Middleware.authUser(req, res, next);
// });

//Wardrobe
router.post("/wardrobe/all", WardrobeService.getAll);
router.post("/wardrobe/productsById", WardrobeService.productsByWardrobeId);
router.post("/wardrobe/create", WardrobeService.create);
//Product
router.post("/product/all", ProductService.getAll);
router.post(
  "/product/by-drawer/:drawerId",
  ProductService.getProductsByDrawerId
);
router.post("/product/create", ProductService.createProduct);

module.exports = router;
