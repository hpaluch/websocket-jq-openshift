Future WebSocket example
========================



Setup for Ubuntu Ubuntu 14.04.4 LTS
-----------------------------------

```shell
sudo apt-get install ruby-full build-essential git npm nodejs
sudo gem install rhc
sudo gem install rhc
```
> NOTE: On same versions of Ubuntu there is missing link
> /usr/bin/node -> nodejs.
> In such case try:

```shell
sudo update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
```

Creating empty node.js application on OpenShift
-----------------------------------------------
__Skip this step (it is here for documentary purpose only)__

```shell
# do not do this - 
rhc app-create ws2 nodejs-0.10
cd ws2
npm install
npm install mustache --save
```

Setup (continued)
-----------------

* Install required node.js packages using:

```shell
npm install
```

* run application:
```shell
npm start
```

* open your browser at [[http://localhost:5000]]





