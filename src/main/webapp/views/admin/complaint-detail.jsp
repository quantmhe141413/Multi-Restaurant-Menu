<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Complaint Detail" scope="request" />
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/views/includes/std_head.jsp" />
    <title>${pageTitle}</title>
</head>
<body>
<jsp:include page="/views/includes/header.jsp" />

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/views/includes/admin-sidebar.jsp" />

        <main class="col-md-9 col-lg-10 main-content">
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h1><i class="fas fa-triangle-exclamation text-primary"></i> Complaint Detail</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/complaints?action=list">Complaint Management</a></li>
                            <li class="breadcrumb-item active">Detail</li>
                        </ol>
                    </nav>
                </div>
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/complaints?action=list">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
            </div>

            <c:if test="${not empty complaint}">
                <div class="card mb-4">
                    <div class="card-header">
                        <h4 class="mb-0"><i class="fas fa-file-alt"></i> Complaint Information</h4>
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <div class="text-muted small">Complaint ID</div>
                                <div><strong>#${complaint.complaintID}</strong></div>
                            </div>
                            <div class="col-md-4">
                                <div class="text-muted small">Created At</div>
                                <div><strong>${complaint.createdAt}</strong></div>
                            </div>
                            <div class="col-md-4">
                                <div class="text-muted small">Status</div>
                                <div><span class="badge bg-secondary">${complaint.status}</span></div>
                            </div>

                            <div class="col-md-6">
                                <div class="text-muted small">Customer</div>
                                <div><strong>${complaint.customerName}</strong></div>
                                <div class="text-muted small">${complaint.customerEmail}</div>
                            </div>
                            <div class="col-md-6">
                                <div class="text-muted small">Restaurant</div>
                                <div><strong>${complaint.restaurantName}</strong></div>
                                <div class="text-muted small">Order #${complaint.orderID} (${complaint.orderStatus})</div>
                            </div>

                            <div class="col-12">
                                <div class="text-muted small">Description</div>
                                <div class="border rounded p-3 bg-light">${complaint.description}</div>
                            </div>
                        </div>
                    </div>
                </div>
             
                <div class="card mb-4">
                    <div class="card-header">
                        <h4 class="mb-0"><i class="fas fa-pen-to-square"></i> Update Complaint</h4>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin/complaints" method="POST">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="${complaint.complaintID}">

                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label class="form-label text-muted small mb-1">Status <span class="text-danger">*</span></label>
                                    <select class="form-select" id="statusSelect" name="status" required>
                                        <option value="InProgress" ${complaint.status == 'Open' || complaint.status == 'InProgress' ? 'selected' : ''}>In Progress</option>
                                        <option value="Resolved" ${complaint.status == 'Resolved' ? 'selected' : ''}>Resolved</option>
                                        <option value="Rejected" ${complaint.status == 'Rejected' ? 'selected' : ''}>Rejected</option>
                                    </select>
                                </div>

                                <div class="col-md-8">
                                    <label class="form-label text-muted small mb-1">Admin Note</label>
                                    <input type="text" class="form-control" id="noteInput" name="note"
                                           placeholder="Enter note to email restaurant owner">
                                    <small class="text-muted">
                                        Note is required. Email will be sent to restaurant owner before status update.
                                    </small>
                                </div>

                                <div class="col-12 d-flex gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save"></i> Save
                                    </button>
                                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/complaints?action=detail&id=${complaint.complaintID}">
                                        Cancel
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </c:if>

        </main>
    </div>
</div>

<jsp:include page="/views/includes/footer.jsp" />
<jsp:include page="/views/includes/std_scripts.jsp" />
<script>
    const status = document.getElementById('statusSelect');
    const note = document.getElementById('noteInput');

    function checkNote() {
        note.required = true;
    }

    status.onchange = checkNote;

    document.querySelector('form').onsubmit = function (e) {
        checkNote();
        if (note.required && note.value.trim() === '') {
            e.preventDefault();
            alert('Please enter admin note.');
            note.focus();
        }
    };

    checkNote();
</script>
</body>
</html>
