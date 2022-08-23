const db = require("./db");

const WardrobeService = {
  getAll: async (req, res) => {
    let wardrobe = await db.query("SELECT * FROM wardrobe");
    res.json(wardrobe);
  },
};

module.exports = WardrobeService;
