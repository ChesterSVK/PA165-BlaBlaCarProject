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
<fmt:message key="page.welcome.title" var="title"/>
<blablacar-tags:page-template title="${title}">
    <jsp:attribute name="head">
        <!--Load only necessary files-->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/styles/ride.css"
              crossorigin="anonymous">
    </jsp:attribute>
    <jsp:attribute name="body">
        <nav class="navbar navbar-default">
            <div class="container-fluid">
                <ul class="nav navbar-nav">
                    <li>
                        <a class="btn btn-default" href="${pageContext.request.contextPath}/ride/list">
                            All rides
                        </a>
                    </li>
                    <li>
                        <a class="btn btn-default" href="${pageContext.request.contextPath}/ride/new">
                            New Ride
                        </a>
                    </li>
                </ul>
            </div>
        </nav>
        <c:if test="${fn:length(rides) eq 0}">
                        <p>No rides</p>
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
                                <c:if test="${ride.driver.id eq userSession.userId}">
                                    <form:form action="${pageContext.request.contextPath}/ride/delete" id="join-ride" method="get">
                                        <button type="submit" class="btn btn-primary" name="rideId" value="${ride.id}">Remove ride
                                        </button>
                                    </form:form>
                                </c:if>
                            </td>
                        </tr>
            </c:forEach>
            </table>
        </c:if>
    </jsp:attribute>
    <jsp:attribute name="foot">
        <!--Load only necessary files-->

    </jsp:attribute>
</blablacar-tags:page-template>