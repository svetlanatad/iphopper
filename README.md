# iphopper 

Install brew if you already haven't 

Afterwards,
```
1. brew install tor
2. brew services start tor
3. brew services list
```
Make sure tor is running in the background as an app, afterwards,

```
cd /opt/homebrew/etc/tor
```

modify the torrc file (the configuration file) so it changes the exit node as you run the script. You can find the instructions in the script file.

Afterwards, you need to set up your browser's socks proxy so it connects to tor.
In firefox, put
```
127.0.0.1
```
as socks host with 9050 port, cheeck the tickmark for socks v5, and proxy DNS for using socks v5.

Afterwards, run the script, and it should change your ip
