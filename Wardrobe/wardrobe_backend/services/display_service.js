var isAPi = false; // Is a Pi
var lcd;
try {
  const LCD = require("raspberrypi-liquid-crystal");
  lcd = new LCD(1, 0x27, 16, 2);
  lcd.beginSync();
  lcd.clearSync();
  lcd.printSync("Hello");
  lcd.setCursorSync(0, 1);
  lcd.printSync("World");

  isAPi = true;
} catch (e) {
  console.log("JUST A PROD ERROR - not in debug mode");
  console.log(e);
  isAPi = false;
}

const db = require("./db");

const displayService = {
  lightUp: async (drawer, productName) => {
    if (!isAPi) {
      console.log("Not a Pi - not lighting up");
      return;
    }
    for (let i = 0; i < drawer.length; i++) {
      lcd.clearSync();
      lcd.setCursorSync(0, 0);
      lcd.printSync(productName);
      lcd.setCursorSync(0, 1);
      lcd.printSync(
        "Col: " + drawer[i].pos_column + " Row: " + drawer[i].pos_row
      );

      await sleep(3000);
    }
    lcd.clearSync();
  },
};

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

module.exports = displayService;

// function blinkLED() { //function to start blinking
//   if (LED.readSync() === 0) { //check the pin state, if the state is 0 (or off)
//     LED.writeSync(1); //set pin state to 1 (turn LED on)
//   } else {
//     LED.writeSync(0); //set pin state to 0 (turn LED off)
//   }
// }

// function endBlink() { //function to stop blinking
//   clearInterval(blinkInterval); // Stop blink intervals
//   LED.writeSync(0); // Turn LED off
//   LED.unexport(); // Unexport GPIO to free resources
// }

// setTimeout(endBlink, 5000); //stop blinking after 5 seconds
