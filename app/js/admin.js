/* 'use strict'; */

/*
/* var app = angular.module('CalendarApp', ['ngResource']); */
/* app.controller('CalendarCtrl', ['$scope', '$http', function ($scope, $http) { */
var app = angular.module('CalendarApp', []);

app.controller('ViewCalendarCtrl', [ '$http' , function ($http) {

        // var useDate = "";
        // var selectedStatus = false;
        // var availIndex = 0;
        // var selectIndex = 1;

	var CalData = this;
        // CalData.content = null;
        // CalData.header = [ "sun","mon","tue","wed","thu","fri","sat" ];
        // CalData.areaoptions = [];
        // CalData.tooloptions = [];
 
        // CalData.area = CalData.areaoptions[2] ; /* days to transport : set default value */
        // CalData.tool = CalData.tooloptions[0] ; /* set default value */

        // var now = new Date();
        // CalData.year = now.getFullYear();
        // CalData.month = now.getMonth() + 1;

        var $uri ="/rencal/calendar/admin";
        // this.reloadCalendar = function( days ){
        $http({
            method : "GET",
          // url : $uri + "?days=" + CalData.area.value + "&year=" + CalData.year + "&month=" + CalData.month
          url : $uri
        }).then(function(response) {
            CalData.content = response;
        }), function(response) {
            CalData.content = response;
        };

        // selectedStatus = false;

        // this.reloadCalendar( CalData.area.value );

	}]);



//         this.updateArea = function( days ){
//           CalData.area = days;
//           this.reloadCalendar( CalData.area.value );
//         };
// 
//         this.clearSelect = function(){
//           for( let i=0; i < CalData.content.data.length ; i++ ){ /* week loop */
//             for( let j=0; j < CalData.content.data[i].length ; j++ ){ /* day loop */
//               CalData.content.data[i][j]['class'][selectIndex] = "unselected";
//             }
//           }
//         };
//   
// 
//         this.reserve = function(){
//           $http({
//               method : 'POST',
//             url : $uri + "?day=" + useDate.date + "&year=" + CalData.year + "&month=" + CalData.month + "&days=" + CalData.area.value
//           }).then(function(data, status, headers, config) {
//               CalData.content = data;
//           }), function(data, status, headers, config) {
//               CalData.content = data;
//           };
// 
//           selectedStatus = false;
//         };
// 
// 
//         this.calclick = function( day ){
//           if( day['class'][availIndex] != "available" ){
//             return; /* do nothing */
//           }
//           if( selectedStatus ){
//             if(useDate.date == day.date){
//               useDate['class'][selectIndex] = "unselected";
//               useDate = "";
//               selectedStatus = false;
//             }else{
//               useDate['class'][selectIndex] = "unselected";
//               useDate = "";
//               useDate = day;
//               useDate['class'][selectIndex] = "selected";
//               selectedStatus = true;
//             }
//           }else{
//             useDate = day;
//             useDate['class'][selectIndex] = "selected";
//             selectedStatus = true;
//           }
//         };
// 
// 
// 	}]);
// 
// 
