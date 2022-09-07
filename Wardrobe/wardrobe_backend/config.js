const env = process.env;

const config = {
  db: {
    host: env.DB_HOST || 'localhost',
    user: "wardrobe_user",
    password: "wardrobe_pass",
    database: "wardrobe_db",
  },
  jwt: {
    secret: "wardrobe_secret",
    rounds: 10,
  },
};

module.exports = config;
