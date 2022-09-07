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
      "SELECT `product`.`id`, `product`.`name`, `product`.`description`, `wardrobe_product_XREF`.`number`, `product_images`.`imagePath`, `wardrobe_product_XREF`.`pos_column`, `wardrobe_product_XREF`.`pos_row` FROM `wardrobe_product_XREF` INNER JOIN `product` ON `product`.`id` = `wardrobe_product_XREF`.`product_fk` LEFT JOIN `product_images` ON `product_images`.`id` = `product`.`image_fk` WHERE `wardrobe_product_XREF`.`wardrobe_fk` = ?",
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
    // Parse columns and rows into integers
    columns = parseInt(columns);
    rows = parseInt(rows);
    if (isNaN(columns) || isNaN(rows)) {
      res.status(400).json({
        success: false,
        message: "Columns and rows must be integers",
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
