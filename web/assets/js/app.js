'use strict';

var EmqueApp = window.app = chip.app()
EmqueApp.services = {};
EmqueApp.service = function(name, objClass) {
  if (arguments.length > 1) {
    this.services[name] = new objClass;
    return this;
  } else {
    return this.services[name];
  }
};

/* Services */
EmqueApp.service('status', function() {
  var factory = {
    clearErrors: function(params) {
      var deferred = Q.defer();

      $.ajax({
        type: 'PUT',
        url: root+'clear_errors',
        data: params,
        success: deferred.resolve
      }).fail(deferred.reject)

      return deferred.promise;
    },

    down: function(params) {
      var deferred = Q.defer();

      $.ajax({
        type: 'PUT',
        url: root+'down',
        data: params,
        success: deferred.resolve
      }).fail(deferred.reject)

      return deferred.promise;
    },

    get: function() {
      var deferred = Q.defer();

      $.get(root+'status', deferred.resolve).fail(deferred.reject)

      return deferred.promise;
    },

    threshold: function(direction, params) {
      var deferred = Q.defer();

      $.ajax({
        type: 'PUT',
        url: root+'threshold/'+direction,
        data: params,
        success: deferred.resolve
      }).fail(deferred.reject)

      return deferred.promise;
    },

    up: function(params) {
      var deferred = Q.defer();

      $.ajax({
        type: 'PUT',
        url: root+'up',
        data: params,
        success: deferred.resolve
      }).fail(deferred.reject)

      return deferred.promise;
    }
  }, self = this;

  self.data = "Not Loaded";

  self.clearErrors = function(params) {
    var deferred = Q.defer();

    factory.clearErrors(params).then(function(data) {
      self.data = JSON.parse(data);
      deferred.resolve(self);
    }, deferred.reject);

    return deferred.promise;
  };

  self.down = function(params) {
    var deferred = Q.defer();

    factory.down(params).then(function(data) {
      self.data = JSON.parse(data);
      deferred.resolve(self);
    }, deferred.reject);

    return deferred.promise;
  };

  self.load = function() {
    var deferred = Q.defer();

    factory.get().then(function(data) {
      self.data = JSON.parse(data);
      deferred.resolve(self);
    }, deferred.reject);

    return deferred.promise;
  };

  self.thresholdDown = function(params) {
    var deferred = Q.defer();

    factory.threshold('down', params).then(function(data) {
      self.data = JSON.parse(data);
      deferred.resolve(self);
    }, deferred.reject);

    return deferred.promise;
  };

  self.thresholdUp = function(params) {
    var deferred = Q.defer();

    factory.threshold('up', params).then(function(data) {
      self.data = JSON.parse(data);
      deferred.resolve(self);
    }, deferred.reject);

    return deferred.promise;
  };

  self.up = function(params) {
    var deferred = Q.defer();

    factory.up(params).then(function(data) {
      self.data = JSON.parse(data);
      deferred.resolve(self);
    }, deferred.reject);

    return deferred.promise;
  };
});

/* Controllers */
EmqueApp.controller('status', function(controller) {
  var initialize, loadStatus, processStatus,
      statusService = EmqueApp.service('status');

  initialize = function() {
    loadStatus();
    setInterval(loadStatus, 1500);
  };

  controller.clearErrors = function(source) {
    statusService.clearErrors({
      host: source.host
    }).then(processStatus);
  };

  controller.down = function(topic) {
    statusService.down({
      host: topic.host,
      topic: topic.name
    }).then(processStatus);
  };

  controller.thresholdDown = function(source) {
    statusService.thresholdDown({
      host: source.host
    }).then(processStatus);
  };

  controller.thresholdUp = function(source) {
    statusService.thresholdUp({
      host: source.host
    }).then(processStatus);
  };

  controller.up = function(topic) {
    statusService.up({
      host: topic.host,
      topic: topic.name
    }).then(processStatus);
  };

  loadStatus = function() {
    return statusService.load().then(processStatus);
  };

  processStatus = function(service) {
    var deferred = Q.defer();
    controller.data = service.data;
    controller.topics = [];
    controller.lastUpdate = new Date;
    _.each(controller.data, function(source, ia) {
      _.each(_.keys(source.workers), function(topic, ib) {
        controller.topics.push({
          app: source.app,
          host: source.host,
          name: topic,
          workers: source.workers[topic].count
        });
        if(ia == (controller.data.length - 1) &&
           ib == (_.keys(source.workers).length - 1))
          deferred.resolve();
      });
      if(ia == (controller.data.length - 1) && _.keys(source.workers).length == 0)
        deferred.resolve();
    });
    deferred.promise.then(controller.sync);
  };

  initialize();
});


