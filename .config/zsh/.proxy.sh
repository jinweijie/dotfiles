################################### proxy ############################################

# create socks5 proxy
# ssh -f -C -N -D 127.0.0.1:7890 USER@REMOTE_SERVER
# proxychains: PROXYCHAINS_SOCKS5 env variable

alias proxyon='export HTTP_PROXY=http://127.0.0.1:7890 HTTPS_PROXY=http://127.0.0.1:7890 NO_PROXY=localhost,127.0.0.1,10.96.0.0/12,192.168.59.0/24,192.168.39.0/24'
alias proxyoff='unset HTTP_PROXY HTTPS_PROXY'

# set system proxy on port 7878
alias proxyon_7878='export HTTP_PROXY=http://127.0.0.1:7878 HTTPS_PROXY=http://127.0.0.1:7878 NO_PROXY=localhost,127.0.0.1,10.96.0.0/12,192.168.59.0/24,192.168.39.0/24'
alias proxyoff_7878='unset HTTP_PROXY HTTPS_PROXY'

# start SOCKS5 proxy
start_proxy() {
  local user="ubuntu"
  local remote_host=""

  if [[ $# -eq 1 ]]; then
    remote_host="$1"
  elif [[ $# -eq 2 ]]; then
    user="$1"
    remote_host="$2"
  elif [[ $# -eq 3 ]]; then
    user="$1"
    remote_host="$2"
    port="$3"
  else
    echo "Usage: start_proxy [user] <remote_host>"
    return 1
  fi

  local port="7878"
  ssh -D $port -N -q -C -c aes256-gcm@openssh.com $user@$remote_host &
  echo "SOCKS5 proxy started on port $port"
  export SOCKS_PROXY_PID=$!
}

# stop SOCKS5 proxy
stop_proxy() {
  if [[ -n "$SOCKS_PROXY_PID" ]]; then
    kill $SOCKS_PROXY_PID
    unset SOCKS_PROXY_PID
    echo "SOCKS5 proxy stopped"
  else
    echo "No SOCKS5 proxy is running"
  fi
}

start_http_proxy() {
  ##http proxy
  local polipo_config="${HOME}/.polipo_config"

  # installation
  # wget http://archive.ubuntu.com/ubuntu/pool/universe/p/polipo/polipo_1.1.1-8_amd64.deb
  # sudo dpkg -i polipo_1.1.1-8_amd64.deb

  # polipo_config content:
  ##    socksParentProxy = "127.0.0.1:7878"
  ##    socksProxyType = socks5
  ##    proxyAddress = "0.0.0.0"
  ##    proxyPort = 7879

  polipo -c $polipo_config &
  echo "HTTP proxy started on $bind_address:7879"
  export HTTP_PROXY_PID=$!
}

stop_http_proxy() {
  if [[ -n "$HTTP_PROXY_PID" ]]; then
    kill $HTTP_PROXY_PID
    unset HTTP_PROXY_PID
    echo "HTTP proxy stopped"
  else
    echo "No HTTP proxy is running"
  fi
}