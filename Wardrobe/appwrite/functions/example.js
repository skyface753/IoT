module.exports = async (req, res) => {
  const payload =
    req.payload ||
    'No payload provided. Add custom data when executing function.';

  const secretKey =
    req.variables.SECRET_KEY ||
    'SECRET_KEY variable not found. You can set it in Function settings.';

  const randomNumber = Math.random();
  const eventInfo = req.variables.APPWRITE_FUNCTION_EVENT_DATA;
  console.log(eventInfo);
  console.log(req.variables.APPWRITE_FUNCTION_USER_ID);

  const trigger = req.variables.APPWRITE_FUNCTION_TRIGGER;
  if (!eventInfo) {
    return res.send('No eventinfo', 400);
  }
  if (trigger != 'event') {
    return res.send('Trigger not Event', 400);
  }
  if (req.variables.APPWRITE_FUNCTION_USER_ID != eventInfo.$id) {
    return res.send('User not owner', 400);
  }

  res.json({
    message: 'Hello from Appwrite!',
    payload,
    secretKey,
    randomNumber,
    trigger,
  });
};
