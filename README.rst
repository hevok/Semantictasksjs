=============
SemanticTasks
=============

SemanticTasks together with SemanticChat allow you to incorporate semantic operations into you task management.

This repository is intended to be used as git submodule for other projects (i.e. SemanticChat and Denigma), it consists of CoffeeScript, less and html files as well as cakefile to rule_them... to build them all.

Now the project is on very early stage so you will not see much there.
SemanticTasks is based on CoffeeScript and Batman framework.
CoffeeScript is just a better JavScript, it is a language that is compiled to JavaScript. It is very easy to learn and it adds a lot of conveniences and syntactic sugar to JS (see to http://coffeescript.org ). BatmanJS ( batmanjs.org ) is MVC framework based on CoffeeScript. Batmans has a lot of cool features that are needed to build fast, flexible and responsive applications. It has very nice binding and events system letting you create very complex logic in a small amount of code.

The application is structured in MVC way, so there are views, controllers and models folders that contain CoffeeScript classes.

This CoffeeScript files are compiled and joined to js folder by cake (see Cakefile for more info).

There is also a documentation that is generated automatically on build and lies in docs folder.

For styles LESS is used. LESS is just better CSS that extend it with some extra features.
LESS is natively supported by Chrome and some other browsers but the best way to use them is to compile to CSS (see resources.css folder)



Setting up SemanticTasks
========================

0. These instructions are given assuming you have Linux as your primary operational system.
For other operating systems (Windows and Mac) some steps maybe different.
If you have difficulties with setting this project up, do not hesitate and contact any active Denigma developers.


1. Git clone repository::

   You can do it in your favourite git client or in console by typing::

       $ git clone https://github.com/antonkulaga/semantictasks.git

2. Set up CoffeeScript, if you have not installed it yet, you need to:

   Go to http://nodejs.org and install it. Nodejs will be used here only for CoffeeScript compilation.
   If you are using Ubuntu/Mint it is recommended to build Nodejs from sources because Ubuntu's repository contains outdated version of nodejs.
   After build check if nodejs path variable is set correctly (for Linux it should be something like NODE_PATH=/usr/local/lib/node:/usr/local/lib/node_modules)
   NodeJS comes with npm package manager. You can use it from the console to install all others things that are needed.

   ::

        $ sudo npm install -g coffee-script

        $ npm install -g cake 
	
   Installs CoffeeScript itself and Cake builder that will be used to build the sources (-g parameter means that it will be installed as global, so npm will write the PATH variable for it and you will be able to call it from the console)

   When you are done, install and activate NodeJs and coffeescript plugins in your favourite IDE.


3. Prepare Environment:

   We also need few other tools. Mocha ( http://visionmedia.github.com/mocha/ ) and Chai ( http://chaijs.com/ ) for testing::

	$ sudo npm install -g mocha

	$ sudo npm install -g chai

   Coffeescript concat for concatenation of small files into bigger ones. It is used for compilations. Currently there is a small bug inside this lib,
   it tells "Error: couldn't find needed class: Batman", but do not pay attention to it as it does not influence anything::

    $ sudo npm install -g coffeescript-concat

   Asyncblock ( https://github.com/scriby/asyncblock/blob/master/docs/overview.md ) for better control over execution ::

   	$ sudo npm install -g asyncblock


   Coffeedoc ( https://github.com/omarkhan/coffeedoc ) for documentation generation::

	$ sudo npm install -g coffeedoc


   If you like more simple documentation style you may use docco instead (several documentation options are supported in Cakefile)::

	$ sudo npm install -g docco

   If cakefile does not see some required modules in your project (even though they are installed globally) you can overcome this by
   going into project folder and executing::

   $ sudo npm link <module-name>

4. Build the project:

   In order to do this you should go to the project directory (where there is a file called Cakefile) and run::

       $ cake build

If you are using IntellijIDEA or similar you can set up Cake (it is situated in the same folder as coffee) as external tool and set the project directory (where the Cakefile is located) as working directory.
Then you can open your run configuration and add this external tool to be executed before run/debug command, so every time you push debug/run button all coffeescripts will be compiled, tests passes and docs generated.
The file to run is index.html
Generated JavaScripts files are gitignored so you have to build everything first (with Cake) to run it
While cake execution you may see something like "Error: couldn't find needed class: Batman" do not pay attention to it as it is wrong warning of coffeescript concat

5. Debug SemanticTasks:

    There is a cool new features in Chrome and FireFox called sourcemaps ( see http://coffeescript.org/#source-maps ) that lets you see CoffeeScript files instead of js files in the debugger.
    To turn on sourcemaps in Chrome click the bolt in the lower right corner of the window to get the settings window, and check "enable source map"
    To check if it works well type _debugger_ inside of your sourcecode in experimental folder.
    The code uses shared webworkers. Shared webworkers are not shown when you push F12 you need to open chrome://inspect/ to see and debug them.
    Keep in mind that when you close the tab shared webworkers are not closed. To terminate them you should use chrome://inspect/
    (choose terminate button) or close the whole browser.

    As browsers have some security restrictions for local files you should debug it from localhost.
    One of the possible options is to do it with batman server. To install it type::
        $ sudo npm install -g batman
    to run - go to semantictasks directory and type:
        $ batman server

6. Change SemanticTasks:

    Before committing check if all tests are passed (look for output of cake build, it is reported there if some tests are failed).
    If everything is ok then::

    $ git commit -am "Brief description of the change."
    $ git push origin master

7. Keep SemanticTasks Updated::

    $ git checkout master # Update to the latest version.
    $ git pull # Pull it from master.
