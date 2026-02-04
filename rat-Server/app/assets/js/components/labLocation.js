angular.module('myappy').component('labLocation', {
  bindings: { victim: '<' },
  templateUrl: 'views/location.html',
  controller: function($scope, $element, $timeout) {
    var ctrl = this;
    ctrl.location = null;
    ctrl.locationsHistory = [];
    ctrl.map = null;
    ctrl.marker = null;
    ctrl.resizeObserver = null;

    ctrl.$onInit = function() {
      console.log('[labLocation] $onInit');
      $scope.$watch(
        function() { 
          const tab = $element.parent().scope().labTab;
          console.log('[labLocation] Watching labTab:', tab);
          return tab; 
        },
        function(tab) {
          console.log('[labLocation] labTab changed:', tab, 'victim:', ctrl.victim);
          if (tab === 'location' && ctrl.victim) {
            $timeout(function() {
              ctrl.getLocation();
            }, 50);
          }
        }
      );
    };

    ctrl.$onChanges = function(changes) {
      console.log('[labLocation] $onChanges', changes);
      if (changes.victim && ctrl.victim) {
        ctrl.location = null;
        ctrl.locationsHistory = [];
        ctrl.getLocation();
      }
    };

    ctrl.setupResizeObserver = function(mapDiv) {
      console.log('[labLocation] setupResizeObserver');
      if (ctrl.resizeObserver) {
        ctrl.resizeObserver.disconnect();
        ctrl.resizeObserver = null;
      }
      ctrl.resizeObserver = new ResizeObserver(function() {
        console.log('[labLocation] ResizeObserver: invalidating map size');
        if (ctrl.map) {
          ctrl.map.invalidateSize();
        }
      });
      ctrl.resizeObserver.observe(mapDiv);
    };

    ctrl.getLocation = function() {
      console.log('[labLocation] getLocation - requesting for victim:', ctrl.victim && ctrl.victim.id);
      socket.emit('get-location', { victimId: ctrl.victim.id });
      socket.once('location-data', function(data) {
        console.log('[labLocation] LLEGO LOCATION DATA:', data);
        $scope.$apply(function() {
          if (data && data.lat && data.lng) {
            ctrl.location = data;
            ctrl.locationsHistory.push({
              lat: data.lat,
              lng: data.lng,
              accuracy: data.accuracy,
              timestamp: data.timestamp || Date.now()
            });

            $timeout(function() {
              var mapDiv = $element[0].querySelector('#mapid');
              // Elimina el mapa anterior completamente si existe
              if (ctrl.map) {
                console.log('[labLocation] Eliminando mapa anterior');
                ctrl.map.remove();
                ctrl.map = null;
                ctrl.marker = null;
              }
              // Siempre crea el mapa de cero
              console.log('[labLocation] Inicializando mapa');
              ctrl.map = L.map(mapDiv).setView([data.lat, data.lng], 15);
              L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(ctrl.map);
              ctrl.setupResizeObserver(mapDiv);

              // Añade el marcador
              if (ctrl.marker) {
                ctrl.map.removeLayer(ctrl.marker);
              }
              console.log('[labLocation] colocando nuevo marcador');
              ctrl.marker = L.marker([data.lat, data.lng]).addTo(ctrl.map)
                .bindPopup('Dispositivo aquí').openPopup();

              // Centra el mapa
              ctrl.map.invalidateSize();
              ctrl.map.setView([data.lat, data.lng], 15);
            }, 50);
          } else {
            console.warn('[labLocation] NO HAY DATOS DE UBICACIÓN');
          }
        });
      });
    };

    ctrl.Refresh = function() {
      console.log('[labLocation] Refresh');
      ctrl.getLocation();
    };

    ctrl.exportHistory = function() {
      console.log('[labLocation] exportHistory');
      if (!ctrl.locationsHistory.length) return;
      var data = ctrl.locationsHistory.map(function(loc) {
        return {
          'Latitud': loc.lat,
          'Longitud': loc.lng,
          'Accuracy (m)': loc.accuracy,
          'Timestamp': new Date(loc.timestamp).toLocaleString()
        };
      });
      var ws = XLSX.utils.json_to_sheet(data);
      var wb = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(wb, ws, "Historial");
      XLSX.writeFile(wb, "historial_ubicacion.xlsx");
    };

    ctrl.$onDestroy = function() {
      console.log('[labLocation] $onDestroy');
      if (ctrl.resizeObserver) {
        ctrl.resizeObserver.disconnect();
        ctrl.resizeObserver = null;
      }
      if (ctrl.map) {
        ctrl.map.remove();
        ctrl.map = null;
        ctrl.marker = null;
      }
    };
  }
});