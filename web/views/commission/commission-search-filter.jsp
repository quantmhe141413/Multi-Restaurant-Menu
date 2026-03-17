<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="card mb-4">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/admin/commission" method="GET">
            <input type="hidden" name="action" value="list">
            <div class="row g-3 align-items-center">
                <div class="col-md-10">
                    <label class="form-label text-muted small mb-1"><i class="fas fa-search"></i> Search</label>
                    <input type="text" class="form-control" name="search"
                           placeholder="Search by restaurant name, license, owner name/email..." value="${param.search}">
                </div>
                <div class="col-md-2">
                    <label class="form-label text-muted small mb-1 d-block">&nbsp;</label>
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-filter"></i> Apply Filters
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>
