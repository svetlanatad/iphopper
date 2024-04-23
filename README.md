# iphopper (More description coming soon) 
A small guide on how to configure tor to change the exit node.
Install homebrew if you already haven't, or use any other package manager.

Afterwards,
```
1. brew install tor
2. brew services start tor
3. brew services list
```
Make sure tor is running in the background, if it's not, you might have encountered the same issues I did. It is possible that it brings up error 257 when you check if tor is running. It might be an issue of missing a dependency, for me, surprisingly, it worked after installing stem. Try 

```
pip install stem
```

if yours also didn't work. 
Now, time to change the configuration file. If you're using unix based system, it's probably in /etc/tor directory. If you used homebrew to install, it is probably in /opt/homebrew/etc/tor, but if you're on mac, your torrc is simply a torrc.sample file which you need to rename to torrc, and add the following lines in the file

```
ControlPort 9051
```
```
HashedControlPassword (*your passwords hash*)
```
(*update notice*) The script works slow, but it is possible to accelerate it by setting automatic circuit renewal time by a high value. If so, add

```
MaxCircuitDirtiness <time in seconds>
```
(*update notice*) I am trying to see if it's possible to disable automatic circuit renewal and let the script handle it. 



Now, time to set up a password. Here, you will probably have issues if your password is too simple and too short, make sure you come up with a secure password. Time to hash it with

```
tor --hash-password (*your password*)
```
The hash output is going to output you something like this. 16: (*the hash*)
16 is apparently the number of the hashing algorithm it uses, but it also needs to be included in your password's hash. 
Afterwards, in the same directory as your torrc is in add the script.sh file.

Time to give it execution rights
```
chmod +x script.sh
```

Now, we need to set up the browser network configurations to route the traffic through tor. If you're using the tor browser, skip these steps and just run the script and test if your ip changed. Or, you can just turn any browser into a tor browser by putting socks host proxy as


```
127.0.0.1
```
with 9050 port, then check the tickmark for socks v5, and proxy DNS for using socks v5.

Afterwards, run the script, and it should change your ip.
