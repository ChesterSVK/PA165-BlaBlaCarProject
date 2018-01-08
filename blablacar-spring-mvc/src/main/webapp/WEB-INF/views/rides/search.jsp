<%@ page contentType="text/html;charset=UTF-8" pageEncoding="utf-8" trimDirectiveWhitespaces="true" session="false" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="blablacar-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%--
  Created by IntelliJ IDEA.
  User: jcibik
  Date: 12/4/17
  Time: 11:17 AM
  To change this template use File | Settings | File Templates.
--%>
<blablacar-tags:page-template title="Search ride">
    <jsp:attribute name="head">
        <!--Load only necessary files-->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/styles/ride.css"
              crossorigin="anonymous">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/styles/style.css"
              crossorigin="anonymous">
    </jsp:attribute>
    <jsp:attribute name="body">

        <nav class="navbar">
            <a class="btn btn-default" href="${pageContext.request.contextPath}/ride/list">All rides</a>
        </nav>
            <div class="jumbotron row">
                <form:form method="post" action="${pageContext.request.contextPath}/ride/find" id="search-form"
                           modelAttribute="placeForm">
                    <div class="col-xs-6 background text-center">
                        <div id="background1">
                            <div class="green-shader">
                                <h3 class="c-white">From</h3>
                                <form:select path="fromId" type="text" form="search-form">
                                    <c:forEach items="${places}" var="placeF">
                                        <form:option value="${placeF.id}" name="${placeF.name}">
                                            ${placeF.name}
                                        </form:option>
                                    </c:forEach>
                                </form:select>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-6 background text-center">
                        <div id="background2">
                            <div class="green-shader">
                                <h3 class="c-white">To:</h3>
                                <form:select path="toId" type="text" form="search-form">
                                    <c:forEach items="${places}" var="placeF">
                                        <form:option value="${placeF.id}" name="${placeF.name}">
                                            ${placeF.name}
                                        </form:option>
                                    </c:forEach>
                                </form:select>
                            </div>
                        </div>
                    </div>
                    <button class="col-xs-12" type="submit">Find</button>
                </form:form>
            </div>

        <div class="jumbotron">

        <c:if test="${(fn:length(rides) eq 0)}">
            <h3>
                No result
            </h3>
        </c:if>
            <c:if test="${not (fn:length(rides) eq 0)}">
            <table class="table rides-list table-hover">
                <thead>
                <tr>
                    <td>DRIVER</td>
                    <td>DATE</td>
                    <td>FROM</td>
                    <td>TO</td>
                    <td>SEATS</td>
                    <td>PRIZE</td>
                </tr>
                </thead>
                <c:forEach var="ride" items="${rides}">
                    <tr class="ride-item">
                        <td>
                            <c:out value="${ride.driver.name}"></c:out>
                        </td>
                        <td>
                            <c:out value="${ride.departure}"></c:out>
                        </td>
                        <td>
                            <c:out value="${ride.sourcePlace.name}"></c:out>
                        </td>
                        <td>
                            <c:out value="${ride.destinationPlace.name}"></c:out>
                        </td>
                        <td>
                            <c:out value="${ride.availableSeats}"></c:out>
                        </td>
                        <td>
                            <c:out value="${ride.seatPrice}"></c:out>
                        </td>
                        <td>
                            <c:if test="${(not fn:contains(ride.passengers, userSession.user)) && (not (ride.driver.id eq userSession.userId)) && (ride.availableSeats gt 0) }">
                                <form:form action="${pageContext.request.contextPath}/ride/addPassenger" id="join-ride"
                                           method="get">
                                    <button type="submit" class="btn btn-primary" name="rideId" value="${ride.id}">Join
                                        ride
                                    </button>
                                </form:form>
                            </c:if>
                            <c:if test="${fn:contains(ride.passengers, userSession.user)}">
                                <form:form action="${pageContext.request.contextPath}/ride/removePassenger"
                                           id="join-ride"
                                           method="get">
                                    <button type="submit" class="btn btn-primary" name="rideId" value="${ride.id}">Leave
                                        ride
                                    </button>
                                </form:form>
                            </c:if>
                        </td>
                        <td>
                            <a class="btn btn-default"
                               href="${pageContext.request.contextPath}/ride/showRide/${ride.id}">Join Disscusion</a>
                        </td>
                    </tr>

                </c:forEach>
            </table>
        </c:if>
        </div>
    </jsp:attribute>


    <jsp:attribute name="foot">
        <!--Load only necessary files-->

        <script>
            $(document).ready(function () {
                $("#background1").addClass("background-" + ($(this).find("#background1 option:selected").attr("name")));
                $("#background2").addClass("background-" + ($(this).find("#background2 option:selected").attr("name")));
                $("#background1 select").change(function () {
                    $("#background1").removeClass();
                    $("#background1").addClass("background-" + ($(this).find("option:selected").attr("name")));
                });
                $("#background2 select").change(function () {
                    $("#background2").removeClass();
                    $("#background2").addClass("background-" + ($(this).find("option:selected").attr("name")));
                });
            });

        </script>

    </jsp:attribute>
</blablacar-tags:page-template>
