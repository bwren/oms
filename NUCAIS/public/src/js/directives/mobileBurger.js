(function() {

var app = angular.module('app');

/**
 * ng directive for hamburger menu (visible on small screen)
 */

app.directive('mobileBurger', function($document) {
  return {
      restrict: 'AE',
      replace: 'true',
      template: "<div class=\"burgerBtn\" slide-toggle=\"#drop-menu\" ng-click=\"toggleBurger()\">" +
        "<div class=\"burger-icon\" ng-class=\"{ 'x-active': active }\">" +
        "</div></div>",
      link: function($scope, $element, $attrs) {
        $scope.toggleBurger = function () {
          $scope.active = !$scope.active;
          $element.toggleClass('x-active');
        };
      }
    };
  });

}());
