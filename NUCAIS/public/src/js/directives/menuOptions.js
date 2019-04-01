(function() {

var app = angular.module('app');

/**
 * ng directive for hamburger menu (visible on small screen)
 */
app.directive('menuOptions', function($animate) {
  return {
      scope: false,
      restrict: 'AE',
      replace: true,
      template:
        "<ul class=\"nav-list\"><li class=\"menu-item\" " +
        "ng-repeat=\"item in menuItems\" ng-click=\"scrollTo(item)\">" +
        "{{item}}</li></ul>"
    };
});

}());
