#! /usr/bin/env python

# Simple string program. Writes and updates strings.
# Demo program for the I2C 16x2 Display from Ryanteck.uk
# Created by Matthew Timmons-Brown for The Raspberry Pi Guy YouTube channel

# Import necessary libraries for communication and display use
import drivers
from time import sleep
import requests
import json
from types import SimpleNamespace
import asyncio
import sys
import os
import fcntl

url = "https://energiewendemonitor.entega.ag/api/v2/mcps"

# Load the driver and set it to "display"
# If you use something from the driver library use the "display." prefix first
display = drivers.Lcd()

def loadOverview():
   res = requests.get(url)
   return json.loads(res.text, object_hook=lambda d: SimpleNamespace(**d))

def loadCity(city):
   res = requests.get(url + city)
   return json.loads(res.text, object_hook=lambda d: SimpleNamespace(**d))

def refreshDisplay(cityName, abundancePercent):
   display.lcd_clear()
   display.lcd_display_string(cityName + " " + str(abundancePercent) + "%", 1)  # Write line of text to first line of display



         
def showDataOnDisplay(city):
   cityName = city.municipality.name
   
   sun = city.info.sun.rise + "-" + city.info.sun.set
   wind = str(city.info.wind.value) + " " + city.info.wind.unit
   powerplants = city.powerplants
   loads = city.loads
   prodGesamt = 0
   for plant in powerplants:
      prodGesamt += plant.value
   loadGesamt = 0
   for load in loads:
      loadGesamt += load.value
   abundancePercent = int((prodGesamt / loadGesamt) * 100)
   # Cut the name to 16 (max) - abundancePercent Length - 2 (for the space and the %)
   cityName = cityName[:16 - len(str(abundancePercent)) - 2]
   
   prodGesamtStr = str(prodGesamt) + " " + powerplants[0].unit
   loadGesamtStr = str(loadGesamt) + " " + loads[0].unit
   difference = prodGesamt - loadGesamt
   differenceStr = str(difference) + " " + powerplants[0].unit
   refreshDisplay(cityName, abundancePercent)
   display.lcd_display_string("Sun: " + sun, 2)  # Write line of text to second line of display
   sleep(2)                                           # Give time for the message to be read
   refreshDisplay(cityName, abundancePercent)
   display.lcd_display_string("Wind: " + wind, 2)   # Refresh the first line of display with a different message
   sleep(2)                                           # Give time for the message to be read
   display.lcd_display_string("Prod: +" + prodGesamtStr, 2)   # Refresh the second line of display with a different message
   sleep(2)
   display.lcd_display_string("Load: -" + loadGesamtStr, 2)   # Refresh the second line of display with a different message
   sleep(2)
   display.lcd_display_string("Diff: " + differenceStr, 2)
   # display.lcd_disp
   sleep(2)
   display.lcd_clear()                                # Clear the display of any data
   
# make stdin a non-blocking file
fd = sys.stdin.fileno()
fl = fcntl.fcntl(fd, fcntl.F_GETFL)
fcntl.fcntl(fd, fcntl.F_SETFL, fl | os.O_NONBLOCK)

# Main body of code
try:
    while True:
         overview = loadOverview()
         index = 0
         for city in overview:
            print(str(index) + " " + city.name)
            index += 1
         cityIndex = 0
         asyncIndex = 0
         maxCityIndex = len(overview) - 1
         while True:
            try: 
               input = sys.stdin.readline()
               if input != "":
                  cityIndex = int(input)
                  break
               print("Input is empty")
               showDataOnDisplay(loadCity(overview[cityIndex].url))
               cityIndex += 1
               if cityIndex > maxCityIndex:
                  cityIndex = 0
               
            except: 
               print("EXCEPTION")
               showDataOnDisplay(loadCity(overview[cityIndex].url))
               cityIndex += 1
               if cityIndex > maxCityIndex:
                  cityIndex = 0
               sleep(5)
               continue
         print("Selected Index: " + str(cityIndex))
            
         try:
            cityIndex = int(cityIndex)
         except ValueError:
            print("Invalid input")
            continue
         city = loadCity(overview[cityIndex].url)
         try: 
            apiCounter = 0
            while True:
               if apiCounter % 10 == 0:
                  print("Refreshing data")
                  city = loadCity(overview[cityIndex].url)
               apiCounter += 1
               showDataOnDisplay(city)
               # sleep(2)                                           # Give time for the message to be read
         except KeyboardInterrupt:
            # User pressed CTRL+C
            # Reset the display back to normal
            display.lcd_clear()
            showDefaultLoop = True

except KeyboardInterrupt:
    # If there is a KeyboardInterrupt (when you press ctrl+c), exit the program and cleanup
    print("Cleaning up!")
    display.lcd_clear()


                  

{
   "municipality":{
      "name":"LÜTZELBACH",
      "slogan":"UNSER BEITRAG FÜR DIE ENERGIEWENDE VOR ORT",
      "image":"https://upload.wikimedia.org/wikipedia/commons/a/a8/Wappen_Luetzelbach.png",
      "displayType":"QUOTA",
      "startDate":"21.08.2020",
      "quota":{
         "dMinus1":192,
         "dMinus2":219,
         "dMinus3":96,
         "dMinus4":178,
         "dMinus5":237,
         "dMinus6":145,
         "dMinus7":200,
         "week":181,
         "month":0,
         "year":279,
         "start":269
      }
   },
   "info":{
      "sun":{
         "rise":"06:40",
         "set":"20:11"
      },
      "wind":{
         "type":"W_WIND",
         "value":5,
         "unit":"m/s"
      },
      "households":{
         "type":"COUNT_HH",
         "value":11021,
         "unit":"Anzahl"
      },
      "co2":{
         "today":[
            {
               "type":"CO2_WP",
               "value":11.71,
               "unit":"t CO2e"
            },
            {
               "type":"CO2_PV_PRV",
               "value":0.51,
               "unit":"t CO2e"
            },
            {
               "type":"CO2_PV_IND",
               "value":1.98,
               "unit":"t CO2e"
            }
         ],
         "yesterday":[
            {
               "type":"CO2_WP",
               "value":32.14,
               "unit":"t CO2e"
            },
            {
               "type":"CO2_PV_PRV",
               "value":1.36,
               "unit":"t CO2e"
            },
            {
               "type":"CO2_PV_IND",
               "value":5.32,
               "unit":"t CO2e"
            }
         ]
      }
   },
   "powerplants":[
      {
         "type":"PP_WP",
         "value":1449,
         "unit":"kW"
      },
      {
         "type":"PP_PV_PRV",
         "value":394,
         "unit":"kW"
      },
      {
         "type":"PP_PV_IND",
         "value":1545,
         "unit":"kW"
      }
   ],
   "loads":[
      {
         "type":"L_PRV",
         "value":1025,
         "unit":"kW"
      },
      {
         "type":"L_MCP",
         "value":86,
         "unit":"kW"
      },
      {
         "type":"L_IND",
         "value":227,
         "unit":"kW"
      }
   ]
}
