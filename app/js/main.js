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
        var selectStatus = "unselected";
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

          selectStatus = "unselected";
        }

        this.calclick = function( day ){
          /* not selected */
          if( selectStatus == "unselected" ){
            startDate = day;
            startDate['class'][selectIndex] = "selected"
            selectStatus = "startselected";

          /* only startDate is selected */
          }else if(selectStatus == "startselected" ){
            /* ok */
            if(startDate.date < day.date){
              finishDate = day;
              finishDate['class'][selectIndex] = "selected"
              selectStatus = "bothselected";
            }
            /* ng */
            if(startDate.date >= day.date){
              startDate['class'][selectIndex] = "unselected"
              selectStatus = "unselected";
            }
            
          /* both startDate and finishDate are selected */
          }else{
            startDate['class'][selectIndex] = "unselected"
            finishDate['class'][selectIndex] = "unselected"
            startDate = day;
            startDate['class'][selectIndex] = "selected"
            selectStatus = "startselected";
          }
          
        }

	}]);


