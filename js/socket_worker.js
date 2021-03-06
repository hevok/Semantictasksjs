//@ sourceMappingURL=socket_worker.map
// Generated by CoffeeScript 1.6.1
(function() {
  var AbstractSocketWorker, BasicWorker, SocketWorker, worker,
    _this = this,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  AbstractSocketWorker = (function() {

    function AbstractSocketWorker() {
      var _this = this;
      this.broadcast = function(data) {
        return AbstractSocketWorker.prototype.broadcast.apply(_this, arguments);
      };
      this.notifyAll = function(data) {
        return AbstractSocketWorker.prototype.notifyAll.apply(_this, arguments);
      };
      this.listenAll = function(fun) {
        return AbstractSocketWorker.prototype.listenAll.apply(_this, arguments);
      };
      this.postMessage = function(data) {
        return AbstractSocketWorker.prototype.postMessage.apply(_this, arguments);
      };
      this.connections = 0;
      this.ports = [];
    }

    AbstractSocketWorker.prototype.connections = 0;

    AbstractSocketWorker.prototype.connect = function(e) {
      this.lastPort = e.ports[0];
      this.ports.push(this.lastPort);
      return this.connections++;
    };

    AbstractSocketWorker.prototype.postMessage = function(data) {
      return this.lastPort.postMessage(data);
    };

    AbstractSocketWorker.prototype.listenAll = function(fun) {
      var num, port, _results;
      if (!((this.ports != null) || this.ports.length === 0)) {
        return;
      }
      num = 0;
      _results = [];
      while (num < this.ports.length) {
        port = this.ports[num];
        port.onmessage = function(e) {
          return fun(e);
        };
        _results.push(num++);
      }
      return _results;
    };

    AbstractSocketWorker.prototype.notifyAll = function(data) {
      var num, port, _results;
      if (!((this.ports != null) || this.ports.length === 0)) {
        return;
      }
      num = 0;
      _results = [];
      while (num < this.ports.length) {
        port = this.ports[num];
        port.postMessage(data);
        _results.push(num++);
      }
      return _results;
    };

    AbstractSocketWorker.prototype.broadcast = function(data) {
      var num, port, _results;
      num = 0;
      _results = [];
      while (num < this.ports.length) {
        port = this.ports[num];
        port.postMessage(data);
        _results.push(num++);
      }
      return _results;
    };

    return AbstractSocketWorker;

  })();

  BasicWorker = (function(_super) {

    __extends(BasicWorker, _super);

    function BasicWorker() {
      BasicWorker.__super__.constructor.apply(this, arguments);
    }

    BasicWorker.prototype.createWebsocket = function(user, password, url) {
      if (url !== "none") {
        url = url.replace(/&amp;/g, "&").replace("none", user).replace("nopassword", password);
      }
      return new WebSocket(url);
    };

    return BasicWorker;

  })(AbstractSocketWorker);

  /*
    This is a shared worker that containes websocket connection inside itself
    the connection is shared between several
  */


  SocketWorker = (function(_super) {

    __extends(SocketWorker, _super);

    function SocketWorker() {
      var _this = this;
      this.portHandler = function(msg) {
        return SocketWorker.prototype.portHandler.apply(_this, arguments);
      };
      this.sendAuth = function() {
        return SocketWorker.prototype.sendAuth.apply(_this, arguments);
      };
      this.hasAny = function(obj) {
        return SocketWorker.prototype.hasAny.apply(_this, arguments);
      };
      this.hasAuth = function(obj) {
        return SocketWorker.prototype.hasAuth.apply(_this, arguments);
      };
      this.hasLogin = function(obj) {
        return SocketWorker.prototype.hasLogin.apply(_this, arguments);
      };
      SocketWorker.__super__.constructor.apply(this, arguments);
    }

    SocketWorker.prototype.ports = [];

    SocketWorker.prototype.hasLogin = function(obj) {
      return (obj.user != null) && (obj.password != null);
    };

    SocketWorker.prototype.hasAuth = function(obj) {
      return this.hasLogin(obj) && (this.websocket != null);
    };

    SocketWorker.prototype.hasAny = function(obj) {
      return this.hasLogin(obj) || (obj.websocketURL != null) || this.connections > 0;
    };

    SocketWorker.prototype.connect = function(e) {
      /*
        connects to port
      */

      var _this = this;
      SocketWorker.__super__.connect.call(this, e);
      this.lastPort.onmessage = function(e) {
        return _this.portHandler(e);
      };
      return this.sendAuth();
    };

    SocketWorker.prototype.sendAuth = function() {
      /*
        authorizes other clients of this shared webworker
      */

      var message;
      message = {};
      if (this.url != null) {
        message.websocketURL = this.url;
      }
      if (this.user != null) {
        message.user = this.user;
      }
      if (this.password != null) {
        message.password = this.password;
      }
      if (this.websocket != null) {
        message.ready = true;
      }
      if (this.hasAny(this)) {
        return this.postMessage(message);
      }
    };

    SocketWorker.prototype.portHandler = function(msg) {
      var data, notifyAll, websocket;
      data = msg.data;
      if (data.user != null) {
        this.user = data.user;
      }
      if (data.password != null) {
        this.password = data.password;
      }
      if (data.websocketURL != null) {
        this.url = data.websocketURL;
      }
      if (this.websocket == null) {
        if ((this.url != null) && this.hasLogin(this)) {
          websocket = this.createWebsocket(this.user, this.password, this.url);
          this.websocket = websocket;
          notifyAll = this.notifyAll;
          websocket.onmessage = notifyAll;
          this.listenAll(function(e) {
            return websocket.send(e.data);
          });
        }
        /*
        if @url? and @hasLogin(@)
          websocket = @createWebsocket(@user,@password,@url)
          funMes = (e)=>
            event = e
            #debugger
            @notifyAll(e)
          @websocket = websocket
        
          websocket.onmessage = (e)->funMes(e.data)
          @listenAll (e)->
            #debugger
            websocket.send(e.data)
        */

      }
      return this.sendAuth();
    };

    return SocketWorker;

  })(BasicWorker);

  worker = new SocketWorker();

  self.addEventListener("connect", function(e) {
    return worker.connect(e);
  });

}).call(this);
