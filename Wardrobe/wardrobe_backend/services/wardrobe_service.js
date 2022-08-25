const db = require("./db");

const WardrobeService = {
  getAll: async (req, res) => {
    let wardrobe = await db.query("SELECT * FROM wardrobe");
    res.json(wardrobe);
  },
  productsByWardrobeId: async (req, res) => {
    let wardrobeId = req.body.wardrobeId;
    if (!wardrobeId) {
      res.status(400).json({
        success: false,
        message: "No wardrobeId provided",
      });
      return;
    }
    let products = await db.query(
      "SELECT * FROM `wardrobe_product_XREF` INNER JOIN `product` ON `product`.`id` = `wardrobe_product_XREF`.`product_fk` WHERE `wardrobe_product_XREF`.`wardrobe_fk` = ?",
      [wardrobeId]
    );
    res.json(products);
  },
  create: async (req, res) => {
    let fname = req.body.fname;
    let columns = req.body.columns;
    let rows = req.body.rows;
    if (!fname || !columns || !rows) {
      res.status(400).json({
        success: false,
        message: "No fname, columns, or rows provided",
      });
      return;
    }
    // Check type of columns and rows
    if (typeof columns !== "number" || typeof rows !== "number") {
      res.status(400).json({
        success: false,
        message: "Columns and rows must be numbers",
      });
      return;
    }
    // Create wardrobe
    let wardrobe = await db.query(
      "INSERT INTO `wardrobe` (`fname`, `columns`, `rows`) VALUES (?, ?, ?)",
      [fname, columns, rows]
    );
    res.json({
      success: true,
      message: "Wardrobe created",
      wardrobeId: wardrobe.insertId,
    });
  },
};

module.exports = WardrobeService;
