const db = require("./db");

const DrawerService = {
  getDrawerByWardrobeId: async (req, res) => {
    let wardrobeId = req.params.wardrobeId;
    if (!wardrobeId) {
      res
        .json({
          success: false,
          message: "No wardrobeId provided",
        })
        .status(400);
      return;
    }
    let drawer = await db.query("SELECT * FROM drawer WHERE wardrobe_fk = ?", [
      wardrobeId,
    ]);
    res.json(drawer);
  },
};

module.exports = DrawerService;
