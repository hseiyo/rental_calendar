/* 'use strict'; */

/*
/* var app = angular.module('CalendarApp', ['ngResource']); */
/* app.controller('CalendarCtrl', ['$scope', '$http', function ($scope, $http) { */
var app = angular.module("CalendarApp", []);

app.controller("ViewCalendarCtrl", [
  "$http",
  function($http) {
    var useDate = "";
    var selectedStatus = false;
    var availIndex = 0;
    var selectIndex = 1;

    var CalData = this;
    CalData.header = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"];
    CalData.areaoptions = [
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
    CalData.tooloptions = [
      {
        name: "Tool1",
        value: 1
      },
      {
        name: "Tool2",
        value: 2
      }
    ];

    CalData.area =
      CalData.areaoptions[2]; /* days to transport : set default value */
    CalData.tool = CalData.tooloptions[0]; /* set default value */

    var now = new Date();
    CalData.year = now.getFullYear();
    CalData.month = now.getMonth() + 1;

    var $uri = "/rencal/calendar/rencal";

    this.updateArea = function(days) {
      CalData.area = days;
      this.reloadCalendar(CalData.area.value);
    };

    this.clearSelect = function() {
      for (i = 0; i < CalData.content.data.length; i++) {
        /* week loop */
        for (j = 0; j < CalData.content.data[i].length; j++) {
          /* day loop */
          CalData.content.data[i][j]["class"][selectIndex] = "unselected";
        }
      }
    };

    this.reloadCalendar = function(days) {
      $http({
        method: "GET",
        url:
          $uri +
          "?days=" +
          CalData.area.value +
          "&year=" +
          CalData.year +
          "&month=" +
          CalData.month
      }).then(
        function(data, status, headers, config) {
          CalData.content = data;
        },
        function(data, status, headers, config) {
          CalData.content = data;
        }
      );

      selectedStatus = false;
    };

    this.reserve = function() {
      $http({
        method: "POST",
        url:
          $uri +
          "?day=" +
          useDate.date +
          "&year=" +
          CalData.year +
          "&month=" +
          CalData.month +
          "&days=" +
          CalData.area.value
      }).then(
        function(data, status, headers, config) {
          CalData.content = data;
        },
        function(data, status, headers, config) {
          CalData.content = data;
        }
      );

      selectedStatus = false;
    };

    this.calclick = function(day) {
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

    this.reloadCalendar(CalData.area.value);
  }
]);
