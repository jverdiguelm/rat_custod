// assets/js/controllers/BuildCtrl.js
(function(){
  'use strict';

  angular.module('myappy')
    .controller('BuildCtrl', ['$scope', '$http', function($scope, $http) {
      // Inicializar modelo de build
      $scope.build = {
        projectDir:      '',
        outputName:      '',
        keystorePath:    '',
        keystorePassword:'',
        keyAlias:        '',
        keyPassword:     '',
        // Permisos como casillas de verificación
        perms: {
          RECEIVE_SMS: false,
          CAMERA: false,
          RECORD_AUDIO: false,
          ACCESS_FINE_LOCATION: false,
          READ_CALL_LOG: false,
          BIND_NOTIFICATION_LISTENER_SERVICE: false
        }
      };

      // Estado y resultados
      $scope.apkLogs = [];
      $scope.building = false;
      $scope.apkLink  = null;

      // Escucha eventos de WebSocket para build
      var socket = window.socket; // <-- usa la instancia global

      socket.on('buildStart', function() {
        $scope.$apply(function() {
          $scope.apkLogs  = ['🚧 Iniciando build…'];
          $scope.building = true;
          $scope.apkLink  = null;
        });
      });
      socket.on('buildLog', function(msg) {
        $scope.$apply(function() {
          $scope.apkLogs.push(msg);
        });
        // Auto-scroll
        var logEl = document.getElementById('apkLog');
        if (logEl) logEl.scrollTop = logEl.scrollHeight;
      });
      socket.on('buildComplete', function(data) {
        $scope.$apply(function() {
          $scope.building = false;
          $scope.apkLogs.push('✅ Build completado');
          $scope.apkLink = data.apk;
        });
      });

      // Iniciar construcción de APK
      $scope.startBuild = function() {
        // Validaciones básicas
        if (!$scope.build.projectDir || !$scope.build.outputName) {
          $scope.apkLogs.push('❌ Error: Directorio de proyecto y nombre de salida son obligatorios');
          return;
        }
        if (!$scope.build.keystorePath || !$scope.build.keystorePassword ||
            !$scope.build.keyAlias     || !$scope.build.keyPassword) {
          $scope.apkLogs.push('❌ Error: Debes completar los datos de keystore');
          return;
        }

        // Construir array de permisos seleccionados
        var permsArr = [];
        angular.forEach($scope.build.perms, function(enabled, key) {
          if (enabled) {
            permsArr.push('android.permission.' + key);
          }
        });

        // Payload para el servidor
        // Note: serverIp and serverPort are no longer needed as they come from config.json
        var payload = {
          projectDir:       $scope.build.projectDir,
          outputName:       $scope.build.outputName,
          keystorePath:     $scope.build.keystorePath,
          keystorePassword: $scope.build.keystorePassword,
          keyAlias:         $scope.build.keyAlias,
          keyPassword:      $scope.build.keyPassword,
          permissions:      permsArr
        };

        // Reset de logs y estado
        $scope.apkLogs  = [];
        $scope.apkLink  = null;

        // Llamada al endpoint de build
        $http.post('/api/build', payload)
          .catch(function(err) {
            $scope.building = false;
            var msg = err.data && err.data.message ? err.data.message : err.statusText;
            $scope.apkLogs.push('❌ ' + msg);
          });
      };
    }]);
})();