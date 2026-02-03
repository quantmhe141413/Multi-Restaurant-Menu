<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Home - Multi-Restaurant Menu</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <style>
                :root {
                    --primary: #ff4757;
                    --secondary: #2f3542;
                    --light: #f1f2f6;
                    --dark: #2f3542;
                    --white: #ffffff;
                    --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                }

                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    background-color: #f8f9fa;
                    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                }

                .site-header {
                    background-color: white;
                    padding: 1rem 5%;
                    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                    position: sticky;
                    top: 0;
                    z-index: 1000;
                }

                .site-header__bar {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    max-width: 1400px;
                    margin: 0 auto;
                }

                .logo {
                    font-size: 1.5rem;
                    font-weight: bold;
                    color: #ff4757;
                    text-decoration: none;
                    transition: opacity 0.3s;
                }

                .logo:hover {
                    opacity: 0.8;
                }

                .nav-links {
                    display: flex;
                    align-items: center;
                    gap: 1.5rem;
                }

                .nav-links a {
                    text-decoration: none;
                    color: #2f3542;
                    font-weight: 500;
                    transition: color 0.3s;
                }

                .nav-links a:hover {
                    color: #ff4757;
                }

                .nav-user {
                    color: #57606f;
                }

                .nav-action {
                    color: #ff4757 !important;
                    font-weight: 600 !important;
                }

                .hero {
                    padding: 4rem 5%;
                    text-align: center;
                    background: linear-gradient(135deg, var(--primary), #ff6b81);
                    color: var(--white);
                }

                .search-container {
                    margin-top: 2rem;
                    display: flex;
                    justify-content: center;
                    gap: 0.5rem;
                    flex-wrap: wrap;
                }

                .search-container input,
                .search-container select {
                    padding: 0.8rem 1.5rem;
                    border: none;
                    border-radius: 25px;
                    outline: none;
                }

                .search-container input {
                    min-width: 260px;
                }

                .search-container select {
                    background-color: var(--white);
                    color: var(--secondary);
                }

                .search-container button {
                    padding: 0.8rem 2rem;
                    border: none;
                    background-color: var(--secondary);
                    color: var(--white);
                    border-radius: 25px;
                    cursor: pointer;
                    transition: background 0.3s;
                }

                .search-container button:hover {
                    background-color: #000;
                }

                .container {
                    max-width: 1200px;
                    margin: 3rem auto;
                    padding: 0 1rem;
                }

                .restaurant-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                    gap: 2rem;
                }

                .restaurant-card {
                    background-color: var(--white);
                    border-radius: 12px;
                    overflow: hidden;
                    box-shadow: var(--shadow);
                    transition: transform 0.3s;
                }

                .restaurant-card:hover {
                    transform: translateY(-5px);
                }

                .restaurant-image {
                    width: 100%;
                    height: 200px;
                    object-fit: cover;
                    background-color: #ddd;
                }

                .restaurant-info {
                    padding: 1.5rem;
                }

                .restaurant-name {
                    font-size: 1.25rem;
                    font-weight: bold;
                    margin-bottom: 0.5rem;
                }

                .restaurant-address {
                    color: #747d8c;
                    font-size: 0.9rem;
                    margin-bottom: 1rem;
                }

                .btn-view {
                    display: inline-block;
                    padding: 0.6rem 1.2rem;
                    background-color: var(--primary);
                    color: var(--white);
                    text-decoration: none;
                    border-radius: 6px;
                    font-weight: 500;
                    transition: opacity 0.3s;
                }

                .btn-view:hover {
                    opacity: 0.9;
                }

                .site-footer {
                    background-color: #2f3542;
                    color: white;
                    padding: 2rem 5%;
                    margin-top: 4rem;
                    text-align: center;
                }

                .site-footer__inner {
                    max-width: 1400px;
                    margin: 0 auto;
                }

                .site-footer p {
                    margin: 0;
                }
            </style>
        </head>

        <body>

            <jsp:include page="includes/header.jsp" />

            <section class="hero">
                <h1>Discover the best food near you</h1>
                <form action="home" method="get" class="search-container" id="searchForm">
                    <input type="text" name="search" placeholder="Search for restaurants..." value="${currentSearch}">
                    <select name="zone" id="zoneSelect">
                        <option value="">All areas</option>
                        <c:forEach var="z" items="${zones}">
                            <option value="${z}" <c:if test="${z == selectedZone}">selected</c:if>>${z}</option>
                        </c:forEach>
                    </select>
                    <button type="submit"><i class="fas fa-search"></i> Search</button>
                </form>
            </section>

            <div class="container">
                <h2>Restaurants</h2>
                <div class="restaurant-grid">
                    <c:forEach var="r" items="${restaurants}">
                        <div class="restaurant-card">
                            <img src="${r.logoUrl}" alt="${r.name}" class="restaurant-image"
                                onerror="this.src='https://chuphinhmonan.com/wp-content/uploads/2017/03/15190142704_6ba141723c_z.jpg'">
                            <div class="restaurant-info">
                                <div class="restaurant-name">${r.name}</div>
                                <div class="restaurant-address"><i class="fas fa-map-marker-alt"></i> ${r.address}</div>
                                <a href="menu?restaurantId=${r.restaurantId}" class="btn-view">View Menu</a>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty restaurants}">
                        <p>No restaurants found.</p>
                    </c:if>
                </div>
            </div>

            <jsp:include page="includes/footer.jsp" />

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const zoneSelect = document.getElementById('zoneSelect');
                    if (zoneSelect) {
                        zoneSelect.addEventListener('change', function () {
                            document.getElementById('searchForm').submit();
                        });
                    }
                });
            </script>

        </body>

        </html>