/* 'use strict'; */

var app = angular.module("CalendarApp", []);

app.controller("CalendarAdminCtrl", [
  "$scope",
  "$http",
  "$log",
  function($scope, $http, $log) {
    // var CalData = this;

    var $uri = "/rencal/calendar/admin/tools";
    $http({
      method: "GET",
      url: $uri
    }).then(
      function(response) {
        $scope.tools = response.data;
        $log.debug(response);
      },
      function(response) {
        //CalData.content = response;
        $log.debug(response);
      }
    );

    $scope.updateTool = function(index) {
      $http({
        method: "PUT",
        url: $uri + "/" + $scope.tools[index].id,
        data: {
          toolid: $scope.tools[index].toolid,
          tooltype: $scope.tools[index].tooltype,
          name: $scope.tools[index].name
        }
      }).then(
        function(response) {
          // CalData.tools = response.data;
          $log.debug(response);
        },
        function(response) {
          // CalData.content = response;
          $log.debug(response);
        }
      );
    };

    $scope.deleteTool = function(index) {
      $http({
        method: "DELETE",
        url: $uri + "/" + $scope.tools[index].id,
        data: {}
      }).then(
        function(response) {
          $scope.tools.splice(index, 1);
          // CalData.tools = response.data;
          $log.debug(response);
        },
        function(response) {
          // CalData.content = response;
          $log.debug(response);
        }
      );
    };

    $scope.addTool = function(index) {
      $http({
        method: "POST",
        url: $uri,
        data: {
          toolid: $scope.newtoolid,
          tooltype: $scope.newtooltype,
          name: $scope.newtoolname
        }
      }).then(
        function(response) {
          $scope.tools.push(response.data);
          $scope.newtoolid = "";
          $scope.newtooltype = "";
          $scope.newtoolname = "";
          // CalData.tools = response.data;
          $log.debug(response);
        },
        function(response) {
          // CalData.content = response;
          $log.debug(response);
        }
      );
    };
  }
]);

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
