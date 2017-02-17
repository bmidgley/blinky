Cylon = require 'cylon'
SerialPort = require 'serialport'

timer = null
countdown = 0
color = 0

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
  color = randomColor()
  countdown = 1000
  nextBlink my, 1

shake = (my) ->
  my.sphero.setStabilization false
  my.sphero.setRawMotors lmode: 1, lpower: 250, rmode: 1, rpower: 250
  setTimeout (-> stop my), 3000

nextBlink = (my, lit) ->
  clearTimeout timer
  countdown *= 0.9
  my.sphero.color(lit * color)
  if countdown > 10
    timer = setTimeout (-> nextBlink my, if lit == 1 then 0 else 1), countdown
  else
    shake my

Cylon.robot
  connections: {sphero: {adaptor: 'sphero', port: ports[0] }}

  devices: {sphero: {driver: 'sphero'}}

  work: (my) ->
    my.sphero.on 'collision', (data) ->
      color = randomColor()
      countdown = 1000
      nextBlink my, 1

    my.sphero.detectCollisions()

    my.sphero.setStabilization true

    nextBlink my, 1

port.on 'open', -> 
  console.log 'connection opened'
  setTimeout (-> Cylon.start()), 3000

