# domoticz-shutter-blind-and-venetian-control-with-tasmota-and-nodered
controls of blinds or venetian using ESP + tasmota firware + nodered and domoticz with the possibility of wall switch usage

1) flash esp8266 (nodemcu) or esp32 with tasmota. Please refer to tasmota webpage and wiki to flash and how to enable shutter support for blinds
https://tasmota.github.io/docs/Getting-Started/
https://tasmota.github.io/docs/ESP32/
https://tasmota.github.io/docs/Blinds-and-Shutters/

2) install domoticz:
https://www.domoticz.com/downloads/

3) install nodered:
https://nodered.org/

4) setup for tasmota with esp8266 (nodemcu) + PCF854 + 4 shutters (8ch relay + 8 wall swithces)
![immagine](https://user-images.githubusercontent.com/44502572/124386549-49db7600-dcdb-11eb-91f5-5e42f9734a24.png)

![immagine](https://user-images.githubusercontent.com/44502572/124386578-624b9080-dcdb-11eb-94e4-f25fe6ffd3ff.png)


4.1) my configuration to have 4 shutters (8 relays + wall switches with long press and short press)
go in console web page of tasmota then:
to enable shutter support on tasmota and create 4 shutters:

`SetOption80 1`
`ShutterRelay1 1`
`ShutterRelay2 3`
`ShutterRelay3 5`
`ShutterRelay4 7`

# set the interlock relays:
```Backlog Interlock 1,2 3,4 5,6 7,8; Interlock ON```
# enable long and short press:
`switchmode1 5`
`switchmode2 5`
`switchmode3 5`
`switchmode4 5`
`switchmode5 5`
`switchmode6 5`
`switchmode7 5`
`switchmode8 5`
# set 2seconds for longpress:
`setoption32 20`
# set open and close duration:
`ShutterOpenDuration3 15`
`ShutterCloseDuration3 8`
`ShutterOpenDuration4 15`
`ShutterCloseDuration4 8`
`ShutterOpenDuration1 15`
`ShutterOpenDuration2 15`
`ShutterCloseDuration1 8`
`ShutterCloseDuration2 8`

please refer to tasmota wiki page dedicated to shutter support for other commands and calibration options.

rules to manage wall switches:
  shoort press = trigger relay for 3% moviment
  long press (2 seconds) = trigger relay for complete moviment (open or close)

inside tasmota console insert:

`rule1 on switch1#state=2 do backlog ShutterStop1; ShutterChange1 3 endon on switch1#state=3 do ShutterOpen1 endon on switch2#state=2 do backlog ShutterStop1; ShutterChange1 -3 endon on switch2#state=3 do ShutterClose1 endon on switch3#state=2 do backlog ShutterStop2; ShutterChange2 3 endon on switch3#state=3 do ShutterOpen2 endon on switch4#state=2 do backlog ShutterStop2; ShutterChange2 -3 endon on switch4#state=3 do ShutterClose2 endon`
`rule1 1`

`rule2 on switch5#state=2 do backlog ShutterStop3; ShutterChange3 3 endon on switch5#state=3 do ShutterOpen3 endon on switch6#state=2 do backlog ShutterStop3; ShutterChange3 -3 endon on switch6#state=3 do ShutterClose3 endon on switch7#state=2 do backlog ShutterStop4; ShutterChange4 3 endon on switch7#state=3 do ShutterOpen4 endon on switch8#state=2 do backlog ShutterStop4; ShutterChange4 -3 endon on switch8#state=3 do ShutterClose4 endon`
`rule2 1`

4.1) setup for tasmota with esp32 +  4 shutters (8ch relay + 8 wall swithces)

![immagine](https://user-images.githubusercontent.com/44502572/124387169-bbb4bf00-dcdd-11eb-99b5-06e9775552c7.png)

same rules to control wall switch like example with esp8266 and same commands to configure short/long press and enable shutter support on tasmota (refer to point 4) )

5) create dummy devices (one for every shutter) in domoticz.
    change every dummy device in "blind percentage inverted"
    in every dummy device compile the description field with: `{"topic": "tasmota_esp32", "blind": 4}`
    where topic = device topic selected inside tasmota
    blind = number of blind that you want to control
    
    create one more dummy device in domoticz if you want to controll simmultaneously a group of blinds (for example to open or close or set at certain percentage multiple blinds).
   change also this device in "blind percentage inverted"
    inside this "master" device compile the description field with: `{ "slaves" : [ "tap1_esp32_ip56", "tap2_esp32_ip56", "tap3_esp32_ip56", "tap4_esp32_ip56" ] }`
    where in the example "tap1_esp32_ip56" etc are the domoticz name of shutters dummy devices that you want to control simmultaneously.
    
6) create a script in Dzvents to manage the "master" dummy device that will controll multiple blind simmultaneously
     see code for dzvent script => `master_blnd.lua`
		 
7) create the nodered flow to allow comunication between tasmota firmware and domoticz
     `flows_blinds.json`
 
    
    
  
