/* 'use strict'; */

/*
/* var app = angular.module('CalendarApp', ['ngResource']); */
/* app.controller('CalendarCtrl', ['$scope', '$http', function ($scope, $http) { */
var app = angular.module("CalendarApp", []);

app.controller("ViewCalendarCtrl", [
  "$scope",
  "$http",
  function($scope, $http) {
    var useDate = "";
    var selectedStatus = false;
    var availIndex = 0;
    var selectIndex = 1;

    $scope.header = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"];
    $scope.areaoptions = [
      {
        name: "北海道",
        value: 2
      },
      {
        name: "東北",
        value: 2
      },
      {
        name: "関東",
        value: 1
      },
      {
        name: "東海",
        value: 2
      },
      {
        name: "中部",
        value: 2
      },
      {
        name: "四国",
        value: 2
      },
      {
        name: "九州",
        value: 2
      },
      {
        name: "沖縄",
        value: 2
      }
    ];
    $scope.tooloptions = [
      {
        name: "Tool1",
        value: 1
      },
      {
        name: "Tool2",
        value: 2
      }
    ];

    $scope.areaoption =
      $scope.areaoptions[2]; /* days to transport : set default value */
    $scope.tooltype = $scope.tooloptions[0]; /* set default value */

    var now = new Date();
    $scope.year = now.getFullYear();
    $scope.month = now.getMonth() + 1;

    var $uri = "/rencal/calendar/rencal";

    $scope.updateArea = function(days) {
      $scope.reloadCalendar();
    };

    $scope.clearSelect = function() {
      for (i = 0; i < $scope.calendar.length; i++) {
        /* week loop */
        for (j = 0; j < $scope.calendar[i].length; j++) {
          /* day loop */
          $scope.calendar[i][j]["class"][selectIndex] = "unselected";
        }
      }
    };

    $scope.reloadCalendar = function() {
      $http({
        method: "GET",
        url:
          $uri +
          "?days=" +
          $scope.areaoption.value +
          "&year=" +
          $scope.year +
          "&month=" +
          $scope.month
      }).then(
        function(response) {
          $scope.calendar = response.data;
        },
        function(response) {
          $scope.calendar = response.data;
        }
      );

      selectedStatus = false;
    };

    $scope.reserve = function() {
      $http({
        method: "POST",
        url: $uri,
        data: {
          day: useDate.date,
          year: $scope.year,
          month: $scope.month,
          days: $scope.areaoption.value,
          tooltype: $scope.tooltype.value,
          username: $scope.username,
          phone: $scope.phone,
          email: $scope.email,
          address: $scope.address
        }
      }).then(
        function(response) {
          $scope.calendar = response.data;
        },
        function(response) {
          $scope.calendar = response.data;
        }
      );

      selectedStatus = false;
    };

    $scope.calclick = function(day) {
      if (day["class"][availIndex] != "available") {
        return; /* do nothing */
      }
      if (selectedStatus) {
        if (useDate.date == day.date) {
          useDate["class"][selectIndex] = "unselected";
          useDate = "";
          selectedStatus = false;
        } else {
          useDate["class"][selectIndex] = "unselected";
          useDate = "";
          useDate = day;
          useDate["class"][selectIndex] = "selected";
          selectedStatus = true;
        }
      } else {
        useDate = day;
        useDate["class"][selectIndex] = "selected";
        selectedStatus = true;
      }
    };

    $scope.reloadCalendar();
  }
]);
