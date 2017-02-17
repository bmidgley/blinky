Cylon = require 'cylon'

randomNumber = (min = 128, max = 255) -> min + (max - min)*Math.random()

randomColor = -> randomNumber() << 16 | randomNumber() << 8 | randomNumber() 

shake = (my) -> my.setRawMotors(0, -> console.log('shaking'))

Cylon.robot
  connections: {sphero: {adaptor: 'sphero', port: '/dev/rfcomm0' }}

  devices: {sphero: {driver: 'sphero'}}

  work: (my) ->
    clock = new Date
    color = randomColor()

    every (1).second(), ->
      my.sphero.color color
      my.sphero.roll 60, Math.floor(360 * Math.random())

    my.sphero.on 'collisions', (data) ->
      console.log 'collision', clock, data
      clock = new Date

    my.sphero.detectCollisions()`

Cylon.start()

# setRawMotors setRawMotorValues(lmode, lpower, rmode, rpower)
# setStabalisation(false)
# blink?
# shake?

