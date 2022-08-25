const db = require("./db");
const LedService = require("./led_service");

const ProductService = {
  getAll: async (req, res) => {
    let products = await db.query("SELECT * FROM product");
    res.json(products);
  },
  getProductsByDrawerId: async (req, res) => {
    let drawerId = req.params.drawerId;
    if (!drawerId) {
      res
        .json({
          success: false,
          message: "No drawerId provided",
        })
        .status(400);
      return;
    }
    let products = await db.query(
      "SELECT product.id, drawer_product_XREF.number, product.name, product.description, product_images.genFilename FROM drawer_product_XREF INNER JOIN product ON drawer_product_XREF.product_fk = product.id LEFT JOIN product_images ON product_images.id = product.image_fk WHERE drawer_fk = ?",
      [drawerId]
    );
    res.json(products);
  },
  createProduct: async (req, res) => {
    let name = req.body.name;
    let description = req.body.description;
    let image_fk = req.body.image_fk;
    if (!name || !description) {
      res.json({
        success: false,
        message: "No name or description provided",
      });
      return;
    }
    var withImage = image_fk ? true : false;
    let product = withImage
      ? await db.query(
          "INSERT INTO product (name, description, image_fk) VALUES (?, ?, ?)",
          [name, description, image_fk]
        )
      : await db.query(
          "INSERT INTO product (name, description) VALUES (?, ?)",
          [name, description]
        );
    if (!product) {
      res.json({
        success: false,
        message: "Product not created",
      });
      return;
    }

    res.json({
      success: true,
      message: "Product created",
      product: product,
    });
  },
  lightLEDByProductId: async (req, res) => {
    let productId = req.params.productId;
    if (!productId) {
      res.json({
        success: false,
        message: "No productId provided",
      });
      return;
    }
    let product = await db.query("SELECT * FROM product WHERE id = ?", [
      productId,
    ]);
    if (!product) {
      res.json({
        success: false,
        message: "Product not found",
      });
      return;
    }
    LedService.lightLEDByProductId(product[0].id);
  },
};

module.exports = ProductService;