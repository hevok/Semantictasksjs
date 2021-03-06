//@ sourceMappingURL=view_models.map
// Generated by CoffeeScript 1.6.1
(function() {
  var onLogin,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    _this = this;

  Chat.Login = (function(_super) {

    __extends(Login, _super);

    /*
      Works with logging in logic
    */


    function Login() {
      return Login.__super__.constructor.apply(this, arguments);
    }

    Login.set("signed", false);

    Login.set("currentUser", new Chat.User({
      id: Batman.SocketEvent.genId(),
      name: "",
      password: ""
    }));

    Login.login = function(userName, password) {
      var user;
      user = this.get("currentUser");
      user.set("name", userName);
      user.set("password", password);
      this.set("signed", true);
      return user.save();
    };

    Login.loginClick = function(node, event) {
      /*
        this function connects to socket when logging in
      */

      var currentUser, message, password, url, user;
      currentUser = this.get("currentUser");
      user = currentUser.get("name");
      password = currentUser.get("password");
      if (!Chat.Login.validate(user, password, true)) {
        return false;
      }
      url = Batman.container.websocketURL.replace(/&amp;/g, "&").replace("nouser", user).replace("none", user).replace("nopassword", password);
      Batman.container.websocketURL = url;
      message = {
        user: user,
        password: password,
        websocketURL: url
      };
      return Chat.send(message);
    };

    Login.validate = function(user, password, alerts) {
      if (alerts == null) {
        alerts = false;
      }
      /*
        checks if user and password are valid
      */

      if (!((Batman.container.worker != null) || (Batman.container.websocketURL != null))) {
        if (alerts) {
          alert("NO WEBWORKERS DETECTED!");
        }
        return false;
      }
      if (password.length < 3) {
        if (alerts) {
          alert("too short password");
        }
        return false;
      }
      if (user.length < 3) {
        if (alerts) {
          alert("too short username");
        }
        return false;
      }
      return true;
    };

    return Login;

  })(Batman.Object);

  /*
    ##Message board view model. Needed for various sophisticated operations with messages
  */


  Chat.MessageBoard = (function(_super) {

    __extends(MessageBoard, _super);

    function MessageBoard() {
      return MessageBoard.__super__.constructor.apply(this, arguments);
    }

    MessageBoard.set("text", "");

    MessageBoard.classAccessor("items", function() {
      return Chat.Message.get("loaded");
    });

    MessageBoard.newMessage = function() {
      /*
        creates new empty message for binding
      */
      return new Chat.Message({
        user: Chat.Login.get("currentUser.name"),
        text: Chat.MessageBoard.get("text")
      });
    };

    MessageBoard.pressKey = function(node, event) {
      if (event.keyCode === 13 && !(event.altKey || event.ctrlKey || event.shiftKey)) {
        return Chat.MessageBoard.addNew(node, event);
      }
    };

    MessageBoard.addNew = function(node, event) {
      /*
        Adds new message
      */

      var message;
      if (Chat.MessageBoard.get("text").length > 1) {
        message = Chat.MessageBoard.newMessage();
        message.save();
        return MessageBoard.set("text", "");
      }
    };

    return MessageBoard;

  }).call(this, Batman.Object);

  Chat.TaskBoard = (function(_super) {

    __extends(TaskBoard, _super);

    function TaskBoard() {
      return TaskBoard.__super__.constructor.apply(this, arguments);
    }

    TaskBoard.set("hideCompleted", false);

    TaskBoard.classAccessor("items", function() {
      return Chat.Task.get("all").filter(function(task) {
        return !Chat.TaskBoard.get("hideCompleted") || !task.get('completed');
      });
    });

    TaskBoard.set("title", "");

    TaskBoard.pressKey = function(node, event) {
      if (event.keyCode === 13 && !(event.altKey || event.ctrlKey || event.shiftKey)) {
        return Chat.TaskBoard.addNew(node, event);
      }
    };

    TaskBoard.newTask = function() {
      /*
        creates new empty message for binding
      */
      return new Chat.Task({
        id: Batman.SocketEvent.genId(),
        owner: Chat.Login.get("currentUser.name"),
        title: Chat.TaskBoard.get("title"),
        completed: false
      });
    };

    TaskBoard.addNew = function(node, event) {
      /*
        Adds new message
      */

      var task;
      if (Chat.TaskBoard.get("title").length > 1) {
        task = Chat.TaskBoard.newTask();
        task.save();
        return TaskBoard.set("title", "");
      }
    };

    return TaskBoard;

  }).call(this, Batman.Object);

  jQuery(function() {
    var frame, graph, gridster, messages, myvid, othervid1, othervid2, search, tasks, users;
    gridster = $(".gridster ul").gridster().data('gridster');
    users = $("#userboard");
    messages = $("#messageboard");
    tasks = $("#taskboard");
    frame = $("#frameboard");
    graph = $("#graphboard");
    search = $("#searchboard");
    myvid = $("#myvideo");
    othervid1 = $("#othervideo1");
    othervid2 = $("#othervideo2");
    gridster.add_widget(othervid1, 1, 1, 1, 1);
    gridster.add_widget(othervid2, 1, 1, 2, 1);
    gridster.add_widget(myvid, 1, 1, 3, 1);
    gridster.add_widget(search, 1, 1, 1, 3);
    gridster.add_widget(graph, 2, 2, 1, 2);
    gridster.add_widget(messages, 1, 2, 3, 2);
    return gridster.add_widget(tasks, 1, 2, 3, 4);
  });

  Chat.VideoBoard = (function(_super) {

    __extends(VideoBoard, _super);

    VideoBoard.prototype.video = null;

    VideoBoard.prototype.videoOther1 = null;

    VideoBoard.prototype.videoOther2 = null;

    VideoBoard.prototype.instance = null;

    function VideoBoard() {
      /*
        receives elements
      */
      this.video = document.getElementById('mywebcam');
      this.video.autoplay = true;
      this.videoOther1 = document.getElementById('webcam1');
      this.videoOther1.autoplay = true;
    }

    VideoBoard.prototype.loginHandler = function(data) {
      /*
        creates two test videos
      */

      var first2second, socket;
      socket = Batman.Socket.getInstance();
      first2second = socket.getVideoChannel("myvideo", "othervideo1");
      first2second.subscribeLocal(this.video);
      first2second.subscribeRemote(this.videoOther1);
      return first2second.call();
    };

    return VideoBoard;

  })(Batman.Object);

  Chat.on("login", function(data) {
    if (Chat.VideoBoard.instance == null) {
      Chat.VideoBoard.instance = new Chat.VideoBoard();
    }
    return Chat.VideoBoard.instance.loginHandler(data);
  });

  Chat.SearchBoard = (function(_super) {

    __extends(SearchBoard, _super);

    function SearchBoard() {
      return SearchBoard.__super__.constructor.apply(this, arguments);
    }

    return SearchBoard;

  })(Batman.Object);

  Chat.SearchResultBoard = (function(_super) {

    __extends(SearchResultBoard, _super);

    function SearchResultBoard() {
      return SearchResultBoard.__super__.constructor.apply(this, arguments);
    }

    return SearchResultBoard;

  })(Batman.Object);

  Chat.FrameBoard = (function(_super) {

    __extends(FrameBoard, _super);

    function FrameBoard() {
      return FrameBoard.__super__.constructor.apply(this, arguments);
    }

    return FrameBoard;

  })(Batman.Object);

  onLogin = function(data) {
    var cont, graph, params, renderer;
    graph = Viva.Graph.graph();
    graph.addLink(1, 2);
    graph.addLink(2, 3);
    cont = $("#graph").get(0);
    params = {
      container: cont
    };
    renderer = Viva.Graph.View.renderer(graph, params);
    return renderer.run();
  };

  Chat.on("login", onLogin);

}).call(this);
