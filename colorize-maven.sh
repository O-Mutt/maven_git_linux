# To use:
# in your ".bashrc" or ".bash_profile" add the following line:
# ensure MAVEN_HOME is set or set it export MAVEN_HOME=<path to maven> 
# maven home can be found using mvn -v
# source ~/<path to script>/colorize-maven.sh
#
# Example:
#
# export MAVEN_HOME=/other/maven-3.0.4
# or export MAVEN_HOME=/usr
# source /path/to/script/colorize-maven.sh
#

ansi_color() {
# Background
On_Black='[40m'       # Black
On_Red='[41m'         # Red
On_Green='[42m'       # Green
On_Yellow='[43m'      # Yellow
On_Blue='[44m'        # Blue
On_Purple='[45m'      # Purple
On_Cyan='[46m'        # Cyan
On_White='[0;107m'       # White
# High Intensty backgrounds
On_IBlack='[0;100m'   # Black
On_IRed='[0;101m'     # Red
On_IGreen='[0;102m'   # Green
On_IYellow='[0;103m'  # Yellow
On_IBlue='[0;104m'    # Blue
On_IPurple='[10;95m'  # Purple
On_ICyan='[0;106m'    # Cyan
On_IWhite='[0;107m'   # White

#Here is where you would pick your background
My_Background="${On_Black}"
BOLD="${My_Background}[1m"
BLUE="${My_Background}[1;34m"
BLACK="${My_Background}[1;30m\1"
GREEN="${My_Background}[1;32m\1"
PURPLE="${My_Background}[1;35m\1"
RED="${My_Background}[1;31m"
LGT_RED="${My_Background}[0;31m"
CYAN="${My_Background}[1;36m\1"
YELLOW="${My_Background}[1;33m\1"
CLEAR="[0m"
#    Black      0;30       Dark Gray    1;30 
#    Red        0;31       Bold Red     1;31 
#    Green      0;32       Bold Green   1;32 
#    Yellow     0;33       Bold Yellow  1;33 
#    Blue       0;34       Bold Blue    1;34  
#    Purple     0;35       Bold Purple  1;35 
#    Cyan       0;36       Bold Cyan    1;36 
#    Light Gray 0;37       White        1;37
#  Backgrounds are not listed but replace 3X with 4X i.e. 0:44 would be blue background (instead of text)
#  I have not tried this as of now but adding a background is "supposed" to work as \[\033[X;BG;FGm
#  Clarification on synatax and why it is like it is:
#	<ESC>[BOLD OR REGULAR; COLOR CODE 'm' \# the part of the string to replace with the formatted version (colorized)
}

color_maven() {
	ansi_color
	
NUMBER=$[ ( $RANDOM % 100 )  + 1 ]

index=1          # Reset count.
bad_counter=0    # Release fail counter
matt=0
prep_str='release:prepare'
perf_str='release:perform'
fig_str='mutmatt'
resolved_params=''
for arg in $*
do
  if [ $arg == $prep_str ]
    then
    let "bad_counter+=1"
    resolved_params="$resolved_params $arg"
  fi
  if [ $arg == $perf_str ]
    then
    let "bad_counter+=1"
    resolved_params="$resolved_params $arg"
  fi
  if [ $arg == $fig_str ]
  then
    if type figlet >/dev/null 2>&1;
    then
      let "matt+=1"
    else
          echo "##############################################################################################
#  :'(   :'(    :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(  #
#  :'(   :'(    :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(  #
#                                     Please insall figlet!                                  #
#  :'(   :'(    :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(  #
#  :'(   :'(    :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(   :'(  #
##############################################################################################"
      echo >&2 "";
      let "matt=0"
      let "NUMBER=0"
    fi
  fi
  if [ $arg != $fig_str ] && [ $arg != $perf_str ] && [ $arg != $prep_str ]
  then
    if [[ $resolved_params == "" ]]
    then 
      resolved_params="$arg"
    else
      resolved_params="$resolved_params $arg"
    fi
  fi
  let "index+=1"
done

if [ $bad_counter == 0 ] #if the bad counter is still 0 colorize command COLORIZE AWAY!!!
  then
  if [ $NUMBER == 5 ] || [ $matt != 0 ]
    then
      $MAVEN_HOME/bin/mvn $resolved_params | figlet -f $(ls /usr/share/figlet/*.flf | sort -R | head -n 1) -C $(ls /usr/share/figlet/*.flc | sort -R | head -n 1)
  else
      $MAVEN_HOME/bin/mvn $resolved_params | sed -e "s/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/Tests run: ${YELLOW}${CLEAR},${LGT_RED} Failures: ${CLEAR}${RED}\2${CLEAR},${LGT_RED} Errors: ${CLEAR}${RED}\3${CLEAR}, Skipped: ${BLUE}\4${CLEAR}/g" \
	        -e "s/\(---.*\)/${BOLD}${YELLOW}${CLEAR}/g" \
	        -e "s/\(<.*\)/${BOLD}${YELLOW}${CLEAR}/g" \
	        -e "s/\(>.*\)/${BOLD}${YELLOW}${CLEAR}/g" \
	        -e "s/\(\[WARN\].*\)/${YELLOW}${CLEAR}/g" \
	        -e "s/\(WARN.*\)/${YELLOW}${CLEAR}/g" \
	        -e "s/\(\[WARNING\].*\)/${YELLOW}${CLEAR}/g" \
	        -e "s/\(\[INFO\].*\)/${CYAN}${CLEAR}/g" \
	        -e "s/\(INFO.*\)/${CYAN}${CLEAR}/g" \
	        -e "s/\(\[main\].*\)/${CYAN}${CLEAR}/g" \
	        -e "s/\(\[ERROR\].*\)/${RED}\1${CLEAR}/g" \
	        -e "s/\(ERROR.*\)/${RED}\1${CLEAR}/g" \
	        -e "s/\(ERROR.*\)/${RED}\1${CLEAR}/g" \
	        -e "s/\(FAIL.*\)/${RED}\1${CLEAR}/g" \
	        -e "s/\(BUILD FAILURE.*\)/${RED}\1${CLEAR}/g" \
	        -e "s/\(exception.*\)/${RED}\1/g" \
	        -e "s/\(\[debug\].*\)/${PURPLE}${CLEAR}/g" \
	        -e "s/\(DEBUG.*\)/${PURPLE}${CLEAR}/g" \
	        -e "s/\(Downloading:.*\)/${YELLOW}${CLEAR}/g" \
	        -e "s/\(Downloaded:.*\)/${BLUE}\1${CLEAR}/g" \
	        -e "s/\(BUILD SUCCESS.*\)/${BLUE}\1${CLEAR}/g" \
	        -e "s/\(OK.*\)/${BLUE}\1${CLEAR}/g" \
	        -e "s/\(Running com.vecna.*\)/${BLUE}\1${CLEAR}/g" \
	        -e "s/\(Results :.*\)/${BLUE}\1${CLEAR}/g" \
	        -e "s/\(------.*\)/${RED}\1${CLEAR}/g" \
	        -e "s/\(T E S T S.*\)/${RED}\1${CLEAR}/g" \
	        -e "s/\(INSERT .*\)/${PURPLE}${CLEAR}/g" \
	        -e "s/\(http:\/\/.*\)/${GREEN}${CLEAR}/g" \
	        -e "s/\(Using .*\)/${PURPLE}${CLEAR}/g"
    fi
else
  $MAVEN_HOME/bin/mvn $resolved_params
fi
}

alias mvn=color_maven
alias maven='$MAVEN_HOME/bin/mvn'
export PATH=$MAVEN_HOME/bin:$PATH
