# Wardrobe

Based on [Kollion](https://www.kollino.de/elektronik/lichtschranke-mit-dem-arduino/)

| Item    | Link                                                                                                                                                                                                                                                                                                                                                   |
| :------ | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Infarot | [Infrared Diode](https://www.amazon.de/Infrarotdiode-Infrared-Leuchtdioden-Emission-Empf%C3%A4nger/dp/B08WHH1B87/ref=asc_df_B08WHH1B87/?tag=googshopde-21&linkCode=df0&hvadid=500836261436&hvpos=&hvnetw=g&hvrand=6264484165596978453&hvpone=&hvptwo=&hvqmt=&hvdev=c&hvdvcmdl=&hvlocint=&hvlocphy=9117354&hvtargid=pla-1195340171893&psc=1&th=1&psc=1) |

74HC132N or CD4093N-IC

## DEV
docker-compose-debug.yml -> lcd not working

## PROD
docker-compose.yml -> db & phpmyadmin
node in wardrobe_backend -> backend (SUDO)

## Flutter

### Build

#### Linux

`cd wardrobe_flutter`
`docker build -t wardrobe_flutter_build_linux . && docker run -it -v $(pwd)/build/linux/arm64/release/bundle:/usr/src/app/build/linux/arm64/release/bundle/ wardrobe_flutter_build_linux`
