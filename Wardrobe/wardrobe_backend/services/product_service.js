const db = require("./db");

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
      "SELECT * FROM drawer_product_XREF INNER JOIN product ON drawer_product_XREF.product_fk = product.id WHERE drawer_fk = ?",
      [drawerId]
    );
    res.json(products);
  },
};

module.exports = ProductService;
