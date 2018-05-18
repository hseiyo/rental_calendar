/* 'use strict'; */

/*
/* var app = angular.module('CalendarApp', ['ngResource']); */
/* app.controller('CalendarCtrl', ['$scope', '$http', function ($scope, $http) { */
var app = angular.module('CalendarApp', []);

app.controller('ViewCalendarCtrl', [ '$http' , function ($http) {

        /* var startDate = "";
        var finishDate = ""; */
        var useDate = "";
        /* var transportDays = 1;
        var transportDate = []; */
        var selectedStatus = false;
        var availIndex = 0;
        var selectIndex = 1;

	var CalData = this;
        CalData.header = [ "sun","mon","tue","wed","thu","fri","sat" ];

        var $uri ='/rencal/calendar/abc';
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

        this.updateArea = function( days ){
          transportDays = days;
          this.reloadCalendar( transportDays );
        }

        this.clearSelect = function(){
          for( let i=0; i < CalData.content.data.length ; i++ ){ /* week loop */
            for( let j=0; j < CalData.content.data[i].length ; j++ ){ /* day loop */
              CalData.content.data[i][j]['class'][selectIndex] = "unselected";
            }
          }
        }
  
        this.reloadCalendar = function( days ){
          $http({
              method : 'GET',
              url : $uri + "?days=" + days
          }).then(function(data, status, headers, config) {
              CalData.content = data;
              /* console.log(status);
              console.log(data); */
          }), function(data, status, headers, config) {
              CalData.content = data;
          };

          selectedStatus = false;
        }

        this.reserve = function(){
          $http({
              method : 'POST',
              url : $uri + "?day=" + useDate.date
          }).then(function(data, status, headers, config) {
              CalData.content = data;
              /* console.log(status);
              console.log(data); */
          }), function(data, status, headers, config) {
              CalData.content = data;
          };

          selectedStatus = false;
        }


        this.calclick = function( day ){
          if( day['class'][availIndex] != "available" ){
            return; /* do nothing */
          }
          if( selectedStatus ){
            if(useDate.date == day.date){
              useDate['class'][selectIndex] = "unselected"
              useDate = "";
              selectedStatus = false;
            }else{
              useDate['class'][selectIndex] = "unselected"
              useDate = "";
              useDate = day;
              useDate['class'][selectIndex] = "selected"
              selectedStatus = true;
            }
          }else{
            useDate = day;
            useDate['class'][selectIndex] = "selected"
            selectedStatus = true;
          }
        }

	}]);


