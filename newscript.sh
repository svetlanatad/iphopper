#!/bin/bash
#Comment the lines of code for the inverse of however other authentication you decided to use. For example, if you're using password authentication, comment the cookie authenication lines 
TOR_IP="127.0.0.1"      
CONTROL_PORT="9051"     
AUTH_CODE=""           #Replace with your authentication password, unhashed 
COOKIE_FILE="/path/to/your/cookie/authcookie" #Replace with the actual path to your cookie. Refer to the readme file to find a possible path

#uncomment these 3 lines of code if the script fails to authenticate
#echo "Reloading tor connections"
#sudo killall -HUP tor

function tor_new_identity {
  RESPONSE=$(echo -e "AUTHENTICATE $AUTH_CODE\r\nSIGNAL NEWNYM\r\nQUIT\r\n" | nc -w 2 $TOR_IP $CONTROL_PORT)
  
  if [[ $? -ne 0 ]]; then
    echo "Failed to connect to the tor control port"
    return 1
  fi

  if echo "$RESPONSE" | grep -q '250 OK'; then
    echo "Successfully requested a new Tor identity"
    return 0
  else
    echo "Failed to authenticate or send signal to Tor"
    return 1
  fi
}

function tor_get_cookie {
  if [[ ! -f "$1" ]]; then
    echo "Cookie file not found: $1"
    return 1
  fi
  
  COOKIE_CONTENT=$(xxd -p "$1" | tr -d '\n' | tr 'a-f' 'A-F')
  
  echo "$COOKIE_CONTENT"
  return 0
}

# Example of using the functions
# If AUTH_CODE is empty, try to load the cookie file
if [[ -z "$AUTH_CODE" ]]; then
  AUTH_CODE=$(tor_get_cookie "$COOKIE_FILE")
  if [[ $? -ne 0 ]]; then
    echo "Could not retrieve the cookie for tor authentication"
    exit 1
  fi
fi

tor_new_identity

