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
###*/
# 0. Function name: logging. 
#   Create a logging function that takes a positional parameter as the message to be appended to the script.log file.
#   The message should have the format: date(year-month-day) - $MESSAGE - running as the "user running the script"

logging (){
    MESSAGE=$1

    if [ "$MESSAGE" ]; then
        echo -e "$(date +"%Y-%m-%d")\t$MESSAGE running as $USER" | tee -a  script.log
    fi
}



# 1. Function name: reverse_list. 
#    Create a function that takes the /etc/passwd file users and display it in reverse order, using arrays and loop

reverse_list(){
     users=($(cat /etc/passwd | cut -d: -f1))
     for (( i=${#users[@]}-1 ; i>=0 ; i-- )) ; do
        echo "${users[i]}"
        
     done
}

#    Copy the /etc/ssh/sshd_config file into the current user home directory. 
#    Replace the string ServerKeyBits 1024 to ServerKeyBits 4096. 
#    After replacing it, log the message using the logging function and also concatenate the exit code

harden_ssh(){
   ssh_file=sshd_config
   cp /etc/ssh/$ssh_file ~
   sed -i 's/ServerKeyBits 1024/ServerKeyBits 4096/g' ~/$ssh_file
   logging "Set ssh hardened with exit code $?"
}

#3 Function name: remove_sensitive_files. 
#  Create a file called "sensitive_file" and then request confirmation from the user (using the read function), 
# if the user inputs 'y' then remove the file. if not then display the message "No action taken"

remove_sensitive_files(){
   #touch sensitive_file
   sensitive_file=$1
   read -p "Are you sure you want to delete this file? [y|n] " confirmation
   if [[ $confirmation == 'y' ]]
   then
      rm sensitive_file
   else
      echo "No action taken"
   fi
}


#4 Function name: Factorial. Create a function to calculate factorial. It will receive the number as a positional parameter.
#iterative function
factorial(){
   result=1
   n=$1
   while (( n >= 1 ))
   do
      (( result = n * result ))
      (( n = n - 1 ))
   done
   echo $result
}

factorial_recursive(){
    n=$1
   if [[ $n -le 1 ]]
   then
     echo 1
   else
     echo $(( $n * $(factorial $(( $n - 1 ))) ))
   fi
}


#OPTIND=1
# Resetting OPTIND is necessary if getopts was used previously in the script.
# It is a good idea to make OPTIND local if you process options in a function.

while getopts "ash:f:r:" opt; do
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
            remove_sensitive_files $OPTARG
             ;;

         f) #factorial $OPTARG
            factorial_recursive  $OPTARG
             ;;
         *)
             show_help >&2
             exit 1
             ;;
     esac
done

#shift "$((OPTIND-1))" # Shift off the options and optional --.
