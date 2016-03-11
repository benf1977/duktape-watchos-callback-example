var callOut = (this.native_callOut || function(message){});

var Engine = (function () {
  function Engine() {};
  Engine.prototype.setName = function(name) {
    this.name = name;
  };
  Engine.prototype.getName = function() {
    return this.name;
  };
  Engine.prototype.weWillCallYou = function() {
    callOut("Hey, we called!");
  };
  return Engine;
})();

var createEngine = function () {
  return ((gEngine = new Engine()) != null);
};
