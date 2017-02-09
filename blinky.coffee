Cylon = require 'cylon'

robot = Cylon.robot
  connections: {sphero: {adaptor: 'sphero', port: '/dev/rfcomm0' }}

  devices: {sphero: {driver: 'sphero'}}

  work: (my) ->
    every (1).second(), ->
      my.sphero.roll 60, Math.floor(360 * Math.random())

robot.start()

addr = '1499e203745e'


