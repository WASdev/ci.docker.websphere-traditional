#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to create AppServer profile, start server and then wait.                  #
#                                                                                   #
#  Usage : create_and_start                                                         #
#                                                                                   #
#####################################################################################

/work/create_profile.sh
exec /work/start_server.sh
