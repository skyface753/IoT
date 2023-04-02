const sdk = require('node-appwrite');

const appwriteEndpoint = 'https://appwrite.skyface.de/v1';
const bucketID = '64269512a77339ffe0cb';
const databaseID = '6425b6ba3e077a2ed4d4';
const productCollectionID = '6425b84d23835cc3c652';

/*
  'req' variable has:
    'headers' - object with request headers
    'payload' - request body data as a string
    'variables' - object with function variables

  'res' variable has:
    'send(text, status)' - function to return text response. Status code defaults to 200
    'json(obj, status)' - function to return JSON response. Status code defaults to 200

  If an error is thrown, a response with code 500 will be returned.
*/

// This function is executed for every Product that is created to verify that the image (if provided) exists
module.exports = async function (req, res) {
  const client = new sdk.Client();

  const apiKey = req.variables.APPWRITE_API_KEY;
  if (!apiKey) {
    res.json(
      {
        success: false,
        error: 'Something went wrong 0x1',
      },
      500
    );
  }

  client
    .setEndpoint(appwriteEndpoint)
    .setProject(req.variables['APPWRITE_FUNCTION_PROJECT_ID'])
    .setKey(apiKey)
    .setSelfSigned(true);

  const storage = new sdk.Storage(client);

  var eventInfo = req.variables.APPWRITE_FUNCTION_EVENT_DATA;
  try {
    eventInfo = JSON.parse(eventInfo);
  } catch (error) {
    console.log(error);
    res.json(
      {
        success: false,
        error: 'Something went wrong 0x2',
      },
      500
    );
  }
  if (!eventInfo.imageFileID) {
    res.json({
      success: true,
      message: 'No Image',
    });
    return;
  }
  // Check if the file exists
  try {
    const file = await storage.getFile(bucketID, eventInfo.imageFileID);
    if (file) {
      res.json({
        success: true,
        fileExists: true,
      });
    } else {
      await deleteProduct(eventInfo.$id, client);
      res.json(
        {
          success: false,
          fileExists: false,
          error: 'File does not exist 0x3',
        },
        400
      );
    }
  } catch (error) {
    console.error(error);
    await deleteProduct(eventInfo.$id, client);
    res.json(
      {
        success: false,
        fileExists: false,
        error: 'File does not exist 0x4',
      },
      400
    );
  }
};

async function deleteProduct(productID, databaseClient) {
  const database = new sdk.Databases(databaseClient);
  await database
    .deleteDocument(databaseID, productCollectionID, productID)
    .then((response) => {
      console.log(response);
    })
    .catch((error) => {
      console.error(error);
    });
}
