var isAPi = false; // Is a Pi
var LCDPLATE, lcd;
try {
  LCDPLATE = require("adafruit-i2c-lcd").plate;
  lcd = new LCDPLATE(1, 0x16);
  lcd.message("Hello World!");
  isAPi = true;
} catch (e) {
  console.log("LCD not found");
  isAPi = false;
}

try {
  var Gpio = require("onoff").Gpio; //include onoff to interact with the GPIO
  var Regal1Schublade1 = new Gpio(4, "out"); //use GPIO pin 4, and specify that it is output
  var Regal1Schublade2 = new Gpio(5, "out"); //use GPIO pin 5, and specify that it is output
  var Regal1Schublade3 = new Gpio(6, "out"); //use GPIO pin 6, and specify that it is output
  var Regal1Schublade4 = new Gpio(7, "out"); //use GPIO pin 7, and specify that it is output
  isAPi = true;
} catch (err) {
  console.log("GPIO not found");
  isAPi = false;
}
// var LED = new Gpio(4, 'out'); //use GPIO pin 4, and specify that it is output
// var blinkInterval = setInterval(blinkLED, 250); //run the blinkLED function every 250ms
const db = require("./db");

const LedService = {
  lightUp: async (req, res) => {
    if (!isAPi) {
      return;
    }
    Regal1Schublade1.writeSync(1);
    setTimeout(function () {
      Regal1Schublade1.writeSync(0);
    }, 5000);
  },
};

module.exports = LedService;

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
