WebSocket example
=================

How to use WebSockets, Bootstrap, jQuery and node.js in RedHat's
OpenShift Cloud.

Live Example is available on: http://ws2-henryx.rhcloud.com/


Setup for Ubuntu 14.04.4 LTS
----------------------------

* On your ubuntu invoke:

```shell
sudo apt-get install ruby-full build-essential git npm nodejs
# install rhc only if you plan to use OpenShift containers
sudo gem install rhc
```
> NOTE: On same versions of Ubuntu there is missing link
> /usr/bin/node -> nodejs.
> You may try:

```shell
which node ||
   sudo update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
```

Setup for OpenShift (optional)
------------------------------

This application can be run both standalone (on your local computer)
or in OpenShift container. Follow these instructions bellow
to deploy this app on OpenShift:

* Register on https://www.openshift.com/app/account/new
  You get 3 small containers
  for free (see https://www.openshift.com/pricing/plan-comparison.html
  for more information)

* For the 1st time then run:

```shell
rhc setup
# confirm hostname openshift.redhat.com <ENTER>
# enter your OpenShift Login and password
# confirm token creation
# confirm upload of ssh key
```

* Create directory for openshift projects:

```shell
mkdir -p ~/projects/openshift
```
* Change working directory there

```shell
cd ~/projects/openshift
```
* Create OpenShift NodeJs application from my GitHub repo using this command:

```shell
rhc app-create ws2 nodejs-0.10  --from-code https://github.com/hpaluch/websocket-jq-openshift.git
```

> NOTE: If you exceeded OpenShift's limit for
> free apps (max 3 apps) you can use this command
> to delete extra app:

```shell
rhc apps # show apps
rhc app delete APP_NAME
```

Your application should be successfully deployed on url like
`http://ws2-YOUR_DOMAIN_PREFIX.rhcloud.com`

Setup for standalone mode only
------------------------------
If you plan use this application without OpenShift then just issue these
commands:

```shell
cd ~/my_projects_dirs
git clone https://github.com/hpaluch/websocket-jq-openshift.git ws2
```
Follow next section:


Development and Redeployment
---------------------------
* Just enter `ws2` subdirectory and edit what needed
* for the 1st time or after packages.json change issue
```shell
npm install
```
* issue this command to run application locally
```shell
npm start
```
* open url [http://localhost:5000] in your browser
* to redeploy modified app to OpenShift use:
```shell
git commit -am "My modification"
git push origin master
```

Creating empty node.js application on OpenShift
-----------------------------------------------
__Skip this step (it is here for documentary purpose only)__

```shell
# do not do this - 
rhc app-create ws2 nodejs-0.10
cd ws2
npm install
npm install swig --save
npm install ws --save
```

Credits
=======
This sample is based on lot of code snippets including:

* OpenShift node.js template
* Swig setup: https://github.com/paularmstrong/swig/issues/353
* Heroku WebSocket example: https://devcenter.heroku.com/articles/node-websockets
* WebSocket browser detection: http://code.tutsplus.com/tutorials/start-using-html5-websockets-today--net-13270
* Using express-ws: https://www.npmjs.com/package/express-ws


