/* 'use strict'; */

/*
/* var app = angular.module('CalendarApp', ['ngResource']); */
/* app.controller('CalendarCtrl', ['$scope', '$http', function ($scope, $http) { */
var app = angular.module('CalendarApp', [])
.controller('ViewCalendarCtrl', [ '$http' , function ($http) {
	var CalData = this;

	var $uri ='/rencal/calendar/';

            $http({
                method : 'GET',
                url : $uri
            }).then(function(data, status, headers, config) {
                CalData.content = data;
                /* console.log(status);
                console.log(data); */
            }), function(data, status, headers, config) {
                CalData.content = data;
            };
	/* $scope.calendardata = 'test'; */
	CalData.title = 'test2';
}]);

