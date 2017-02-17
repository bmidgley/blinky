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
  my.sphero.setRawMotors lmode: 0, rmode: 0
  my.sphero.setStabilization true

shake = (my) ->
  my.sphero.setStabilization false
  my.sphero.setRawMotors lmode: 1, lpower: 250, rmode: 1, rpower: 250
  setTimeout (-> stop my), 3000

timer = null

startTimer = (my) ->
  clearTimeout timer
  timer = setTimeout (-> shake my), 6000

Cylon.robot
  connections: {sphero: {adaptor: 'sphero', port: ports[0] }}

  devices: {sphero: {driver: 'sphero'}}

  work: (my) ->
    color = 0

    my.sphero.on 'collision', (data) ->
      color = randomColor()
      my.sphero.color color
      startTimer my

    my.sphero.detectCollisions()

    my.sphero.setStabilization true

    startTimer my

port.on 'open', -> 
  console.log 'connection opened'
  setTimeout (-> Cylon.start()), 3000

