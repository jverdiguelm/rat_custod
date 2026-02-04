app.directive('labScreenshot', function() {
    return {
      restrict: 'E',
      scope: {
        victim: '='
      },
      template: '<div><h4>Captura de pantalla</h4><p>Funcionalidad de captura de pantalla aquí</p></div>'
    };
  });