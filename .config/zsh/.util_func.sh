
function docker_startup_enable(){
  sudo systemctl enable docker.socket
  sudo systemctl enable docker.service
  sudo systemctl start docker
}

function docker_startup_disable(){
  sudo systemctl stop docker
  sudo systemctl disable docker.service
  sudo systemctl disable docker.socket
}

function generate_password() {
    local LENGTH=${1:-20}
    local CHARS='A-Za-z0-9'
    local PASSWORD=$(cat /dev/urandom | tr -dc "$CHARS" | fold -w $LENGTH | head -n 1)

    echo $PASSWORD
}

# directory related functions
function cd() {
  if [ "$#" = "0" ]
  then
  pushd ${HOME} > /dev/null
  elif [ -f "${1}" ]
  then
    ${EDITOR} ${1}
  else
  pushd "$1" > /dev/null
  fi
}

function bd(){
  if [ "$#" = "0" ]
  then
    popd > /dev/null
  else
    for i in $(seq ${1})
    do
      popd > /dev/null
    done
  fi
}

# create a directory and cd into it
alias md='' && unalias md
function md() {
  mkdir -p "$@" && cd "$@"
}

# process related functions
# find process by name
function p(){
  ps aux | grep -i $1 | grep -v grep
}

# kill all, usage e.g: ka build, ka python, ka build 15, ka python 9
function ka(){
    cnt=$( p $1 | wc -l)  # total count of processes found
    klevel=${2:-15}       # kill level, defaults to 15 if argument 2 is empty

    echo -e "\nSearching for '$1' -- Found" $cnt "Running Processes .. "
    p $1

    echo -e '\nTerminating' $cnt 'processes .. '

    ps aux  |  grep -i $1 |  grep -v grep   | awk '{print $2}' | xargs sudo kill -$klevel
    echo -e "Done!\n"

    echo "Running search again:"
    p "$1"
    echo -e "\n"
}

# get the latest release tag from github for a specifiy project.
# usage example: get_github_latest_release "docker/compose"
function get_github_latest_release() {
   curl -sL https://api.github.com/repos/$1/releases/latest | grep '"tag_name":' | cut -d'"' -f4
}

# get network info for ubuntu
function ni_ubuntu () {
	local hwinfo=$(sudo lshw -c network) 

	# type: Wi-Fi or Ethernet
	echo -n "type: "
	local desp=$(echo "$hwinfo" | grep 'description')
	if echo "$desp" | grep -Ei 'wireless' &> /dev/null; then
		echo "Wi-Fi"
	else
		echo "Ethernet"
	fi

	# interface
	echo -n "interface: "
	local intfname=$(echo "$hwinfo" | grep 'logical name' | awk '{print $3}')
	echo "$intfname"

	# mac addr
	echo -n "MAC addr: "
	echo "$hwinfo" | grep 'serial' | awk '{print $2}'
	echo

	echo "**Netowrk Info**"
	echo

	echo -n "hostname: "
	hostname

	echo -n "private IP: "
	ifconfig "$intfname" | awk '/inet /{print $2}'

	# ubuntu uses systemd-resolve 
	echo -n "dns server: "
	resolvectl status | grep -i "current dns server" | awk -F': ' '{print $2}' 
	
	echo -n "gateway: "
	ip route | grep default | awk 'NR==1{print $3}'

	echo -n "public IP: "
	curl -sL ident.me 
	echo
}