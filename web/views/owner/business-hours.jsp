<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Business Hours Configuration" scope="request" />
<jsp:include page="/WEB-INF/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/includes/sidebar.jsp" />
        
        <!-- Main Content -->
        <main class="col-md-9 col-lg-10 main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h1><i class="fas fa-clock text-primary"></i> Business Hours Configuration</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                        <li class="breadcrumb-item active">Business Hours</li>
                    </ol>
                </nav>
            </div>

            <!-- Business Hours Form Card -->
            <div class="card shadow-sm">
                <div class="card-header" style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                    <h5 class="mb-0"><i class="fas fa-calendar-week"></i> Weekly Operating Hours</h5>
                </div>
                <div class="card-body">
                    <div class="alert alert-info" role="alert">
                        <i class="fas fa-info-circle"></i>
                        <strong>Note:</strong> Configure your restaurant's operating hours for each day of the week. 
                        The system will only accept online orders during these hours.
                    </div>

                    <form action="${pageContext.request.contextPath}/business-hours" method="POST">
                        <input type="hidden" name="action" value="update">
                        
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead style="background: #f8f9fa;">
                                    <tr>
                                        <th style="width: 20%;">Day of Week</th>
                                        <th style="width: 15%;">Status</th>
                                        <th style="width: 25%;">Opening Time</th>
                                        <th style="width: 25%;">Closing Time</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="hours" items="${hoursList}">
                                        <tr>
                                            <td>
                                                <strong><i class="fas fa-calendar-day text-primary"></i> ${hours.dayOfWeek}</strong>
                                            </td>
                                            <td>
                                                <div class="form-check form-switch">
                                                    <input class="form-check-input day-toggle" 
                                                           type="checkbox" 
                                                           name="${hours.dayOfWeek}_isOpen" 
                                                           value="1" 
                                                           id="${hours.dayOfWeek}_isOpen"
                                                           ${hours.isOpen ? 'checked' : ''}
                                                           onchange="toggleDayInputs('${hours.dayOfWeek}')">
                                                    <label class="form-check-label" for="${hours.dayOfWeek}_isOpen">
                                                        <span class="badge ${hours.isOpen ? 'bg-success' : 'bg-secondary'}">
                                                            ${hours.isOpen ? 'Open' : 'Closed'}
                                                        </span>
                                                    </label>
                                                </div>
                                            </td>
                                            <td>
                                                <input type="time" 
                                                       class="form-control ${hours.dayOfWeek}-time" 
                                                       name="${hours.dayOfWeek}_openingTime" 
                                                       value="<fmt:formatDate value='${hours.openingTime}' pattern='HH:mm' />"
                                                       ${!hours.isOpen ? 'disabled' : ''}>
                                            </td>
                                            <td>
                                                <input type="time" 
                                                       class="form-control ${hours.dayOfWeek}-time" 
                                                       name="${hours.dayOfWeek}_closingTime" 
                                                       value="<fmt:formatDate value='${hours.closingTime}' pattern='HH:mm' />"
                                                       ${!hours.isOpen ? 'disabled' : ''}>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <div class="text-center mt-4">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save"></i> Save Business Hours
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Business Rules Card -->
            <div class="card mt-4">
                <div class="card-header bg-light">
                    <h6 class="mb-0"><i class="fas fa-exclamation-triangle text-warning"></i> Business Rules</h6>
                </div>
                <div class="card-body">
                    <ul class="mb-0">
                        <li>System only accepts online orders during configured operating hours</li>
                        <li>Closing time must be after opening time for each day</li>
                        <li>Unchecked days will be marked as closed</li>
                        <li>Changes take effect immediately upon saving</li>
                    </ul>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
function toggleDayInputs(day) {
    const checkbox = document.getElementById(day + '_isOpen');
    const inputs = document.querySelectorAll('.' + day + '-time');
    const badge = checkbox.nextElementSibling.querySelector('.badge');
    
    if (checkbox.checked) {
        inputs.forEach(input => input.disabled = false);
        badge.textContent = 'Open';
        badge.className = 'badge bg-success';
    } else {
        inputs.forEach(input => input.disabled = true);
        badge.textContent = 'Closed';
        badge.className = 'badge bg-secondary';
    }
}
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
