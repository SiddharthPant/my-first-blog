SHELL := /bin/bash
# wget --output-document=Makefile https://goo.gl/UMTpZ1
# make setup

# Colors
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

venv:
	@echo "${green}>>> Creating virtualenv${reset}"
	@virtualenv -p python3 venv
	@echo "${green}>>> venv is created.${reset}"

active:
	@echo "${red}>>> Type source venv/bin/activate${reset}"
	@echo "${red}>>> Type cd djangoproject${reset}"
	@echo "${red}>>> Type make install${reset}"
	@mkdir djangoproject
	@cp Makefile djangoproject/

installdjango:
	@echo "${green}>>> Installing the Django${reset}"
	@pip install django
	@pip freeze > requirements.txt

createproject:
	@echo "${green}>>> Creating the project 'myproject' ...${reset}"
	@django-admin.py startproject myproject .
	@echo "${green}>>> Creating the app 'core' ...${reset}"
	@./manage.py startapp core

migrate:
	@./manage.py makemigrations
	@./manage.py migrate

createuser:
	@echo "${green}>>> Creating a 'admin' user ...${reset}"
	@./manage.py createsuperuser --username='admin' --email=''

magic:
	@echo "Editing settings.py"
	@sed -i "/django.contrib.staticfiles/a\@    'core'," myproject/settings.py
	@sed -i "s/@//" myproject/settings.py
	@sed -i "/urlpatterns = \[/a\@    url(r'\^$$\', 'core.views.home', name='home')," myproject/urls.py
	@sed -i "s/@//" myproject/urls.py
	@echo "Create the view more simple"
	@sed -i "/render/afrom django.http import HttpResponse\n\n\ndef home(request):\n    return HttpResponse('<h1>Welcome to the Django.</h1>')" core/views.py

backup:
	@./manage.py dumpdata core --format=json --indent=2 > fixtures.json
	@echo "${green}>>> backup created successfully: fixtures.json${reset}"

load:
	@./manage.py loaddata fixtures.json

run:
	@./manage.py runserver

setup: venv active

install: installdjango createproject migrate createuser magic run