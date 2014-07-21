# This file contains various confidential constants and must be added to .gitignore (/config/initializers/app_constants.rb in .gitignore file)
# In the server, these constants need to be set as enviroment variable 
# 	in heroku :  heroku config:set MPC_KEY="api-key-provided"

# It has been committed here knowingly to make the project self contained

module APPCONSTANTS
	MPC_KEY = "power-acres-baby-grass"
end