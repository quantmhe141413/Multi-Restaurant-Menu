<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
    Simple pagination for admin pages.
    Required request attributes:
      - paginationUrl
      - currentPage
      - totalPages
    Optional request attributes:
      - paginationTotal
      - paginationLabel
--%>

<c:if test="${totalPages > 1}">
    <c:set var="startPage" value="${currentPage - 2 < 1 ? 1 : currentPage - 2}" />
    <c:set var="endPage" value="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}" />

    <nav aria-label="Page navigation" class="mt-4">
        <ul class="pagination justify-content-center">
            <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                <c:choose>
                    <c:when test="${currentPage <= 1}">
                        <span class="page-link" title="Previous">
                            <i class="fas fa-chevron-left"></i>
                        </span>
                    </c:when>
                    <c:otherwise>
                        <a class="page-link" href="${paginationUrl}&page=${currentPage - 1}" title="Previous">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                    </c:otherwise>
                </c:choose>
            </li>

            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                <li class="page-item ${currentPage == i ? 'active' : ''}">
                    <a class="page-link" href="${paginationUrl}&page=${i}">${i}</a>
                </li>
            </c:forEach>

            <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                <c:choose>
                    <c:when test="${currentPage >= totalPages}">
                        <span class="page-link" title="Next">
                            <i class="fas fa-chevron-right"></i>
                        </span>
                    </c:when>
                    <c:otherwise>
                        <a class="page-link" href="${paginationUrl}&page=${currentPage + 1}" title="Next">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </c:otherwise>
                </c:choose>
            </li>
        </ul>

        <c:if test="${not empty paginationTotal}">
            <div class="text-center text-muted mt-2">
                <small>
                    Page ${currentPage} of ${totalPages}
                    (Total: ${paginationTotal} ${not empty paginationLabel ? paginationLabel : 'items'})
                </small>
            </div>
        </c:if>
    </nav>
</c:if>
