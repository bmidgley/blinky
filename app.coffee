Cylon = require 'cylon'
SerialPort = require 'serialport'

ports = ['/dev/rfcomm0']

port = new SerialPort ports[0]

randomNumber = (max) -> if max < 0 then 0 else max*Math.random()

randomColor = -> 
  total = 255
  r = randomNumber(total)
  g = randomNumber(total - r)
  b = randomNumber(total - r - g)
  r << 16 | g << 8 | b 

stop = (my) ->
  my.setRawMotors lmode: 0, rmode: 0

shake = (my) ->
  my.setRawMotors lmode: 1, lpower: 250, rmode: 1, rpower: 250
  setTimeout (-> stop my), 2000

Cylon.robot
  connections: {sphero: {adaptor: 'sphero', port: ports[0] }}

  devices: {sphero: {driver: 'sphero'}}

  work: (my) ->
    clock = new Date

    every (5).second(), ->
      color = randomColor()
      my.sphero.color color
      my.sphero.roll 60, Math.floor(360 * Math.random())

    my.sphero.on 'collisions', (data) ->
      console.log 'collision', clock, data
      clock = new Date

    my.sphero.detectCollisions()

    my.sphero.setStabilization false

    my.sphero.setRawMotors lmode: 1, lpower: 250, rmode: 1, rpower: 250

port.on 'open', -> 
  console.log 'connection opened'
  Cylon.start()

