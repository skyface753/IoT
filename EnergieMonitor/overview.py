
import time
import requests
import json
from types import SimpleNamespace
import sys
from tabulate import tabulate


url = "https://energiewendemonitor.entega.ag/api/v2/mcps"

def loadOverview():
   res = requests.get(url)
   return json.loads(res.text, object_hook=lambda d: SimpleNamespace(**d))

def loadCity(city):
   res = requests.get(url + city)
   return json.loads(res.text, object_hook=lambda d: SimpleNamespace(**d))

loadedCity = {}

overview = loadOverview()
startTime = time.time()
index = 0
for city in overview:
    sys.stdout.write("\033[K")
    print("\r", "Loading " + city.name + "...", str(index +1) + "/" + str(len(overview)), end="")
    city = loadCity(overview[index].url)
    # print(str(index) + " " + city.name)
    cityName = city.municipality.name
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
    # print(cityName + " " + str(abundancePercent) + "%")
    loadedCity[cityName] = abundancePercent
    index += 1
    # if index == 5:
    #     break
    
    
# Order loadedCity by value
loadedCity = dict(sorted(loadedCity.items(), key=lambda item: item[1], reverse=True))
print(tabulate(loadedCity.items(), headers=["City", "Abundance %"], tablefmt="grid"))
endTime = time.time()
print("Time: " + str(endTime - startTime))