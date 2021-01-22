from Cheetah.Template import Template
import os

def cheetah_template(template , nm):
#  print(template)
#  print(nm)
  t3 = Template(template , searchList=[nm])
  print t3
  return(t3)


def get_namespace(nm):
    return([nm])

