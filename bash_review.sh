show_help() {
cat << EOF
Usage: ${0##*/} [-hasr] [-f NUMBER]...
This script will execute a lot of random stuff.
     -h           display this help and exit.
     -a           reverse list of users
     -s           harden ssh configuration
     -r           remove sensitive files
     -f NUMBER    Calculate factorial

EOF
}
# 0. Function name: logging. 
#   Create a logging function that takes a positional parameter as the message to be appended to the script.log file.
#   The message should have the format: date(year-month-day) - $MESSAGE - running as the "user running the script"

# 1. Function name: reverse_list. 
#    Create a function that takes the /etc/passwd file users and display it in reverse order, using arrays and loop. 

# 2. Function name: harden_ssh. 
#    Copy the /etc/ssh/sshd_config file into the current user home directory. 
#    Replace the string ServerKeyBits 1024 to ServerKeyBits 4096. 
#    After replacing it, log the message using the logging function and also concatenate the exit code

#3 Function name: remove_sensitive_files. 
#  Create a file called "sensitive_file" and then request confirmation from the user (using the read function), 
# if the user inputs 'y' then remove the file. if not then display the message "No action taken"

#4 Function name: Factorial. Create a function to calculate factorial. It will receive the number as a positional parameter.

#OPTIND=1
# Resetting OPTIND is necessary if getopts was used previously in the script.
# It is a good idea to make OPTIND local if you process options in a function.

while getopts "asrh:f:" opt; do
     case "$opt" in
         h)
             show_help
             exit 0
             ;;
         a)
            reverse_list
             ;;
         s) 
             harden_ssh
             ;;
         r)
            remove_sensitive_files
             ;;

         f) factorial $OPTARG
             ;;
         *)
             show_help >&2
             exit 1
             ;;
     esac
done

#shift "$((OPTIND-1))" # Shift off the options and optional --.



