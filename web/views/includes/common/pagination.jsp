<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 
    Reusable pagination fragment.
    Required request attributes:
      - paginationUrl  : base URL (built via <c:url>) for page links
      - currentPage    : current page number (int)
      - totalPages     : total number of pages (int)
    Optional request attribute:
      - paginationLabel : text after "Total: X" (default: "items")
      - paginationTotal : total item count for display
--%>

<c:if test="${totalPages > 1}">
    <nav aria-label="Page navigation" class="mt-4">
        <ul class="pagination justify-content-center">
            <c:if test="${currentPage > 1}">
                <li class="page-item">
                    <a class="page-link" href="${paginationUrl}&page=1" title="First Page">
                        <i class="fas fa-angle-double-left"></i>
                    </a>
                </li>
                <li class="page-item">
                    <a class="page-link" href="${paginationUrl}&page=${currentPage - 1}" title="Previous">
                        <i class="fas fa-chevron-left"></i>
                    </a>
                </li>
            </c:if>

            <c:choose>
                <c:when test="${totalPages <= 7}">
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="${paginationUrl}&page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <c:if test="${currentPage > 3}">
                        <li class="page-item">
                            <a class="page-link" href="${paginationUrl}&page=1">1</a>
                        </li>
                        <c:if test="${currentPage > 4}">
                            <li class="page-item disabled">
                                <span class="page-link">...</span>
                            </li>
                        </c:if>
                    </c:if>

                    <c:forEach begin="${currentPage - 2 < 1 ? 1 : currentPage - 2}"
                               end="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}"
                               var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="${paginationUrl}&page=${i}">${i}</a>
                        </li>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages - 2}">
                        <c:if test="${currentPage < totalPages - 3}">
                            <li class="page-item disabled">
                                <span class="page-link">...</span>
                            </li>
                        </c:if>
                        <li class="page-item">
                            <a class="page-link" href="${paginationUrl}&page=${totalPages}">${totalPages}</a>
                        </li>
                    </c:if>
                </c:otherwise>
            </c:choose>

            <c:if test="${currentPage < totalPages}">
                <li class="page-item">
                    <a class="page-link" href="${paginationUrl}&page=${currentPage + 1}" title="Next">
                        <i class="fas fa-chevron-right"></i>
                    </a>
                </li>
                <li class="page-item">
                    <a class="page-link" href="${paginationUrl}&page=${totalPages}" title="Last Page">
                        <i class="fas fa-angle-double-right"></i>
                    </a>
                </li>
            </c:if>
        </ul>
        <c:if test="${not empty paginationTotal}">
            <div class="text-center text-muted mt-2">
                <small>Page ${currentPage} of ${totalPages} (Total: ${paginationTotal} ${not empty paginationLabel ? paginationLabel : 'items'})</small>
            </div>
        </c:if>
    </nav>
</c:if>
