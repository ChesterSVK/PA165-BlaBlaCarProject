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
<blablacar-tags:page-template title="Homepage">
    <jsp:attribute name="head">
        <!--Load only necessary files-->
        <meta name="google-signin-client_id"
              content="332736943859-mrr2173fc1kseq1l2i4h0na68mnpmbp3.apps.googleusercontent.com">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/styles/welcome.css"
              crossorigin="anonymous">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/styles/style.css" type="text/css"
              crossorigin="anonymous">
    </jsp:attribute>
    <jsp:attribute name="body">

        <c:set var="contextPath" value="${pageContext.request.contextPath}"/>


        <c:if test="${userSession.userIsLoggedIn}">
            <div class="jumbotron row text-center">
                <div class="col-xs-6">
                    <a href="${contextPath}/user" class="btn btn-default">
                        Your Rides
                    </a>
                </div>
                <div class="col-xs-6">
                    <a href="${contextPath}/ride/search" class="btn btn-default">
                        Search Rides
                    </a>
                </div>
            </div>
        </c:if>

        <script>
        </script>
    </jsp:attribute>
    <jsp:attribute name="foot">
        <!--Load only necessary files-->
        <script src='<c:url value="/resources/javascript/autocomplete/jquery.easy-autocomplete.min.js"/>'></script>
        <script>
            var dataArray = [];
            <c:forEach items="${places}" var="placeF">
                dataArray.push("${placeF.name}");
            </c:forEach>

            var options = {
                data: dataArray,
                list: {
                    match: {
                        enabled: true
                    }
                }
            };

            $("#autocomplete-from").easyAutocomplete(options);
            $("#autocomplete-to").easyAutocomplete(options);
        </script>
    </jsp:attribute>
</blablacar-tags:page-template>