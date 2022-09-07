const db = require("./db");
const displayService = require("./display_service");

const ProductService = {
  getAll: async (req, res) => {
    let products = await db.query(
      "SELECT `product`.`id`, `product`.`name`, `product`.`description`, `product_images`.`imagePath`, `product`.`borrowed_num`, SUM(cast(wardrobe_product_XREF.number as int)) as in_stock FROM product LEFT JOIN product_images ON product.image_fk = product_images.id LEFT JOIN wardrobe_product_XREF ON `wardrobe_product_XREF`.`product_fk` = `product`.`id` GROUP BY product.id;"
    );
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
      "SELECT product.id, drawer_product_XREF.number, product.name, product.description, product_images.imagePath FROM drawer_product_XREF INNER JOIN product ON drawer_product_XREF.product_fk = product.id LEFT JOIN product_images ON product_images.id = product.image_fk WHERE drawer_fk = ?",
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
    let productId = req.body.productId;
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
    let drawer = await db.query(
      "SELECT pos_column, pos_row FROM `wardrobe_product_XREF` WHERE product_fk = ?",
      [productId]
    );
    if (!drawer) {
      res.json({
        success: false,
        message: "Product not found",
      });
      return;
    }
    displayService.lightUp(drawer, product[0].name);
    res.json({
      success: true,
      message: "LED lit",
    });
  },
  addProductToDrawer: async (req, res) => {
    let { productId, wardrobeId, column, row, number } = req.body;
    if (!productId || !wardrobeId || !column || !row || !number) {
      res.json({
        success: false,
        message: "Missing parameters",
      });
      return;
    }
    let alreadyInDB = await db.query(
      "SELECT * FROM wardrobe_product_XREF WHERE product_fk = ? AND wardrobe_fk = ? AND pos_column = ? AND pos_row = ?",
      [productId, wardrobeId, column, row]
    );
    if (alreadyInDB.length > 0) {
      var oldNumber = alreadyInDB[0].number;
      var newNumber = parseInt(oldNumber) + parseInt(number);
      let update = await db.query(
        "UPDATE wardrobe_product_XREF SET number = ? WHERE product_fk = ? AND wardrobe_fk = ? AND pos_column = ? AND pos_row = ?",
        [newNumber, productId, wardrobeId, column, row]
      );
      if (!update) {
        res.json({
          success: false,
          message: "Could not update product in wardrobe",
        });
        return;
      }
      res.json({
        success: true,
        message: "Product updated in wardrobe",
      });
      return;
    }

    let insertInDB = await db.query(
      "INSERT INTO `wardrobe_product_XREF` (`wardrobe_fk`, `product_fk`, `pos_column`, `pos_row`, `number`) VALUES (?, ?, ?, ?, ?)",
      [wardrobeId, productId, column, row, number]
    );
    if (!insertInDB) {
      res.json({
        success: false,
        message: "Product not added to drawer",
      });
      return;
    }
    res.json({
      success: true,
      message: "Product added to drawer",
    });
  },
};

module.exports = ProductService;
