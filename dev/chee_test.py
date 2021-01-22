from Cheetah.Template import Template
import os

cwd = os.getcwd()

print(cwd)


templateDef = """
... <HTML>
... <HEAD><TITLE>$title</TITLE></HEAD>
... <BODY>
... $contents
... ## this is a single-line Cheetah comment and won't appear in the output
... #* This is a multi-line comment and won't appear in the output
...    blah, blah, blah
... *#
... </BODY>
... </HTML>"""

nameSpace = {'title': 'Hello World Example', 'contents': 'Hello World!'}
t = Template(templateDef, searchList=[nameSpace])
print t

gg = [nameSpace]

class Template3(Template):
         title = 'Hello World Example!'
         contents = 'Hello World!'

t3 = Template3(templateDef)
print t3


t = open("inst/cheetah/shinydashboardplus_app.txt", "r")

nameSpace = {'dashboard_style': 'shiny_dashboard_plus','app_name': 'my_ai_app','title': 'my_ai_app','footer_left': 'Built on shinyspring','footer_right': 'my_ai_app','sidebar_expand_onhover': 'FALSE'}

nameSpace = {'title': 'New App', 'sidebar_expand_onhover': 'FALSE' ,'footer_right': 'Right Foot' , 'footer_left': 'Left Foot'}

t3 = Template(t.read() , searchList=[nameSpace])
print t3


print(f.read())
