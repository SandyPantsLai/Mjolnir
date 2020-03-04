Mjölnir
=======

A Heroku-based distributed load testing tool/traffic simulator. 

This is a fork of [tsykoduk/Mjolnir](https://github.com/tsykoduk/Mjolnir), so all credit goes to him. Please refer to README in the [original repo](https://github.com/tsykoduk/Mjolnir) for more info about this tool. 

This fork merely houses additional scripts that can be used to simulate traffic/load test for specific situations. Please update the Procfile to use whatever script you want for load testing/traffic simulation.

You may want to further simulate traffic patterns by scaling dynos up and down at different times of day. Once you have deployed Mjölnir to Heroku, you can use the [Heroku Scheduler](https://devcenter.heroku.com/articles/scheduler) to do this for you:

1. Add the buildpack for Heroku CLI: `heroku buildpacks:set heroku-community/cli -a name-of-your-deployed-mjolnir-app`
2. `git push heroku master` to create a new release with the buildpack
3. In Heroku Scheduler, set up some tasks to scale your dynos up/down at different times of day, i.e. `heroku ps:scale program=2:Standard-1X -a name-of-your-deployed-mjolnir-app`

The following button will deploy Mjölnir to Heroku, using the `random-traffic-simulator-for-solidus.rb` file for simulating traffic. That script was written specifically to simulate traffic against this [example Solidus app](https://github.com/SandyPantsLai/rails-pg-example-shop).
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/SandyPantsLai/Mjolnir)

