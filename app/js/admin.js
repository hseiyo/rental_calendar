/* 'use strict'; */

var app = angular.module("CalendarApp", []);

app.controller("CalendarAdminCtrl", [
  "$scope",
  "$http",
  "$log",
  function($scope, $http, $log) {
    var $uri = "/rencal/calendar/admin/";

    $scope.getHttp = function(class_name) {
      $http({
        method: "GET",
        url: $uri + class_name + "/"
      }).then(
        function(response) {
          $scope[class_name] = response.data;
          $log.debug(response);
        },
        function(response) {
          $log.debug(response);
        }
      );
    };

    $scope.getHttp("tools");
    $scope.getHttp("reservations");
    $scope.getHttp("users");

    $scope.updateItem = function(class_name, index) {
      $http({
        method: "PUT",
        url: $uri + class_name + "/" + $scope[class_name][index].id,
        data: {
          toolid: $scope[class_name][index].id,
          tooltype: $scope[class_name][index].tooltype,
          toolname: $scope[class_name][index].toolname,
          toolvalid: $scope[class_name][index].toolvalid
        }
      }).then(
        function(response) {
          $log.debug(response);
        },
        function(response) {
          $log.debug(response);
        }
      );
    };

    $scope.deleteItem = function(class_name, index) {
      $http({
        method: "DELETE",
        url: $uri + class_name + "/" + $scope[class_name][index].id,
        data: {}
      }).then(
        function(response) {
          $scope.tools.splice(index, 1);
          $log.debug(response);
        },
        function(response) {
          $log.debug(response);
        }
      );
    };

    $scope.makerequestdata = function(class_name) {
      switch (class_name) {
        case "tools":
          requestdata = {
            toolid: $scope.newtoolid,
            tooltype: $scope.newtooltype,
            toolname: $scope.newtoolname,
            toolvalid: $scope.newtoolvalid
          };
          break;
        case "reservations":
          requestdata = {
            rsvid: $scope.newrsvid,
            toolid: $scope.newrsvtoolid,
            userid: $scope.newrsvuserid,
            begin: $scope.newrsvbegin,
            finish: $scope.newrsvfinish
          };
          break;
        case "users":
          requestdata = {
            userid: $scope.newuserid,
            username: $scope.newusername
          };
          break;
        default:
          requestdata = {};
          break;
      }
      return requestdata;
    };

    $scope.pushandclearrequestdata = function(class_name, data) {
      switch (class_name) {
        case "tools":
          $scope.tools.push(data);
          $scope.newtoolid = "";
          $scope.newtooltype = "";
          $scope.newtoolname = "";
          $scope.newtoolvalid = "";
          break;
        case "reservations":
          $scope.reservations.push(data);
          $scope.newrsvid = "";
          $scope.newrsvtoolid = "";
          $scope.newrsvuserid = "";
          $scope.newrsvbegin = "";
          $scope.newrsvfinish = "";
          break;
        case "users":
          $scope.users.push(data);
          $scope.newuserid = "";
          $scope.newusername = "";
          break;
        default:
          break;
      }
    };
    $scope.addItem = function(class_name, index) {
      var requestdata = $scope.makerequestdata(class_name);

      $http({
        method: "POST",
        url: $uri + class_name + "/",
        data: requestdata
      }).then(
        function(response) {
          $scope.pushandclearrequestdata(class_name, response.data);
          $log.debug(response);
        },
        function(response) {
          $log.debug(response);
        }
      );
    };
  }
]);
